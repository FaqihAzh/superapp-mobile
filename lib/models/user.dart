class UserModel {
  final String name;
  final DateTime birthDate;
  final DateTime createdAt;

  UserModel({
    required this.name,
    required this.birthDate,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'birthDate': birthDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'],
    birthDate: DateTime.parse(json['birthDate']),
    createdAt: DateTime.parse(json['createdAt']),
  );

  int get age {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}