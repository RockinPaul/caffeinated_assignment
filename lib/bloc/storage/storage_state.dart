import 'package:caffeinated_assignment/data/order.dart';

/// Base state for storage operations
abstract class StorageState {}

/// Initial state before any storage operations
class StorageInitial extends StorageState {}

/// State during a storage operation
class StorageLoading extends StorageState {}

/// State when orders have been successfully loaded
class StorageOrdersLoaded extends StorageState {
  final List<Order> orders;
  final DateTime loadedAt;

  StorageOrdersLoaded(this.orders) : loadedAt = DateTime.now();
}

/// State when an order has been successfully saved
class StorageOrderSaved extends StorageState {
  final Order order;
  final DateTime savedAt;

  StorageOrderSaved(this.order) : savedAt = DateTime.now();
}

/// State when orders have been successfully cleared
class StorageOrdersCleared extends StorageState {
  final DateTime clearedAt;

  StorageOrdersCleared() : clearedAt = DateTime.now();
}

/// State when a storage operation fails
class StorageError extends StorageState {
  final String message;

  StorageError(this.message);
}
