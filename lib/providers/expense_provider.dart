
import 'package:flutter/material.dart';

import '../data/models/expense_model.dart';

class ExpenseProvider extends ChangeNotifier{
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  double get totalAmount =>
      _expenses.fold(0, (sum, item)=> sum + item.amount);

  void addExpense(Expense expense){
    _expenses.add(expense);
    notifyListeners();
  }


}