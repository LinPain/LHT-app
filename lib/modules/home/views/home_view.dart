import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../account/controllers/account_controller.dart';
import '../../../data/models/product_model.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        color: AppColors.primary,
        onRefresh: controller.refreshHome,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStoreCard(),
              const SizedBox(height: 10),

              _buildMembershipCard(),
              const SizedBox(height: 10),

              _buildActiveOrderCard(),
              const SizedBox(height: 10),

              _buildQuickActions(),
              const SizedBox(height: 10),

              _buildPromotionCard(),
              const SizedBox(height: 18),

              _buildSignatureSection(),
              const SizedBox(height: 18),

              _buildStoreInformation(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STORE CARD
  // ============================================================

  Widget _buildStoreCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 19,
                ),
              ),

              const SizedBox(width: 9),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Cửa hàng đang mở',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 7),
                        _OpenBadge(),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Hôm nay 07:30 - 23:00',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Cầu Giấy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),

          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hội viên',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 7),
                        _MemberBadge(),
                      ],
                    ),

                    SizedBox(height: 3),

                    Obx(() {
                      final account = Get.find<AccountController>();
                      final points = account.isLoggedIn.value
                          ? account.loyaltyPoints.value
                          : 0;
                      return Text(
                        '$points điểm khả dụng',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                        ),
                      );
                    }),
                  ],
                ),
              ),

              TextButton(
                onPressed: () {
                  Get.find<MainController>().changeTab(3);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Ví điểm & Thẻ',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MEMBERSHIP
  // ============================================================

  Widget _buildMembershipCard() {
    final account = Get.find<AccountController>();
    final points = account.isLoggedIn.value ? account.loyaltyPoints.value : 0;
    final tier = account.isLoggedIn.value
        ? account.membershipTierLabel
        : 'Thành viên';

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stars_rounded,
                  color: AppColors.gold,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ưu đãi thành viên',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Tích điểm và nhận thêm ưu đãi mỗi ngày',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '$points điểm',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hạng $tier',
              style: const TextStyle(
                color: AppColors.gold,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVE ORDER
  // ============================================================

  Widget _buildActiveOrderCard() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCF7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1DFAE)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
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
                  'Chưa có đơn hàng đang xử lý',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'Đặt món để theo dõi trạng thái đơn hàng',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 9),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: () {
              Get.find<MainController>().changeTab(1);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            child: const Row(
              children: [
                Text(
                  'Đặt món',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
                ),
                Icon(Icons.chevron_right_rounded, size: 17),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.delivery_dining_rounded,
            title: 'Giao hàng tận nơi',
            subtitle: 'Giao nhanh 15-25 phút',
            badge: 'Freeship',
            onTap: () {
              Get.find<MainController>().changeTab(1);
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _QuickActionCard(
            icon: Icons.storefront_rounded,
            title: 'Đến lấy tại quán',
            subtitle: 'Chuẩn bị sẵn khi bạn tới',
            badge: 'Không chờ đợi',
            onTap: () {
              Get.find<MainController>().changeTab(1);
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROMOTION
  // ============================================================

  Widget _buildPromotionCard() {
    final campaign = controller.campaigns.isEmpty
        ? <String, dynamic>{}
        : controller.campaigns.first;
    final title = campaign['title']?.toString() ?? 'Ưu đãi dành cho bạn';
    final voucherCode = campaign['voucherCode']?.toString() ?? '';
    final description =
        campaign['description']?.toString() ??
        'Khám phá các chương trình ưu đãi mới nhất';

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4D1C08), Color(0xFF7A2E00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFFFFD36A),
                size: 16,
              ),
              SizedBox(width: 5),
              Text(
                'ƯU ĐÃI ĐẶC QUYỀN HÔM NAY',
                style: TextStyle(
                  color: Color(0xFFFFD36A),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              children: [
                if (voucherCode.isNotEmpty) const TextSpan(text: 'Nhập mã: '),
                if (voucherCode.isNotEmpty)
                  TextSpan(
                    text: voucherCode,
                    style: const TextStyle(
                      color: Color(0xFFFFD36A),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 9),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Get.find<MainController>().changeTab(1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE96800),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Xem ngay',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIGNATURE PRODUCTS
  // ============================================================

  Widget _buildSignatureSection() {
    final products = controller.signatureProducts;

    if (controller.isLoading.value) {
      return _buildLoadingProducts();
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return _buildProductError();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.deepOrange,
              size: 18,
            ),

            const SizedBox(width: 5),

            const Expanded(
              child: Text(
                'Món Bán Chạy Nhất (Signature)',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Get.find<MainController>().changeTab(1);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.zero,
              ),
              child: const Row(
                children: [
                  Text(
                    'Xem menu',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 9),

        if (products.isEmpty)
          _buildEmptyProducts()
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
              childAspectRatio: 0.69,
            ),
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
      ],
    );
  }

  // ============================================================
  // PRODUCT CARD
  // ============================================================

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetail, arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.05,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: product.imageUrl.isEmpty
                        ? Container(
                            color: const Color(0xFFF2ECE7),
                            child: const Icon(
                              Icons.local_cafe_rounded,
                              color: AppColors.primary,
                              size: 48,
                            ),
                          )
                        : Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) {
                              return Container(
                                color: const Color(0xFFF2ECE7),
                                child: const Icon(
                                  Icons.local_cafe_rounded,
                                  color: AppColors.primary,
                                  size: 48,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) {
                                return child;
                              }

                              return Container(
                                color: const Color(0xFFF2ECE7),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  Positioned(
                    top: 7,
                    left: 7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'SIGNATURE',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 7,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 8,
                        height: 1.25,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatPrice(product.price),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),

                        Container(
                          width: 27,
                          height: 27,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOADING PRODUCTS
  // ============================================================

  Widget _buildLoadingProducts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
          SizedBox(height: 10),
          Text(
            'Đang tải sản phẩm...',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PRODUCT ERROR
  // ============================================================

  Widget _buildProductError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: AppColors.textSecondary,
            size: 36,
          ),

          const SizedBox(height: 8),

          const Text(
            'Không thể tải sản phẩm',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: controller.loadProducts,
            child: const Text(
              'Thử lại',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY PRODUCTS
  // ============================================================

  Widget _buildEmptyProducts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.local_cafe_outlined,
            color: AppColors.textSecondary,
            size: 36,
          ),

          SizedBox(height: 8),

          Text(
            'Chưa có sản phẩm',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STORE INFORMATION
  // ============================================================

  Widget _buildStoreInformation() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.store_rounded, color: AppColors.primary, size: 18),
              SizedBox(width: 6),
              Text(
                'Thông tin cửa hàng',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 11),

          const _InfoRow(
            icon: Icons.location_on_outlined,
            title: 'Chi nhánh Cầu Giấy',
            value: 'Hà Nội',
          ),

          const SizedBox(height: 8),

          const _InfoRow(
            icon: Icons.access_time_rounded,
            title: 'Giờ hoạt động',
            value: '07:30 - 23:00',
          ),

          const SizedBox(height: 8),

          const _InfoRow(
            icon: Icons.phone_outlined,
            title: 'Hotline',
            value: '1900 xxxx',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  static String _formatPrice(double price) {
    final value = price.round().toString();

    return '${value.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}đ';
  }
}

// ============================================================
// OPEN BADGE
// ============================================================

class _OpenBadge extends StatelessWidget {
  const _OpenBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA000),
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        '07:30 - 23:00',
        style: TextStyle(
          color: Colors.white,
          fontSize: 7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================
// MEMBER BADGE
// ============================================================

class _MemberBadge extends StatelessWidget {
  const _MemberBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        'Hạng GOLD',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ============================================================
// QUICK ACTION CARD
// ============================================================

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(9, 10, 9, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.textPrimary, size: 27),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: badge == 'Freeship'
                        ? const Color(0xFFFFEBEE)
                        : const Color(0xFFFFF3D6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: badge == 'Freeship'
                          ? Colors.red
                          : Colors.orange.shade800,
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INFORMATION ROW
// ============================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
