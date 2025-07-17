class Item {
  final String id;
  final String name;
  final int quantity;
  final String quantityType;
  final double price;
  final String expenseId;
  final DateTime? createdAt;

  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.quantityType,
    required this.price,
    required this.expenseId,
    this.createdAt,
  });

  Item copyWith({
    String? id,
    String? name,
    int? quantity,
    String? quantityType,
    double? price,
    String? expenseId,
    DateTime? createdAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      quantityType: quantityType ?? this.quantityType,
      price: price ?? this.price,
      expenseId: expenseId ?? this.expenseId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'quantityType': quantityType,
      'price': price,
      'expenseId': expenseId,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] is String 
          ? int.tryParse(json['quantity']) ?? 1 
          : json['quantity'] as int,
      quantityType: json['quantityType'] as String,
      price: json['price'] is String 
          ? double.tryParse(json['price']) ?? 0.0 
          : (json['price'] as num).toDouble(),
      expenseId: json['expenseId'] as String,
      createdAt: json['createdAt'] != null 
          ? _parseDateTime(json['createdAt'])
          : null,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    
    try {
      if (value.toString().contains('Timestamp')) {
        return value.toDate();
      }
      
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return DateTime.fromMillisecondsSinceEpoch(parsed);
        }
      }
    } catch (e) {
      print('Failed to parse DateTime: $e');
    }
    
    return null;
  }

  @override
  String toString() {
    return 'Item(id: $id, name: $name, quantity: $quantity, quantityType: $quantityType, price: $price, expenseId: $expenseId, createdAt: $createdAt)';
  }
}
