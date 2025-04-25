import 'package:caffeinated_assignment/data/coffee_machine.dart';

// Base state for Coffee operations
abstract class CoffeeState {}

// Initial state before any action
class CoffeeInitial extends CoffeeState {}

// Generic loading state
class CoffeeLoading extends CoffeeState {}

// State when machines list is loaded
class CoffeeMachinesLoaded extends CoffeeState {
  final CoffeeMachine machine;

  CoffeeMachinesLoaded(this.machine);
}

// State when types list is loaded
class CoffeeTypesLoaded extends CoffeeState {
  final List<CoffeeType> types;

  CoffeeTypesLoaded(this.types);
}

// State when sizes list is loaded
class CoffeeSizesLoaded extends CoffeeState {
  final List<Size> sizes;

  CoffeeSizesLoaded(this.sizes);
}

// State when extras list is loaded
class CoffeeExtrasLoaded extends CoffeeState {
  final List<Extra> extras;

  CoffeeExtrasLoaded(this.extras);
}

// State when an error occurs
class CoffeeError extends CoffeeState {
  final String message;

  CoffeeError(this.message);
}
