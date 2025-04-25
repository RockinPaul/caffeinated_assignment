import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:caffeinated_assignment/data/order.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';

/// Service to handle persistent storage operations for orders
class StorageService {
  static const String _ordersKey = 'saved_orders';
  
  /// Saves an order to persistent storage
  Future<bool> saveOrder(Order order, String machineId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing orders
      final List<String> savedOrders = prefs.getStringList(_ordersKey) ?? [];
      
      // Create order entry with timestamp
      final orderEntry = {
        'timestamp': DateTime.now().toIso8601String(),
        'machine_id': machineId,
        'order': order.toJson(),
      };
      
      // Add new order to list
      savedOrders.add(jsonEncode(orderEntry));
      
      // Save updated list
      return await prefs.setStringList(_ordersKey, savedOrders);
    } catch (e) {
      print('Error saving order: $e');
      return false;
    }
  }
  
  /// Retrieves all saved orders
  Future<List<Map<String, dynamic>>> getSavedOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> savedOrders = prefs.getStringList(_ordersKey) ?? [];
      
      return savedOrders
          .map((orderStr) => jsonDecode(orderStr) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error retrieving orders: $e');
      return [];
    }
  }
  
  /// Reconstructs Order objects from saved JSON (requires machine context)
  Future<List<Order>> getOrdersWithContext(CoffeeMachine machine) async {
    final savedOrders = await getSavedOrders();
    
    return savedOrders
        .where((entry) => entry['machine_id'] == machine.id)
        .map((entry) {
          try {
            return Order.fromJson(
              entry['order'] as Map<String, dynamic>, 
              machine
            );
          } catch (e) {
            print('Error parsing order: $e');
            return null;
          }
        })
        .whereType<Order>() // Filter out null values
        .toList();
  }
  
  /// Clears all saved orders
  Future<bool> clearOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_ordersKey);
    } catch (e) {
      print('Error clearing orders: $e');
      return false;
    }
  }
}
