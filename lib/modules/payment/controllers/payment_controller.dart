import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/order_status.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../main/controllers/main_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../../data/providers/api_client.dart';

class PaymentController extends GetxController {
  final CartController cartController;
  final OrdersController ordersController;
  final ApiClient apiProvider;

  PaymentController({
    required this.cartController,
    required this.ordersController,
    required this.apiProvider,
  });

  final selectedPaymentMethod = 'cash'.obs;

  final isSubmitting = false.obs;
  late final Map<String, dynamic> checkout = Map<String, dynamic>.from(
    Get.arguments as Map? ?? {},
  );

  double get total =>
      (checkout['total'] as num?)?.toDouble() ?? cartController.total;

  bool get canConfirm {
    return selectedPaymentMethod.value == 'cash' &&
        cartController.cartItems.isNotEmpty;
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> confirmOrder() async {
    if (isSubmitting.value) return;
    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        'Giỏ hàng trống',
        'Không thể tạo đơn hàng khi giỏ hàng đang trống.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedPaymentMethod.value.isEmpty) {
      Get.snackbar(
        'Chưa chọn phương thức',
        'Vui lòng chọn phương thức thanh toán.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (selectedPaymentMethod.value != 'cash') {
      Get.snackbar(
        'Thanh toán chưa khả dụng',
        'Hiện chỉ hỗ trợ tiền mặt khi nhận đơn.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      const method = 'CASH';
      final items = cartController.cartItems
          .map((item) => {...item.toJson(), 'totalPrice': item.totalPrice})
          .toList();
      final response = await apiProvider.post(
        '/api/orders',
        body: {
          'branchId': 'b-cau-giay',
          'orderType': checkout['orderType'] ?? 'TAKEAWAY',
          'source': 'APP',
          'customerName': checkout['customerName'] ?? '',
          'customerPhone': checkout['customerPhone'] ?? '',
          'deliveryAddress': checkout['deliveryAddress'] ?? '',
          'note': checkout['note'] ?? '',
          'items': items,
          'paymentMethod': method,
          'voucherCode': checkout['voucherCode'] ?? '',
        },
      );
      if (response is! Map) {
        throw Exception('Máy chủ trả về đơn hàng không hợp lệ.');
      }
      final order = OrderModel(
        id: response['id']?.toString() ?? '',
        branchName: 'Hồng Trà Lê Gia',
        items: List.from(cartController.cartItems),
        subtotal: cartController.subtotal,
        total: (response['finalTotal'] as num?)?.toDouble() ?? total,
        orderType: checkout['orderType']?.toString() ?? 'TAKEAWAY',
        paymentMethod: method,
        status: OrderStatus.submitted,
        createdAt: DateTime.tryParse(response['createdAt']?.toString() ?? ''),
      );
      ordersController.setCurrentOrder(order);
      cartController.clearCart();
      Get.offNamed(AppRoutes.main);
      Future.microtask(() => Get.find<MainController>().changeTab(4));
    } catch (error) {
      Get.snackbar(
        'Không thể tạo đơn hàng',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
