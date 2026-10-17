enum OrderStatus {
  submitted,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  completed,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.submitted:
        return 'Đã gửi đơn';
      case OrderStatus.confirmed:
        return 'Quán xác nhận';
      case OrderStatus.preparing:
        return 'Đang pha chế';
      case OrderStatus.ready:
        return 'Sẵn sàng lấy';
      case OrderStatus.outForDelivery:
        return 'Đang giao';
      case OrderStatus.completed:
        return 'Hoàn tất';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }
}
