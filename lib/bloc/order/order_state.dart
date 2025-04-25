import 'package:caffeinated_assignment/data/order.dart';

/// States for managing a user order.
abstract class OrderState {}

/// Initial state with a prepared order.
class OrderInitial extends OrderState {
  final Order order;
  OrderInitial(this.order);
}

/// State after an update (size or extras changed).
class OrderUpdated extends OrderState {
  final Order order;
  OrderUpdated(this.order);
}

/// State during submission.
class OrderSubmitting extends OrderState {
  final Order order;
  OrderSubmitting(this.order);
}

/// State when submission succeeds.
class OrderSuccess extends OrderState {
  final Order order;
  OrderSuccess(this.order);
}

/// State when an error occurs in the order flow.
class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
}
