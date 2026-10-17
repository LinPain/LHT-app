import 'package:get/get.dart';

import '../../../data/models/order_model.dart';
import '../../../data/models/order_status.dart';
import '../../../data/providers/api_client.dart';
import '../../cart/controllers/cart_controller.dart';

class OrdersController extends GetxController {
  OrdersController({required this.apiProvider});

  final ApiClient apiProvider;
  // Current active order
  final currentOrder = Rxn<OrderModel>();

  // Previous orders
  final orderHistory = <OrderModel>[].obs;
  final isRefreshingOrder = false.obs;
  final historyError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMyOrders();
  }

  Future<void> loadMyOrders() async {
    historyError.value = '';
    if (!await apiProvider.hasAccessToken()) {
      orderHistory.clear();
      return;
    }
    try {
      final data = await apiProvider.get('/api/orders/my-orders');
      if (data is List) {
        orderHistory.assignAll(
          data
              .whereType<Map<String, dynamic>>()
              .map(OrderModel.fromJson)
              .where((order) => order.status == OrderStatus.completed),
        );
      }
    } catch (_) {
      historyError.value = 'Không tải được lịch sử đơn hàng. Kiểm tra kết nối hoặc đăng nhập rồi thử lại.';
    }
  }

  Future<void> refreshCurrentOrder() async {
    final current = currentOrder.value;
    if (current == null || current.id.isEmpty || isRefreshingOrder.value) {
      return;
    }

    isRefreshingOrder.value = true;
    try {
      final data = await apiProvider.get('/api/orders/${current.id}');
      if (data is Map) {
        final payload = Map<String, dynamic>.from(data);
        payload['items'] = current.items.map((item) => item.toJson()).toList();
        final updatedOrder = OrderModel.fromJson(payload);
        if (updatedOrder.status == OrderStatus.completed) {
          orderHistory.removeWhere((item) => item.id == updatedOrder.id);
          orderHistory.insert(0, updatedOrder);
          currentOrder.value = null;
        } else {
          currentOrder.value = updatedOrder;
        }
      }
    } catch (_) {
      // Leave the last known order visible if the server cannot be reached.
    } finally {
      isRefreshingOrder.value = false;
    }
  }

  Future<void> cancelCurrentOrder() async {
    final order = currentOrder.value;
    if (order == null) return;
    try {
      await apiProvider.patch('/api/orders/${order.id}/cancel');
      currentOrder.value = null;
      Get.snackbar(
        'Đã hủy đơn',
        'Đơn hàng của bạn đã được hủy.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Không thể hủy đơn',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void reorder(OrderModel order) {
    final cart = Get.find<CartController>();
    for (final item in order.items) {
      cart.addItem(item);
    }
    Get.snackbar(
      'Đã thêm vào giỏ',
      'Các món từ đơn cũ đã được thêm cùng với món hiện có. Kiểm tra tình trạng và giá trước khi đặt.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void setCurrentOrder(OrderModel order) {
    currentOrder.value = order;
  }

  void addToHistory(OrderModel order) {
    orderHistory.insert(0, order);
  }

  void clearCurrentOrder() {
    currentOrder.value = null;
  }

  void clearHistory() {
    orderHistory.clear();
  }

  void updateCurrentOrderStatus(OrderStatus status) {
    final order = currentOrder.value;

    if (order == null) {
      return;
    }

    final updatedOrder = OrderModel(
      id: order.id,
      branchName: order.branchName,
      items: order.items,
      subtotal: order.subtotal,
      total: order.total,
      orderType: order.orderType,
      paymentMethod: order.paymentMethod,
      status: status,
      createdAt: order.createdAt,
    );

    currentOrder.value = updatedOrder;

    if (status == OrderStatus.completed) {
      addToHistory(updatedOrder);
      clearCurrentOrder();
    }
  }

  void completeCurrentOrder() {
    final order = currentOrder.value;

    if (order == null) {
      return;
    }

    final completedOrder = OrderModel(
      id: order.id,
      branchName: order.branchName,
      items: order.items,
      subtotal: order.subtotal,
      total: order.total,
      orderType: order.orderType,
      paymentMethod: order.paymentMethod,
      status: OrderStatus.completed,
      createdAt: order.createdAt,
    );

    addToHistory(completedOrder);
    clearCurrentOrder();
  }
}
