import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../account/controllers/account_controller.dart';
import '../../../data/providers/api_client.dart';
import '../../orders/controllers/orders_controller.dart';

class AuthController extends GetxController {
  AuthController({required this.apiProvider});

  final ApiClient apiProvider;
  final isSubmitting = false.obs;
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signupNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPhoneController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();
  final resetEmailController = TextEditingController();
  final resetCodeController = TextEditingController();
  final resetPasswordController = TextEditingController();
  final resetConfirmPasswordController = TextEditingController();
  final signupCodeController = TextEditingController();

  final loginPasswordVisible = false.obs;
  final signupPasswordVisible = false.obs;
  final signupConfirmPasswordVisible = false.obs;

  final rememberMe = false.obs;
  final agreeToTerms = false.obs;
  final resetCodeSent = false.obs;
  final resetPasswordVisible = false.obs;
  final resetConfirmPasswordVisible = false.obs;
  final signupCodeSent = false.obs;

  @override
  void onInit() {
    super.onInit();
    final email = Get.arguments;
    if (email is String && email.trim().isNotEmpty) {
      resetEmailController.text = email.trim();
    }
  }

  Future<void> requestPasswordReset() async {
    final email = resetEmailController.text.trim();
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Email chưa hợp lệ',
        'Vui lòng nhập địa chỉ email chính xác.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      await apiProvider.requestPasswordReset(email: email);
      resetCodeSent.value = true;
      Get.snackbar(
        'Kiểm tra email',
        'Nếu email đã đăng ký, mã xác thực sẽ được gửi đến hộp thư của bạn.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Chưa gửi được mã',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> submitPasswordReset() async {
    final email = resetEmailController.text.trim();
    final code = resetCodeController.text.trim();
    final password = resetPasswordController.text;
    if (code.length != 6 || int.tryParse(code) == null) {
      Get.snackbar(
        'Mã chưa hợp lệ',
        'Nhập mã xác thực gồm 6 chữ số.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (password.length < 8) {
      Get.snackbar(
        'Mật khẩu quá ngắn',
        'Mật khẩu mới cần ít nhất 8 ký tự.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (password != resetConfirmPasswordController.text) {
      Get.snackbar(
        'Mật khẩu không khớp',
        'Vui lòng nhập lại mật khẩu xác nhận.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      await apiProvider.resetPassword(
        email: email,
        code: code,
        password: password,
      );
      Get.snackbar(
        'Đổi mật khẩu thành công',
        'Bạn có thể đăng nhập bằng mật khẩu mới.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed(AppRoutes.login);
    } catch (error) {
      Get.snackbar(
        'Không thể đổi mật khẩu',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void toggleLoginPassword() {
    loginPasswordVisible.toggle();
  }

  void toggleSignupPassword() {
    signupPasswordVisible.toggle();
  }

  void toggleSignupConfirmPassword() {
    signupConfirmPasswordVisible.toggle();
  }

  Future<void> login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Thiếu thông tin',
        'Vui lòng nhập email và mật khẩu.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      final response = await apiProvider.login(
        email: email,
        password: password,
      );
      final user = response['user'];
      if (user is Map) _setSignedInUser(user);
      Get.offAllNamed(AppRoutes.main);
    } catch (error) {
      Get.snackbar(
        'Đăng nhập thất bại',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> signup() async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final phone = signupPhoneController.text.trim();
    final password = signupPasswordController.text;
    final confirmPassword = signupConfirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        'Thiếu thông tin',
        'Vui lòng điền đầy đủ thông tin.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Mật khẩu không khớp',
        'Vui lòng kiểm tra lại mật khẩu xác nhận.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!agreeToTerms.value) {
      Get.snackbar(
        'Chưa đồng ý điều khoản',
        'Vui lòng đồng ý với điều khoản sử dụng.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Email chưa hợp lệ',
        'Vui lòng nhập địa chỉ email chính xác.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!signupCodeSent.value) {
      await requestSignupCode();
      return;
    }

    final code = signupCodeController.text.trim();
    if (code.length != 6 || int.tryParse(code) == null) {
      Get.snackbar(
        'Mã chưa hợp lệ',
        'Nhập mã xác thực gồm 6 chữ số.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      final response = await apiProvider.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
        code: code,
      );
      final user = response['user'];
      if (user is Map) {
        _setSignedInUser(user);
        signupCodeSent.value = false;
        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.snackbar(
          'Đăng ký thành công',
          'Vui lòng đăng nhập để tiếp tục.',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (error) {
      Get.snackbar(
        'Đăng ký thất bại',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> requestSignupCode() async {
    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final phone = signupPhoneController.text.trim();
    if (name.isEmpty || phone.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        'Thiếu thông tin',
        'Nhập họ tên, email hợp lệ và số điện thoại trước.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    try {
      await apiProvider.requestSignupCode(
        name: name,
        phone: phone,
        email: email,
      );
      signupCodeSent.value = true;
      Get.snackbar(
        'Kiểm tra email',
        'Nếu email chưa được sử dụng, mã xác thực sẽ được gửi đến hộp thư.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Chưa gửi được mã',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void _setSignedInUser(Map user) {
    if (!Get.isRegistered<AccountController>()) {
      Get.put<AccountController>(
        AccountController(apiProvider: apiProvider),
        permanent: true,
      );
    }
    Get.find<AccountController>().setProfile(
      username: user['name']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
      phone: user['phone']?.toString() ?? '',
      id: user['id']?.toString() ?? '',
      tier: user['membershipTier']?.toString() ?? 'BRONZE',
      points: (user['loyaltyPoints'] as num?)?.toInt() ?? 0,
    );
    if (Get.isRegistered<OrdersController>()) {
      Get.find<OrdersController>().loadMyOrders();
    }
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();

    signupNameController.dispose();
    signupEmailController.dispose();
    signupPhoneController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    resetEmailController.dispose();
    resetCodeController.dispose();
    resetPasswordController.dispose();
    resetConfirmPasswordController.dispose();
    signupCodeController.dispose();

    super.onClose();
  }
}
