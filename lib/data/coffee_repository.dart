import 'package:caffeinated_assignment/data/api_service.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';

class CoffeeRepository {
  final ApiService _apiService;

  CoffeeRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  Future<CoffeeMachine> getMachine(String machineId) async {
    return await _apiService.getMachine(machineId);
  }

  Future<List<CoffeeType>> getTypes(String machineId) async {
    return await _apiService.getTypes(machineId);
  }

  Future<List<Size>> getSizes(String machineId) async {
    return await _apiService.getSizes(machineId);
  }

  Future<List<Extra>> getExtras(String machineId) async {
    return await _apiService.getExtras(machineId);
  }

  /// Retrieves only the sizes available for the given [CoffeeType].
  Future<List<Size>> getSizesForType(String machineId, CoffeeType type) async {
    final machine = await getMachine(machineId);
    return machine.sizes.where((size) => type.sizes.contains(size.id)).toList();
  }

  /// Retrieves only the extras available for the given [CoffeeType].
  Future<List<Extra>> getExtrasForType(String machineId, CoffeeType type) async {
    final machine = await getMachine(machineId);
    return machine.extras.where((extra) => type.extras.contains(extra.id)).toList();
  }
}