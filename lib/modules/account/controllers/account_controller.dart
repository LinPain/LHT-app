import 'package:get/get.dart';

import '../../../data/providers/api_client.dart';

class AccountController extends GetxController {
  AccountController({required this.apiProvider});

  final ApiClient apiProvider;
  final isLoggedIn = false.obs;

  final username = ''.obs;
  final phone = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final customerId = ''.obs;
  final membershipTier = 'BRONZE'.obs;
  final loyaltyPoints = 0.obs;
  final pointsHistory = <Map<String, dynamic>>[].obs;
  final vouchers = <Map<String, dynamic>>[].obs;

  String get membershipTierLabel {
    switch (membershipTier.value.toUpperCase()) {
      case 'BRONZE':
        return 'ĐỒNG';
      case 'SILVER':
        return 'BẠC';
      case 'GOLD':
        return 'VÀNG';
      case 'PLATINUM':
        return 'BẠCH KIM';
      default:
        return membershipTier.value;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
    loadVouchers();
  }

  Future<void> _restoreSession() async {
    if (!await apiProvider.hasAccessToken()) return;
    try {
      final response = await apiProvider.get('/api/auth/me');
      if (response is Map) {
        setProfile(
          username: response['name']?.toString() ?? '',
          email: response['email']?.toString() ?? '',
          phone: response['phone']?.toString() ?? '',
          id: response['id']?.toString() ?? '',
          tier: response['membershipTier']?.toString() ?? 'BRONZE',
          points: (response['loyaltyPoints'] as num?)?.toInt() ?? 0,
        );
      }
    } catch (_) {
      await apiProvider.clearTokens();
    }
  }

  void login() {
    Get.toNamed('/login');
  }

  void signup() {
    Get.toNamed('/signup');
  }

  void loginUser({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) {
    this.username.value = username;
    this.email.value = email;
    this.phone.value = phone;
    this.password.value = '';
    isLoggedIn.value = true;
  }

  void setProfile({
    required String username,
    required String email,
    required String phone,
    String id = '',
    String tier = 'BRONZE',
    int points = 0,
  }) {
    this.username.value = username;
    this.email.value = email;
    this.phone.value = phone;
    customerId.value = id;
    membershipTier.value = tier;
    loyaltyPoints.value = points;
    password.value = '';
    isLoggedIn.value = true;
    if (id.isNotEmpty) loadMembershipDetails();
  }

  Future<void> loadMembershipDetails() async {
    final id = customerId.value;
    if (id.isEmpty || !isLoggedIn.value) return;
    try {
      final data = await apiProvider.get('/api/customers/$id');
      if (data is! Map) return;
      membershipTier.value =
          data['membershipTier']?.toString() ?? membershipTier.value;
      loyaltyPoints.value =
          (data['loyaltyPoints'] as num?)?.toInt() ?? loyaltyPoints.value;
      final history = data['pointsHistory'];
      if (history is List) {
        pointsHistory.assignAll(
          history.whereType<Map>().map(
            (item) => Map<String, dynamic>.from(item),
          ),
        );
      }
    } catch (_) {
      // Keep the profile values returned by /api/auth/me when history is unavailable.
    }
  }

  Future<void> loadVouchers() async {
    try {
      final data = await apiProvider.get('/api/customers/vouchers');
      if (data is List) {
        vouchers.assignAll(
          data.whereType<Map>().map((item) => Map<String, dynamic>.from(item)),
        );
      }
    } catch (_) {
      vouchers.clear();
    }
  }

  bool authenticate({required String identifier, required String password}) {
    final matchesUsername = username.value == identifier;
    final matchesEmail = email.value == identifier;
    final isValid =
        (matchesUsername || matchesEmail) && this.password.value == password;

    if (isValid) {
      isLoggedIn.value = true;
    }

    return isValid;
  }

  Future<void> logout() async {
    try {
      await apiProvider.logout();
    } catch (_) {
      // Local sign-out must still work if the server is unavailable.
      await apiProvider.clearTokens();
    }
    isLoggedIn.value = false;
    username.value = '';
    phone.value = '';
    email.value = '';
    customerId.value = '';
    membershipTier.value = 'BRONZE';
    loyaltyPoints.value = 0;
    pointsHistory.clear();
  }
}
