
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/models/expense_model.dart';
import '../../providers/expense_provider.dart';

Future<void> showEditDialog(BuildContext context, Expense expense) async {
  final title = TextEditingController(text: expense.title);
  final amount = TextEditingController(text: expense.amount.toString());
  String category = expense.category;

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title:  Text('Edit Expense',style: GoogleFonts.raleway(),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: category,
            items: const [
              DropdownMenuItem(value: 'Food', child: Text('Food')),
              DropdownMenuItem(value: 'Travel', child: Text('Travel')),
              DropdownMenuItem(value: 'Bills', child: Text('Bills')),
              DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => category = v!,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final updated = Expense(
              id: expense.id,
              title: title.text,
              amount: double.parse(amount.text),
              category: category,
              time: expense.time,
            );

            await context.read<ExpenseProvider>().updateExpense(updated);
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}
