import 'package:caffeinated_assignment/data/coffee_machine.dart';

/// Represents a user order: selected coffee type, size, and extras.
class Order {
  final CoffeeType type;
  final Size size;
  final List<Subselection> extras;

  Order({
    required this.type,
    required this.size,
    required this.extras,
  });

  /// Converts this order to a JSON-friendly map (using IDs).
  Map<String, dynamic> toJson() => {
        'type_id': type.id,
        'size_id': size.id,
        'extra_ids': extras.map((sub) => sub.id).toList(),
      };

  /// Reconstructs an [Order] from JSON and a full [CoffeeMachine] context.
  factory Order.fromJson(Map<String, dynamic> json, CoffeeMachine machine) {
    final typeId = json['type_id'] as String;
    final sizeId = json['size_id'] as String;
    final extraIds = List<String>.from(json['extra_ids'] as List<dynamic>);

    final type = machine.types.firstWhere((t) => t.id == typeId);
    final size = machine.sizes.firstWhere((s) => s.id == sizeId);
    final extras = machine.extras
        .expand((e) => e.subselections)
        .where((sub) => extraIds.contains(sub.id))
        .toList();

    return Order(type: type, size: size, extras: extras);
  }
}
