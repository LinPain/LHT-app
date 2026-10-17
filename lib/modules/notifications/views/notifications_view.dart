import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});
  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late final NotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<NotificationsController>();
    controller.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final notifications = controller.notifications;
      return RefreshIndicator(
        onRefresh: controller.loadNotifications,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(notifications),
              const SizedBox(height: 10),
              if (controller.errorMessage.value.isNotEmpty)
                _buildErrorState(controller.errorMessage.value)
              else if (notifications.isEmpty)
                _buildEmptyState()
              else
                ...notifications.map((notification) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _buildNotificationCard(notification),
                )),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader(List<Map<String, dynamic>> notifications) {
    final unreadCount =
        notifications.where((item) => item['isRead'] != true).length;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
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
              Icons.notifications_rounded,
              color: AppColors.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông báo',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Cập nhật đơn hàng và ưu đãi',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          if (unreadCount > 0)
            TextButton(onPressed: controller.markAllRead, child: const Text('Đọc hết')),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unreadCount mới',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isOrder = notification['type'] == 'order';

    return Container(
      decoration: BoxDecoration(
        color: notification['isRead'] == true
            ? Colors.white
            : const Color(0xFFFFFAF5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: notification['isRead'] == true
              ? AppColors.border
              : const Color(0xFFF0D4BD),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          controller.markRead(notification);
          if (isOrder) {
            Get.find<MainController>().changeTab(4);
          } else {
            Get.snackbar(
                notification['title']?.toString() ?? '',
                notification['message']?.toString() ?? '',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(
                notification,
                isOrder,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification['title']?.toString() ?? '',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 10,
                              fontWeight: notification['isRead'] == true
                                  ? FontWeight.w600
                                  : FontWeight.w800,
                            ),
                          ),
                        ),
                        if (notification['isRead'] != true)
                          Container(
                            width: 7,
                            height: 7,
                            margin:
                            const EdgeInsets.only(top: 3),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification['message']?.toString() ?? '',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.textSecondary,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          notification['timeLabel']?.toString() ?? '',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 8,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            controller.markRead(notification);
                            if (isOrder) {
                              Get.find<MainController>().changeTab(4);
                            } else {
                              Get.snackbar(
                                notification['actionLabel']?.toString() ?? '',
                                'Chức năng sẽ được kết nối với backend sau.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: AppColors.primary,
                          ),
                          child: Text(
                            notification['actionLabel']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(
      Map<String, dynamic> notification,
      bool isOrder,
      ) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isOrder
            ? AppColors.primary.withValues(alpha: 0.09)
            : const Color(0xFFFFF4DD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isOrder
            ? Icons.receipt_long_rounded
            : Icons.local_offer_rounded,
        color: isOrder
            ? AppColors.primary
            : AppColors.gold,
        size: 21,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_rounded, color: AppColors.textSecondary, size: 42),
          const SizedBox(height: 10),
          const Text('Không tải được thông báo', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const SizedBox(height: 10),
          TextButton.icon(onPressed: controller.loadNotifications, icon: const Icon(Icons.refresh), label: const Text('Thử lại')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textSecondary,
            size: 48,
          ),
          SizedBox(height: 12),
          Text(
            'Chưa có thông báo',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Các thông báo về đơn hàng và ưu đãi\nsẽ xuất hiện tại đây.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
