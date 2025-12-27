class Habit {
  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> completedDates;
  final int streak;
  final int goal;
  final DateTime createdAt;
  final String icon;

  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.completedDates,
    required this.streak,
    required this.goal,
    required this.createdAt,
    required this.icon,
  });

  Habit copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    List<String>? completedDates,
    int? streak,
    int? goal,
    DateTime? createdAt,
    String? icon,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      completedDates: completedDates ?? this.completedDates,
      streak: streak ?? this.streak,
      goal: goal ?? this.goal,
      createdAt: createdAt ?? this.createdAt,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'completedDates': completedDates.join(','),
    'streak': streak,
    'goal': goal,
    'createdAt': createdAt.toIso8601String(),
    'icon': icon,
  };

  factory Habit.fromMap(Map<String, dynamic> map) => Habit(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    description: map['description'],
    completedDates: (map['completedDates'] as String).split(',').where((e) => e.isNotEmpty).toList(),
    streak: map['streak'],
    goal: map['goal'],
    createdAt: DateTime.parse(map['createdAt']),
    icon: map['icon'],
  );
}