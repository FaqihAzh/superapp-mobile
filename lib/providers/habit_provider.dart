import 'package:flutter/foundation.dart';
import '../models/habit.dart';
import '../utils/database_helper.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    _habits = await DatabaseHelper.instance.getAllHabits();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await DatabaseHelper.instance.insertHabit(habit);
    _habits.add(habit);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await DatabaseHelper.instance.updateHabit(habit);
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String id) async {
    await DatabaseHelper.instance.deleteHabit(id);
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId, String date) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    final completedDates = List<String>.from(habit.completedDates);

    if (completedDates.contains(date)) {
      completedDates.remove(date);
    } else {
      completedDates.add(date);
    }

    final updatedHabit = habit.copyWith(
      completedDates: completedDates,
      streak: _calculateStreak(completedDates),
    );

    await updateHabit(updatedHabit);
  }

  int _calculateStreak(List<String> completedDates) {
    if (completedDates.isEmpty) return 0;

    completedDates.sort((a, b) => b.compareTo(a));
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    if (completedDates.first != todayStr) return 0;

    int streak = 1;
    DateTime currentDate = today.subtract(const Duration(days: 1));

    for (int i = 1; i < completedDates.length; i++) {
      final dateStr = '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';

      if (completedDates[i] == dateStr) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}