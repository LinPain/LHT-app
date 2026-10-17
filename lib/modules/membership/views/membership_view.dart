import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../../account/controllers/account_controller.dart';

class MembershipView extends StatelessWidget {
  const MembershipView({super.key});

  @override
  Widget build(BuildContext context) {
    final account = Get.find<AccountController>();
    return Obx(() {
      final signedIn = account.isLoggedIn.value;
      final memberName = signedIn ? account.username.value : 'Khách hàng';
      final phone = signedIn ? account.phone.value : '';
      final tier = signedIn ? account.membershipTierLabel : 'Thành viên';
      final points = signedIn ? account.loyaltyPoints.value : 0;
      final history = account.pointsHistory.toList();
      final vouchers = account.vouchers.toList();

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMembershipCard(memberName, phone, tier, points),
            const SizedBox(height: 10),
            _buildProgressCard(points, tier, history),
            const SizedBox(height: 10),
            _buildBenefits(),
            const SizedBox(height: 10),
            _buildVouchers(vouchers),
            const SizedBox(height: 10),
            _buildReferral(),
            const SizedBox(height: 10),
            _buildAccountSection(signedIn),
          ],
        ),
      );
    });
  }

  Widget _buildMembershipCard(
    String name,
    String phone,
    String tier,
    int points,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF542000), AppColors.primary, Color(0xFFC77920)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'LG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HỒNG TRÀ LÊ GIA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'MEMBERSHIP CLUB',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 7,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD76A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tier,
                  style: const TextStyle(
                    color: Color(0xFF6D3B00),
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            phone,
            style: const TextStyle(color: Colors.white70, fontSize: 9),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ĐIỂM THÀNH VIÊN',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatNumber(points),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Mã thành viên',
                    'QR thành viên sẽ được kết nối sau.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: const Icon(Icons.qr_code_rounded, size: 15),
                label: const Text(
                  'Mã thành viên',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    int points,
    String tier,
    List<Map<String, dynamic>> history,
  ) {
    final recentHistory = history.take(3).toList();
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Điểm hội viên',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Hạng $tier',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_formatNumber(points)} điểm khả dụng',
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          if (recentHistory.isEmpty)
            const Text(
              'Chưa có giao dịch tích điểm.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 9),
            )
          else
            ...recentHistory.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry['description']?.toString() ?? 'Giao dịch điểm',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    Text(
                      '${(entry['points'] as num?)?.toInt() ?? 0} điểm',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBenefits() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quyền lợi thành viên',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 11),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.6,
            children: const [
              _BenefitItem(
                icon: Icons.stars_rounded,
                title: 'Tích điểm',
                description: 'Mỗi đơn hàng',
              ),
              _BenefitItem(
                icon: Icons.discount_rounded,
                title: 'Giảm giá',
                description: 'Ưu đãi thành viên',
              ),
              _BenefitItem(
                icon: Icons.cake_rounded,
                title: 'Quà sinh nhật',
                description: 'Ưu đãi đặc biệt',
              ),
              _BenefitItem(
                icon: Icons.local_shipping_rounded,
                title: 'Freeship',
                description: 'Theo điều kiện',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVouchers(List<Map<String, dynamic>> vouchers) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Voucher khả dụng',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${vouchers.length} voucher',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (vouchers.isEmpty)
            const Text(
              'Hiện chưa có voucher khả dụng.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 9),
            )
          else
            ...vouchers.map((voucher) {
              final percent =
                  (voucher['discountPercent'] as num?)?.toInt() ?? 0;
              final amount = (voucher['discountAmount'] as num?)?.toInt() ?? 0;
              final maxDiscount =
                  (voucher['maxDiscount'] as num?)?.toInt() ?? 0;
              final description = percent > 0
                  ? 'Giảm $percent%'
                        '${maxDiscount > 0 ? ', tối đa ${_formatNumber(maxDiscount)}đ' : ''}'
                  : amount > 0
                  ? 'Giảm ${_formatNumber(amount)}đ'
                  : 'Ưu đãi dành cho khách hàng';
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _VoucherItem(
                  title: voucher['title']?.toString() ?? 'Ưu đãi',
                  description: description,
                  code: voucher['code']?.toString() ?? '',
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildReferral() {
    return _SectionCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giới thiệu bạn bè',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Mời bạn bè sử dụng Hồng Trà Lê Gia để nhận thêm ưu đãi.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 8,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () {
              Get.snackbar(
                'Giới thiệu bạn bè',
                'Chức năng chia sẻ sẽ được kết nối sau.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.primary,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(bool signedIn) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tài khoản & bảo mật',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          _AccountItem(
            icon: Icons.person_outline_rounded,
            title: 'Thông tin cá nhân',
            onTap: () {
              Get.toNamed('/account');
            },
          ),
          _AccountItem(
            icon: Icons.lock_outline_rounded,
            title: 'Đổi mật khẩu',
            onTap: () {
              if (!signedIn) {
                Get.snackbar(
                  'Cần đăng nhập',
                  'Đăng nhập để đổi mật khẩu.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.toNamed(AppRoutes.changePassword);
            },
          ),
          _AccountItem(
            icon: Icons.security_rounded,
            title: 'Bảo mật tài khoản',
            onTap: () {
              Get.snackbar(
                'Bảo mật',
                'Chức năng sẽ được xây dựng sau.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  static String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 21),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoucherItem extends StatelessWidget {
  const _VoucherItem({
    required this.title,
    required this.description,
    required this.code,
  });

  final String title;
  final String description;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0D9B7)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mã: $code',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Get.snackbar(
                'Voucher',
                'Đã chọn mã $code.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            child: const Text(
              'Dùng',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  const _AccountItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
