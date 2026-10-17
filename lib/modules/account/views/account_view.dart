import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/account_controller.dart';
import '../../main/controllers/main_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tài khoản',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Obx(
            () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileCard(),

              const SizedBox(height: 20),

              if (!controller.isLoggedIn.value) ...[
                _buildLoginButton(),
                const SizedBox(height: 12),
                _buildSignupButton(),
                const SizedBox(height: 24),
              ],

              _buildSectionTitle('Đơn hàng'),

              const SizedBox(height: 10),

              _buildMenuItem(
                icon: Icons.receipt_long_outlined,
                title: 'Đơn hàng của tôi',
                subtitle: 'Theo dõi các đơn hàng',
                onTap: () {
                  Get.find<MainController>().changeTab(2);
                  Get.back();
                },
              ),

              _buildMenuItem(
                icon: Icons.history,
                title: 'Lịch sử đơn hàng',
                subtitle: 'Xem lại các đơn hàng đã mua',
                onTap: () {
                  Get.find<MainController>().openHistory();
                  Get.back();
                },
              ),

              const SizedBox(height: 20),

              _buildSectionTitle('Khác'),

              const SizedBox(height: 10),

              _buildMenuItem(
                icon: Icons.notifications_none_outlined,
                title: 'Thông báo',
                subtitle: 'Ưu đãi và thông tin đơn hàng',
                onTap: () {
                  Get.find<MainController>().openNotifications();
                  Get.back();
                },
              ),

              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'Cài đặt',
                subtitle: 'Tùy chỉnh ứng dụng',
                onTap: () {
                  Get.snackbar(
                    'Cài đặt',
                    'Chức năng cài đặt sẽ được thêm sau.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),

              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Trợ giúp',
                subtitle: 'Câu hỏi thường gặp và hỗ trợ',
                onTap: () {
                  Get.snackbar(
                    'Trợ giúp',
                    'Chức năng hỗ trợ sẽ được thêm sau.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),

              if (controller.isLoggedIn.value) ...[
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      controller.logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Đăng xuất'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    final isLoggedIn = controller.isLoggedIn.value;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: isLoggedIn
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.username.value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  controller.phone.value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            )
                : const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn chưa đăng nhập',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Đăng nhập để quản lý tài khoản và đơn hàng.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: controller.signup,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(
            color: AppColors.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Tạo tài khoản',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}