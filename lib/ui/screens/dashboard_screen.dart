import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';
import '../../providers/theme_provider.dart';
import '../widgets/edit_expense.dart';

class DashboardScreens extends StatefulWidget {
  const DashboardScreens({super.key});

  @override
  State<DashboardScreens> createState() => _DashboardScreensState();
}

class _DashboardScreensState extends State<DashboardScreens> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ExpenseProvider>().loadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;
    final total = context.watch<ExpenseProvider>().totalAmount;
    return Scaffold(
      appBar: AppBar(title:  Text('FinTrack', style: GoogleFonts.raleway()),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final theme = context.read<ThemeProvider>();
              theme.toggleTheme();
            },
          ),

          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () => context.push('/analytics'),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffdb8743),
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Total Spent: ₹${total.toStringAsFixed(2)}',
               style: GoogleFonts.raleway(fontWeight: FontWeight.bold,fontSize: 22),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: expenses.length,
              separatorBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: Color(0xffacaaaf),
                  thickness: 0.4,
                  height: 0,
                ),
              ),
              itemBuilder: (context, index) {
                final e = expenses[index];
                final formattedTime = DateFormat('dd MMM, hh:mm a').format(e.time);

                 return Dismissible(
                  key: ValueKey(e.id),
                  direction: DismissDirection.horizontal,

                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),

                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // Swipe ➡️ Edit
                   //   Navigator.of(context).pushNamed('/edit', arguments: e);
                      showEditDialog(context, e);

                      // Return false so the item stays in the list
                      return false;
                    }

                    // Swipe ⬅️ Delete
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Expense'),
                        content: const Text('Are you sure you want to delete this expense?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    return shouldDelete ?? false;
                  },

                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await context.read<ExpenseProvider>().deleteExpense(e.id);
                    }
                  },

                  child: ListTile(
                    title: Text(e.title.toUpperCase()),
                    subtitle: Text('${e.category} • $formattedTime'),
                    trailing: Text('₹${e.amount}'),
                  ),
                );

              },

            ),
          )
        ],
      ),
    );
  }
}

