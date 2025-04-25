import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';
import 'package:caffeinated_assignment/data/order.dart';
import 'package:caffeinated_assignment/data/storage_repository.dart';
import 'package:caffeinated_assignment/bloc/storage/storage_state.dart';
import 'package:caffeinated_assignment/constants.dart';

/// Cubit to manage order storage operations
class StorageCubit extends Cubit<StorageState> {
  final StorageRepository _repository;
  
  StorageCubit({StorageRepository? repository})
      : _repository = repository ?? StorageRepository(),
        super(StorageInitial());

  /// Save an order to persistent storage
  Future<void> saveOrder(Order order, {String? machineId}) async {
    emit(StorageLoading());
    try {
      final success = await _repository.saveOrder(
        order, 
        machineId ?? AppConstants.defaultMachineId
      );
      
      if (success) {
        emit(StorageOrderSaved(order));
      } else {
        emit(StorageError('Failed to save order'));
      }
    } catch (e) {
      emit(StorageError(e.toString()));
    }
  }

  /// Load all saved orders for a specific machine
  Future<void> loadOrders(CoffeeMachine machine) async {
    emit(StorageLoading());
    try {
      final orders = await _repository.getSavedOrders(machine);
      emit(StorageOrdersLoaded(orders));
    } catch (e) {
      emit(StorageError(e.toString()));
    }
  }

  /// Clear all saved orders
  Future<void> clearOrders() async {
    emit(StorageLoading());
    try {
      final success = await _repository.clearOrders();
      
      if (success) {
        emit(StorageOrdersCleared());
      } else {
        emit(StorageError('Failed to clear orders'));
      }
    } catch (e) {
      emit(StorageError(e.toString()));
    }
  }
}
