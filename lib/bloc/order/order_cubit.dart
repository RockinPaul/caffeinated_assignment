import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caffeinated_assignment/data/order.dart';
import 'package:caffeinated_assignment/bloc/order/order_state.dart';
import 'package:caffeinated_assignment/data/coffee_machine.dart';

/// Cubit to manage the user's coffee order flow.
class OrderCubit extends Cubit<OrderState> {
  OrderCubit({required Order initialOrder}) : super(OrderInitial(initialOrder));

  /// Select a new size, preserving type and extras.
  void selectSize(Size size) {
    final current = (state as dynamic).order as Order;
    final updated = Order(
      type: current.type,
      size: size,
      extras: current.extras,
    );
    emit(OrderUpdated(updated));
  }

  /// Toggle a subselection extra on/off.
  void toggleExtra(Subselection sub) {
    final current = (state as dynamic).order as Order;
    final extras = List<Subselection>.from(current.extras);
    if (extras.any((e) => e.id == sub.id)) {
      extras.removeWhere((e) => e.id == sub.id);
    } else {
      extras.add(sub);
    }
    final updated = Order(
      type: current.type,
      size: current.size,
      extras: extras,
    );
    emit(OrderUpdated(updated));
  }

  /// Submit the order (stubbed delay).
  Future<void> submitOrder() async {
    final current = (state as dynamic).order as Order;
    emit(OrderSubmitting(current));
    try {
      // TODO: integrate backend submission
      await Future.delayed(const Duration(seconds: 1));
      emit(OrderSuccess(current));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
