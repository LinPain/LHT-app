import '../models/delivery_tracking_model.dart';

/// Contract for the future delivery tracking API integration.
/// Implement this when the courier tracking endpoint is available.
abstract interface class DeliveryTrackingRepository {
  Future<DeliveryTrackingModel?> getTracking(String orderId);
}
