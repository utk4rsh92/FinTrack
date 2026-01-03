
import 'package:flutter/material.dart';

import '../data/models/expense_model.dart';
import '../data/services/database_service.dart';

class ExpenseProvider extends ChangeNotifier{
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;
  final dbService = DatabaseService();

  double get totalAmount =>
      _expenses.fold(0, (sum, item)=> sum + item.amount);

  // void addExpense(Expense expense){
  //   _expenses.add(expense);
  //   notifyListeners();
  // }

  Future<void> addExpense(Expense expense) async {
    final db = await dbService.database;

    await db.insert('expenses', {
      'id': expense.id,
      'title': expense.title,
      'amount': expense.amount,
      'category': expense.category,
      'time': expense.time.toIso8601String(),
    });

    _expenses.add(expense);
    notifyListeners();
  }

  Future<void> loadExpenses() async {
    final db = await dbService.database;
    final data = await db.query('expenses');

    _expenses.clear();
    for (var item in data) {
      _expenses.add(
        Expense(
          id: item['id'] as String,
          title: item['title'] as String,
          amount: item['amount'] as double,
          category: item['category'] as String,
          time: DateTime.parse(item['time'] as String),
        ),
      );
    }

    notifyListeners();
  }


  Future<void> deleteExpense(String id) async {
    final db = await dbService.database;

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    _expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  Future<void> updateExpense(Expense updated) async {
    final db = await dbService.database;

    await db.update(
      'expenses',
      {
        'title': updated.title,
        'amount': updated.amount,
        'category': updated.category,
      },
      where: 'id = ?',
      whereArgs: [updated.id],
    );

    final index = _expenses.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _expenses[index] = updated;
      notifyListeners();
    }
  }



}