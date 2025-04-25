import 'package:caffeinated_assignment/data/coffee_machine.dart';
import 'package:caffeinated_assignment/data/order.dart';
import 'package:caffeinated_assignment/data/storage_service.dart';

/// Repository that wraps the StorageService for easier consumption by BLoC components
class StorageRepository {
  final StorageService _storageService;

  StorageRepository({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Save an order to persistent storage
  Future<bool> saveOrder(Order order, String machineId) async {
    return await _storageService.saveOrder(order, machineId);
  }

  /// Get all saved orders as raw data
  Future<List<Map<String, dynamic>>> getSavedOrdersRaw() async {
    return await _storageService.getSavedOrders();
  }

  /// Get all saved orders reconstructed as Order objects
  Future<List<Order>> getSavedOrders(CoffeeMachine machine) async {
    return await _storageService.getOrdersWithContext(machine);
  }

  /// Clear all saved orders
  Future<bool> clearOrders() async {
    return await _storageService.clearOrders();
  }
}
