import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/expense_model.dart';
import '../../providers/expense_provider.dart';
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final title = TextEditingController();
  final amount = TextEditingController();
  String category = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense'),),
      body: Padding(padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
      TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
      const SizedBox(height: 12),
      ElevatedButton(
        onPressed: () {
          final expense = Expense(
            id: const Uuid().v4(),
            title: title.text,
            amount: double.parse(amount.text),
            category: category,
            time: DateTime.now(),
          );

          context.read<ExpenseProvider>().addExpense(expense);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffdb8743),
           // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            textStyle: const TextStyle(
                fontSize: 10,
                color: Colors.white
                //fontWeight: FontWeight.bold
            )
        ),
        child: const Text('Save'),
      )
      ],
    ),
    ),
    );
  }
}