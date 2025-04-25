import 'package:dio/dio.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';
import 'package:flutter/widgets.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://darkroastedbeans.coffeeit.nl/',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  // Fetches a single coffee machine payload
  // Corresponds to GET /coffee-machine/{id}
  Future<CoffeeMachine> getMachine(String machineId) async {
    try {
      final response = await _dio.get('coffee-machine/$machineId');
      return CoffeeMachine.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('Dio error fetching machine $machineId: $e');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error fetching machine $machineId: $e');
      rethrow;
    }
  }

  // Fetches the list of coffee types for a specific machine
  // Corresponds to nested data within the machine payload
  Future<List<CoffeeType>> getTypes(String machineId) async {
    try {
      final machine = await getMachine(machineId);
      return machine.types;
    } on DioException catch (e) {
      debugPrint('Dio error fetching types for machine $machineId: $e');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error fetching types for machine $machineId: $e');
      rethrow;
    }
  }

  // Fetches the list of coffee sizes for a specific machine
  // Corresponds to nested data within the machine payload
  Future<List<Size>> getSizes(String machineId) async {
    try {
      final machine = await getMachine(machineId);
      return machine.sizes;
    } on DioException catch (e) {
      debugPrint('Dio error fetching sizes for machine $machineId: $e');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error fetching sizes for machine $machineId: $e');
      rethrow;
    }
  }

  // Fetches the list of coffee extras for a specific machine
  // Corresponds to nested data within the machine payload
  Future<List<Extra>> getExtras(String machineId) async {
    try {
      final machine = await getMachine(machineId);
      return machine.extras;
    } on DioException catch (e) {
      debugPrint('Dio error fetching extras for machine $machineId: $e');
      rethrow;
    } catch (e) {
      debugPrint('Unexpected error fetching extras for machine $machineId: $e');
      rethrow;
    }
  }
}