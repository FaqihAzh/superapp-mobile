class Expense {
  final String id;
  final double amount;
  final String type; // 'INCOME' or 'EXPENSE'
  final String categoryId;
  final DateTime date;
  final String? note;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'type': type,
    'categoryId': categoryId,
    'date': date.toIso8601String(),
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'],
    amount: map['amount'],
    type: map['type'],
    categoryId: map['categoryId'],
    date: DateTime.parse(map['date']),
    note: map['note'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}

class ExpenseCategory {
  final String id;
  final String name;
  final String icon;
  final int color;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}