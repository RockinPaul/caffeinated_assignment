import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caffeinated_assignment/data/coffee_repository.dart';
import 'package:caffeinated_assignment/bloc/coffee_state.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';

class CoffeeCubit extends Cubit<CoffeeState> {
  final CoffeeRepository _repository;

  CoffeeCubit({CoffeeRepository? repository})
      : _repository = repository ?? CoffeeRepository(),
        super(CoffeeInitial());

  Future<void> loadTypes(String machineId) async {
    emit(CoffeeLoading());
    try {
      final types = await _repository.getTypes(machineId);
      emit(CoffeeTypesLoaded(types));
    } catch (e) {
      emit(CoffeeError(e.toString()));
    }
  }

  Future<void> loadSizes(String machineId) async {
    emit(CoffeeLoading());
    try {
      final sizes = await _repository.getSizes(machineId);
      emit(CoffeeSizesLoaded(sizes));
    } catch (e) {
      emit(CoffeeError(e.toString()));
    }
  }

  Future<void> loadExtras(String machineId) async {
    emit(CoffeeLoading());
    try {
      final extras = await _repository.getExtras(machineId);
      emit(CoffeeExtrasLoaded(extras));
    } catch (e) {
      emit(CoffeeError(e.toString()));
    }
  }

  /// Loads sizes specific to a given coffee [type].
  Future<void> loadSizesForType(String machineId, CoffeeType type) async {
    emit(CoffeeLoading());
    try {
      final sizes = await _repository.getSizesForType(machineId, type);
      emit(CoffeeSizesLoaded(sizes));
    } catch (e) {
      emit(CoffeeError(e.toString()));
    }
  }

  /// Loads extras specific to a given coffee [type].
  Future<void> loadExtrasForType(String machineId, CoffeeType type) async {
    emit(CoffeeLoading());
    try {
      final extras = await _repository.getExtrasForType(machineId, type);
      emit(CoffeeExtrasLoaded(extras));
    } catch (e) {
      emit(CoffeeError(e.toString()));
    }
  }
}
