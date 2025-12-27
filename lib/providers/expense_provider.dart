import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../utils/database_helper.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  double get totalIncome => _expenses
      .where((e) => e.type == 'INCOME')
      .fold(0, (sum, e) => sum + e.amount);

  double get totalExpense => _expenses
      .where((e) => e.type == 'EXPENSE')
      .fold(0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpense;

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    _expenses = await DatabaseHelper.instance.getAllExpenses();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await DatabaseHelper.instance.insertExpense(expense);
    _expenses.insert(0, expense);
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    await DatabaseHelper.instance.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  Future<void> deleteExpense(String id) async {
    await DatabaseHelper.instance.deleteExpense(id);
    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses.where((e) {
      return e.date.isAfter(start.subtract(const Duration(days: 1))) &&
          e.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, double> getCategoryExpenses() {
    final Map<String, double> categoryTotals = {};

    for (var expense in _expenses.where((e) => e.type == 'EXPENSE')) {
      categoryTotals[expense.categoryId] =
          (categoryTotals[expense.categoryId] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }
}