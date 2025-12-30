import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/expense_provider.dart';

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
      appBar: AppBar(title: const Text('FinTrack')),
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
              style: Theme.of(context).textTheme.headlineMedium,
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
                return ListTile(
                  title: Text(e.title.toUpperCase()),
                  subtitle: Text('${e.category} • $formattedTime'),
                  trailing: Text('₹${e.amount}'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

