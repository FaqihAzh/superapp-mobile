import 'package:flutter/material.dart';
import '../models/expense.dart';

class AppConstants {
  static const String appName = 'Life Tracker';

  // Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  static const Color successColor = Color(0xFF10B981);
  static const Color dangerColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);

  // Expense Categories
  static final List<ExpenseCategory> expenseCategories = [
    const ExpenseCategory(
      id: 'food',
      name: 'Makanan',
      icon: '🍔',
      color: 0xFFFF9800,
    ),
    const ExpenseCategory(
      id: 'shopping',
      name: 'Belanja',
      icon: '🛍️',
      color: 0xFF2196F3,
    ),
    const ExpenseCategory(
      id: 'transport',
      name: 'Transport',
      icon: '🚗',
      color: 0xFF6366F1,
    ),
    const ExpenseCategory(
      id: 'home',
      name: 'Rumah',
      icon: '🏠',
      color: 0xFF9C27B0,
    ),
    const ExpenseCategory(
      id: 'entertainment',
      name: 'Hiburan',
      icon: '🎬',
      color: 0xFFE91E63,
    ),
    const ExpenseCategory(
      id: 'health',
      name: 'Kesehatan',
      icon: '💊',
      color: 0xFFF44336,
    ),
    const ExpenseCategory(
      id: 'education',
      name: 'Pendidikan',
      icon: '📚',
      color: 0xFFFFEB3B,
    ),
    const ExpenseCategory(
      id: 'salary',
      name: 'Gaji',
      icon: '💰',
      color: 0xFF4CAF50,
    ),
    const ExpenseCategory(
      id: 'other',
      name: 'Lainnya',
      icon: '📝',
      color: 0xFF9E9E9E,
    ),
  ];

  static ExpenseCategory getCategoryById(String id) {
    return expenseCategories.firstWhere(
          (cat) => cat.id == id,
      orElse: () => expenseCategories.last,
    );
  }

  // Habit Categories
  static const List<String> habitCategories = [
    'Kesehatan',
    'Produktivitas',
    'Personal',
    'Olahraga',
    'Mindset',
  ];

  // Habit Icons
  static const List<String> habitIcons = [
    '🧘',
    '📚',
    '💧',
    '🏃',
    '🥦',
    '💻',
    '☀️',
    '😴',
    '🧠',
    '🎹',
    '🐕',
    '💰',
    '🔥',
    '✨',
    '🎯',
  ];
}