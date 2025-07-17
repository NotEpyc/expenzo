class ExpenseCategory {
  final String id;
  final String name;
  final bool hasIcon;
  final bool isCompleted;
  final DateTime? createdAt;

  const ExpenseCategory({
    required this.id,
    required this.name,
    this.hasIcon = false,
    this.isCompleted = false,
    this.createdAt,
  });

  ExpenseCategory copyWith({
    String? id,
    String? name,
    bool? hasIcon,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      hasIcon: hasIcon ?? this.hasIcon,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hasIcon': hasIcon,
      'isCompleted': isCompleted,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      hasIcon: json['hasIcon'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
    );
  }
}
