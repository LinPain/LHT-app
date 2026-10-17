import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class ApiProvider implements ApiClient {
  ApiProvider({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<void>? _refreshInProgress;

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Client-Platform': 'mobile',
  };

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  @override
  Future<dynamic> get(String path) => _request('GET', path);

  Future<List<dynamic>> getProducts() async {
    final data = await get('/api/products');
    if (data is! List) throw Exception('Danh sách sản phẩm không hợp lệ.');
    return data;
  }

  @override
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) =>
      _request('POST', path, body: body);
  @override
  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) =>
      _request('PATCH', path, body: body);
  @override
  Future<dynamic> put(String path, {Map<String, dynamic>? body}) =>
      _request('PUT', path, body: body);

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool retry = true,
  }) async {
    final accessToken = await _storage.read(key: 'accessToken');
    final headers = <String, String>{..._headers};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    http.Response response;
    try {
      final uri = _uri(path);
      switch (method) {
        case 'GET':
          response = await _client
              .get(uri, headers: headers)
              .timeout(const Duration(seconds: 15));
          break;
        case 'POST':
          response = await _client
              .post(uri, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(const Duration(seconds: 15));
          break;
        case 'PATCH':
          response = await _client
              .patch(uri, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(const Duration(seconds: 15));
          break;
        case 'PUT':
          response = await _client
              .put(uri, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(const Duration(seconds: 15));
          break;
        default:
          throw UnsupportedError('Unsupported method $method');
      }
    } on http.ClientException catch (error) {
      throw Exception('Không thể kết nối máy chủ: ${error.message}');
    } on TimeoutException {
      throw Exception('Kết nối máy chủ quá thời gian chờ.');
    }

    if (response.statusCode == 401 && retry) {
      final refreshed = await _refreshToken();
      if (refreshed) return _request(method, path, body: body, retry: false);
    }

    final decoded = _decode(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map
          ? (decoded['error'] ?? decoded['message'])
          : null;
      throw Exception(
        message?.toString() ?? 'API lỗi HTTP ${response.statusCode}.',
      );
    }
    if (decoded is Map && decoded['success'] == false) {
      throw Exception(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Thao tác thất bại.',
      );
    }
    return decoded is Map && decoded.containsKey('data')
        ? decoded['data']
        : decoded;
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw Exception(
        'Máy chủ trả về dữ liệu không hợp lệ (HTTP ${response.statusCode}).',
      );
    }
  }

  Future<bool> _refreshToken() async {
    final pending = _refreshInProgress;
    if (pending != null) {
      await pending;
      return (await _storage.read(key: 'accessToken')) != null;
    }
    final completer = Completer<void>();
    _refreshInProgress = completer.future;
    try {
      final refreshToken = await _storage.read(key: 'refreshToken');
      if (refreshToken == null || refreshToken.isEmpty) return false;
      final response = await _client
          .post(
            _uri('/api/auth/refresh-token'),
            headers: _headers,
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        await clearTokens();
        return false;
      }
      final body = _decode(response);
      final data = body is Map ? body['data'] : null;
      if (data is! Map || data['accessToken'] == null) {
        await clearTokens();
        return false;
      }
      await saveTokens(
        data['accessToken'].toString(),
        data['refreshToken']?.toString(),
      );
      return true;
    } catch (_) {
      await clearTokens();
      return false;
    } finally {
      completer.complete();
      _refreshInProgress = null;
    }
  }

  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: 'refreshToken', value: refreshToken);
    }
  }

  @override
  Future<void> clearTokens() async => _storage.deleteAll();

  @override
  Future<void> logout() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    if (refreshToken != null) {
      await post('/api/auth/logout', body: {'refreshToken': refreshToken});
    }
    await clearTokens();
  }

  @override
  Future<bool> hasAccessToken() async =>
      (await _storage.read(key: 'accessToken'))?.isNotEmpty ?? false;

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) =>
      _authenticate('/api/auth/login', {'email': email, 'password': password});

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String code,
  }) => _authenticate('/api/auth/register', {
    'name': name,
    'phone': phone,
    'email': email,
    'password': password,
    'code': code,
    'role': 'CUSTOMER',
  });

  @override
  Future<void> requestSignupCode({
    required String name,
    required String phone,
    required String email,
  }) async {
    await post(
      '/api/auth/register/request-code',
      body: {'name': name, 'phone': phone, 'email': email},
    );
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    await post('/api/auth/forgot-password', body: {'email': email});
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    await post(
      '/api/auth/reset-password',
      body: {'email': email, 'code': code, 'password': password},
    );
  }

  Future<Map<String, dynamic>> _authenticate(
    String path,
    Map<String, dynamic> body,
  ) async {
    final data = await _request('POST', path, body: body);
    if (data is! Map<String, dynamic>) {
      throw Exception('Phản hồi xác thực không đúng định dạng.');
    }
    final accessToken = data['accessToken']?.toString();
    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Máy chủ chưa trả access token cho mobile.');
    }
    await saveTokens(accessToken, data['refreshToken']?.toString());
    return data;
  }
}
