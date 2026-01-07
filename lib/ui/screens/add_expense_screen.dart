import 'package:fintrack/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String category = 'Food';
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

            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Food', child: Text('Food')),
                DropdownMenuItem(value: 'Travel', child: Text('Travel')),
                DropdownMenuItem(value: 'Bills', child: Text('Bills')),
                DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,   // full width
              height: 45,               // ideal material button height
              child: ElevatedButton(
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
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child:  Text(
                  'Save',
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )

          ],
    ),
    ),
    );
  }
}