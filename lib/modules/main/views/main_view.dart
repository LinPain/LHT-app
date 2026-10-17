import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_header.dart';

import '../controllers/main_controller.dart';

import '../../home/views/home_view.dart';
import '../../menu/views/menu_view.dart';
import '../../cart/views/cart_view.dart';
import '../../membership/views/membership_view.dart';
import '../../orders/views/orders_view.dart';
import '../../orders/views/order_history_view.dart';
import '../../notifications/views/notifications_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeView(),
      const MenuView(),
      const CartView(),
      const MembershipView(),
      const OrdersView(),
    ];

    return Obx(
          () => Scaffold(
        backgroundColor: Colors.grey.shade50,

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: AppHeader(
              onNotificationTap: controller.openNotifications,
            onHistoryTap: controller.openHistory,
            onProfileTap: () {
              Get.toNamed('/account');
            },
          ),
        ),

            body: controller.isNotificationPage.value
                ? const NotificationsView()
                : controller.isHistoryPage.value
                ? const OrderHistoryView()
                : pages[controller.currentIndex.value],

        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(Icons.local_cafe_outlined),
              selectedIcon: Icon(Icons.local_cafe),
              label: 'Đặt món',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart),
              label: 'Giỏ hàng',
            ),
            NavigationDestination(
              icon: Icon(Icons.card_membership_outlined),
              selectedIcon: Icon(Icons.card_membership),
              label: 'Hội viên',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Đơn hàng',
            ),
          ],
        ),
      ),
    );
  }
}