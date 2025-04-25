class CoffeeMachine {
  final String id;
  final List<CoffeeType> types;
  final List<Size> sizes;
  final List<Extra> extras;

  CoffeeMachine({
    required this.id,
    required this.types,
    required this.sizes,
    required this.extras,
  });

  factory CoffeeMachine.fromJson(Map<String, dynamic> json) => CoffeeMachine(
        id: json['_id'] as String,
        types: (json['types'] as List<dynamic>).map((e) => CoffeeType.fromJson(e as Map<String, dynamic>)).toList(),
        sizes: (json['sizes'] as List<dynamic>).map((e) => Size.fromJson(e as Map<String, dynamic>)).toList(),
        extras: (json['extras'] as List<dynamic>).map((e) => Extra.fromJson(e as Map<String, dynamic>)).toList(),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'types': types.map((e) => e.toJson()).toList(),
        'sizes': sizes.map((e) => e.toJson()).toList(),
        'extras': extras.map((e) => e.toJson()).toList(),
      };
}

class CoffeeType {
  final String id;
  final String name;
  final List<String> sizes;
  final List<String> extras;

  CoffeeType({
    required this.id,
    required this.name,
    required this.sizes,
    required this.extras,
  });

  factory CoffeeType.fromJson(Map<String, dynamic> json) => CoffeeType(
        id: json['_id'] as String,
        name: json['name'] as String,
        sizes: List<String>.from(json['sizes'] as List<dynamic>),
        extras: List<String>.from(json['extras'] as List<dynamic>),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'sizes': sizes,
        'extras': extras,
      };
}

class Size {
  final String id;
  final String name;
  final int? v;

  Size({
    required this.id,
    required this.name,
    this.v,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        id: json['_id'] as String,
        name: json['name'] as String,
        v: json.containsKey('__v') ? json['__v'] as int : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'_id': id, 'name': name};
    if (v != null) data['__v'] = v;
    return data;
  }
}

class Subselection {
  final String id;
  final String name;

  Subselection({
    required this.id,
    required this.name,
  });

  factory Subselection.fromJson(Map<String, dynamic> json) => Subselection(
        id: json['_id'] as String,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class Extra {
  final String id;
  final String name;
  final List<Subselection> subselections;

  Extra({
    required this.id,
    required this.name,
    required this.subselections,
  });

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        id: json['_id'] as String,
        name: json['name'] as String,
        subselections: (json['subselections'] as List<dynamic>)
            .map((e) => Subselection.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'subselections': subselections.map((e) => e.toJson()).toList(),
      };
}