import 'package:fintrack/main.dart';
import 'package:fintrack/providers/expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final colors = [
    Color(0xff5071c3),
    Color(0xff26aab3),
    Color(0xffe14d74),
    Color(0xffe45264),
    Color(0xff85dbe1),
    Color(0xff4bb696),
    Color(0xffa581c7),
  ];

  int i = 0;

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;
    final Map<String, double> categoryTotals = {};
    for (var e in expenses) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0) + e.amount;
    }
    final sections = categoryTotals.entries.map((entry) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title:  Text('Analytics',style: GoogleFonts.raleway())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: expenses.isEmpty
            ? const Center(child: Text('No data yet'))
            : Column(
          children: [
             Text(
              'Category Distribution',
              style: GoogleFonts.raleway(
                textStyle: TextStyle( letterSpacing: .5),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 3,
                  centerSpaceRadius: 40,
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}