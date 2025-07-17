class Expense {
  final String id;
  final DateTime date;
  final String categoryName;
  final String? vendorName;
  final List<ExpenseItem> items;
  final List<String> itemIds;
  final double totalBilling;
  final double paid;
  final String paymentMode;
  final String? notes;
  final String? imageUrl;
  final DateTime? createdAt;

  const Expense({
    required this.id,
    required this.date,
    required this.categoryName,
    this.vendorName,
    required this.items,
    this.itemIds = const [],
    required this.totalBilling,
    required this.paid,
    required this.paymentMode,
    this.notes,
    this.imageUrl,
    this.createdAt,
  });

  Expense copyWith({
    String? id,
    DateTime? date,
    String? categoryName,
    String? vendorName,
    List<ExpenseItem>? items,
    List<String>? itemIds,
    double? totalBilling,
    double? paid,
    String? paymentMode,
    String? notes,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      date: date ?? this.date,
      categoryName: categoryName ?? this.categoryName,
      vendorName: vendorName ?? this.vendorName,
      items: items ?? this.items,
      itemIds: itemIds ?? this.itemIds,
      totalBilling: totalBilling ?? this.totalBilling,
      paid: paid ?? this.paid,
      paymentMode: paymentMode ?? this.paymentMode,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'categoryName': categoryName,
      'vendorName': vendorName,
      'items': items.map((item) => item.toJson()).toList(),
      'itemIds': itemIds,
      'totalBilling': totalBilling,
      'paid': paid,
      'paymentMode': paymentMode,
      'notes': notes,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      categoryName: json['categoryName'] as String,
      vendorName: json['vendorName'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((item) => ExpenseItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      itemIds: json['itemIds'] != null 
          ? List<String>.from(json['itemIds'] as List)
          : [],
      totalBilling: (json['totalBilling'] as num).toDouble(),
      paid: (json['paid'] as num).toDouble(),
      paymentMode: json['paymentMode'] as String,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, date: $date, categoryName: $categoryName, vendorName: $vendorName, items: $items, itemIds: $itemIds, totalBilling: $totalBilling, paid: $paid, paymentMode: $paymentMode, notes: $notes, createdAt: $createdAt)';
  }
}

class ExpenseItem {
  final String name;
  final int quantity;
  final String quantityType;
  final double? price;

  const ExpenseItem({
    required this.name,
    required this.quantity,
    required this.quantityType,
    this.price,
  });

  ExpenseItem copyWith({
    String? name,
    int? quantity,
    String? quantityType,
    double? price,
  }) {
    return ExpenseItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      quantityType: quantityType ?? this.quantityType,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'quantityType': quantityType,
      'price': price,
    };
  }

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      name: json['name'] as String,
      quantity: json['quantity'] is String 
          ? int.tryParse(json['quantity']) ?? 1 
          : json['quantity'] as int,
      quantityType: json['quantityType'] as String,
      price: json['price'] != null 
          ? (json['price'] is String 
              ? double.tryParse(json['price']) 
              : (json['price'] as num?)?.toDouble())
          : null,
    );
  }

  @override
  String toString() {
    return 'ExpenseItem(name: $name, quantity: $quantity, quantityType: $quantityType, price: $price)';
  }
}
