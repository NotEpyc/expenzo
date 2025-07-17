class ExpenseCategory {
  final String id;
  final String name;
  final bool hasIcon;
  final bool isCompleted;

  const ExpenseCategory({
    required this.id,
    required this.name,
    this.hasIcon = false,
    this.isCompleted = false,
  });

  ExpenseCategory copyWith({
    String? id,
    String? name,
    bool? hasIcon,
    bool? isCompleted,
  }) {
    return ExpenseCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      hasIcon: hasIcon ?? this.hasIcon,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hasIcon': hasIcon,
      'isCompleted': isCompleted,
    };
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      hasIcon: json['hasIcon'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
