import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../../../widgets/product_image.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/menu_controller.dart';

class MenuView extends GetView<MenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),

        const SizedBox(height: 16),

        _buildCategorySection(),

        Expanded(
          child: _buildProducts(),
        ),
      ],
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.searchProducts,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm món uống...',
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.searchController,
            builder: (context, value, child) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }

              return IconButton(
                onPressed: () {
                  controller.searchController.clear();
                  controller.searchProducts('');
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // CATEGORY
  // ============================================================

  Widget _buildCategorySection() {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: controller.categories.length,
        separatorBuilder: (_, _) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (context, index) {
          final category = controller.categories[index];

          return Obx(
                () => _CategoryCard(
              name: category,
              icon: _categoryIcon(category),
              selected:
              controller.selectedCategory.value == category,
              onTap: () {
                controller.selectCategory(category);
              },
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // CATEGORY ICON
  // ============================================================

  String _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tất cả':
        return '☕';

      case 'trà':
        return '🥤';

      case 'trà sữa':
        return '🧋';

      case 'trà trái cây':
        return '🍑';

      case 'topping':
        return '🧋';

      default:
        return '🍵';
    }
  }

  // ============================================================
  // PRODUCTS
  // ============================================================

  Widget _buildProducts() {
    return Obx(
          () {
        final isLoading = controller.isLoading.value;
        final errorMessage =
            controller.errorMessage.value;
        final products = controller.filteredProducts;

        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }

        if (products.isEmpty) {
          return _buildEmptyProducts();
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            24,
          ),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.70,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return _ProductCard(
              name: product.name,
              description: product.description,
              price: product.price,
              imageUrl: product.imageUrl,
              onTap: () {
                Get.toNamed(
                  AppRoutes.productDetail,
                  arguments: product,
                );
              },
            );
          },
        );
      },
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyProducts() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_cafe_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Chưa có sản phẩm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Không tìm thấy món phù hợp.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// CATEGORY CARD
// ================================================================

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        width: 96,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: 0.12,
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// PRODUCT CARD
// ================================================================

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.035,
              ),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.05,
              child: ProductImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  9,
                  9,
                  9,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
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
                            _formatPrice(price),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),

                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                            BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 19,
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

  static String _formatPrice(double price) {
    final value = price.round().toString();

    return '${value.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    )}đ';
  }
}