import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';
import '../../utils/constants.dart';
import '../../utils/formatter.dart';
import 'add_transaction_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'ALL';
  String _selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filters
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Filter
                Row(
                  children: [
                    const Icon(Icons.filter_list_rounded, size: 20, color: AppConstants.primaryColor),
                    const SizedBox(width: 8),
                    const Text(
                      'Filter Waktu:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('ALL', 'Semua'),
                      _buildFilterChip('TODAY', 'Hari Ini'),
                      _buildFilterChip('WEEK', 'Minggu Ini'),
                      _buildFilterChip('MONTH', 'Bulan Ini'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Category Filter
                Row(
                  children: [
                    const Icon(Icons.category_rounded, size: 20, color: AppConstants.primaryColor),
                    const SizedBox(width: 8),
                    const Text(
                      'Kategori:',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('ALL', '📋 Semua'),
                      ...AppConstants.expenseCategories.map((cat) {
                        return _buildCategoryChip(cat.id, '${cat.icon} ${cat.name}');
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Transaction List
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, _) {
                final filteredTransactions = _getFilteredTransactions(provider);

                if (filteredTransactions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada transaksi',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group by date
                final groupedTransactions = _groupByDate(filteredTransactions);

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: groupedTransactions.length,
                  itemBuilder: (context, index) {
                    final group = groupedTransactions[index];
                    return _buildDateGroup(group['date'] as DateTime, group['transactions'] as List<Expense>);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        backgroundColor: Colors.grey.shade100,
        selectedColor: AppConstants.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildCategoryChip(String value, String label) {
    final isSelected = _selectedCategory == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = value;
          });
        },
        backgroundColor: Colors.grey.shade100,
        selectedColor: AppConstants.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  List<Expense> _getFilteredTransactions(ExpenseProvider provider) {
    var transactions = provider.expenses;

    // Filter by time
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'TODAY':
        transactions = transactions.where((t) {
          return t.date.year == now.year &&
              t.date.month == now.month &&
              t.date.day == now.day;
        }).toList();
        break;
      case 'WEEK':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        transactions = transactions.where((t) {
          return t.date.isAfter(weekStart.subtract(const Duration(days: 1)));
        }).toList();
        break;
      case 'MONTH':
        transactions = transactions.where((t) {
          return t.date.year == now.year && t.date.month == now.month;
        }).toList();
        break;
    }

    // Filter by category
    if (_selectedCategory != 'ALL') {
      transactions = transactions.where((t) => t.categoryId == _selectedCategory).toList();
    }

    return transactions;
  }

  List<Map<String, dynamic>> _groupByDate(List<Expense> transactions) {
    final Map<String, List<Expense>> grouped = {};

    for (var transaction in transactions) {
      final dateKey = '${transaction.date.year}-${transaction.date.month}-${transaction.date.day}';
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedKeys.map((key) {
      final parts = key.split('-');
      return {
        'date': DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])),
        'transactions': grouped[key]!,
      };
    }).toList();
  }

  Widget _buildDateGroup(DateTime date, List<Expense> transactions) {
    final dailyTotal = transactions.fold<double>(0, (sum, t) {
      return sum + (t.type == 'INCOME' ? t.amount : -t.amount);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatter.dateHeader(date),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                '${dailyTotal >= 0 ? '+' : ''}${Formatter.compactCurrency(dailyTotal.abs())}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: dailyTotal >= 0 ? AppConstants.successColor : AppConstants.dangerColor,
                ),
              ),
            ],
          ),
        ),
        ...transactions.map((transaction) => _buildTransactionItem(transaction)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTransactionItem(Expense transaction) {
    final category = AppConstants.getCategoryById(transaction.categoryId);
    final isIncome = transaction.type == 'INCOME';

    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Hapus Transaksi'),
                content: const Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          );
        } else {
          // Edit
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTransactionScreen(expense: transaction),
            ),
          );
          return false;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(transaction.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaksi berhasil dihapus'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(category.color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (transaction.note != null && transaction.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      transaction.note!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${Formatter.currency(transaction.amount)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome ? AppConstants.successColor : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}