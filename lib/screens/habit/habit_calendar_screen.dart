import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/habit_provider.dart';
import '../../models/habit.dart';
import '../../utils/constants.dart';

class HabitCalendarScreen extends StatefulWidget {
  const HabitCalendarScreen({super.key});

  @override
  State<HabitCalendarScreen> createState() => _HabitCalendarScreenState();
}

class _HabitCalendarScreenState extends State<HabitCalendarScreen> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Kalender Habit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<HabitProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Month Navigation
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(
                            _currentMonth.year,
                            _currentMonth.month - 1,
                          );
                        });
                      },
                      icon: const Icon(Icons.chevron_left_rounded),
                      color: AppConstants.successColor,
                    ),
                    Text(
                      DateFormat('MMMM yyyy', 'id_ID').format(_currentMonth),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final nextMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                        );
                        if (nextMonth.isBefore(DateTime.now().add(const Duration(days: 1)))) {
                          setState(() {
                            _currentMonth = nextMonth;
                          });
                        }
                      },
                      icon: const Icon(Icons.chevron_right_rounded),
                      color: AppConstants.successColor,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Calendar Grid
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: provider.habits.map((habit) {
                    return _buildHabitCalendar(habit, provider);
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHabitCalendar(Habit habit, HabitProvider provider) {
    final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Habit Header
          Row(
            children: [
              Text(habit.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            habit.category,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.successColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_getMonthCompletions(habit)} hari bulan ini',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Day Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'].map((day) {
              return SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar Days
          Wrap(
            children: [
              // Empty spaces for days before month starts
              ...List.generate(
                startingWeekday,
                    (index) => const SizedBox(width: 40, height: 40),
              ),
              // Days of the month
              ...List.generate(daysInMonth, (index) {
                final day = index + 1;
                final date = DateTime(_currentMonth.year, _currentMonth.month, day);
                final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                final isCompleted = habit.completedDates.contains(dateStr);
                final isToday = _isToday(date);
                final isFuture = date.isAfter(DateTime.now());

                return GestureDetector(
                  onTap: isFuture ? null : () {
                    provider.toggleHabitCompletion(habit.id, dateStr);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppConstants.successColor
                          : isFuture
                          ? Colors.grey.shade100
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isToday
                            ? AppConstants.successColor
                            : Colors.grey.shade200,
                        width: isToday ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                          color: isCompleted
                              ? Colors.white
                              : isFuture
                              ? Colors.grey.shade400
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  int _getMonthCompletions(Habit habit) {
    final startOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final endOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    return habit.completedDates.where((dateStr) {
      final date = DateTime.parse(dateStr);
      return date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfMonth.add(const Duration(days: 1)));
    }).length;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}