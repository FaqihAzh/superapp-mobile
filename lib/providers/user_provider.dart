import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  String? get userName => _user?.name;
  DateTime? get userBirthDate => _user?.birthDate;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    final birthDateStr = prefs.getString('user_birthdate');

    if (name != null && birthDateStr != null) {
      _user = UserModel(
        name: name,
        birthDate: DateTime.parse(birthDateStr),
        createdAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> saveUserData({
    required String name,
    required DateTime birthDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_birthdate', birthDate.toIso8601String());

    _user = UserModel(
      name: name,
      birthDate: birthDate,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  Future<void> updateUserName(String newName) async {
    if (_user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', newName);

      _user = UserModel(
        name: newName,
        birthDate: _user!.birthDate,
        createdAt: _user!.createdAt,
      );
      notifyListeners();
    }
  }
}