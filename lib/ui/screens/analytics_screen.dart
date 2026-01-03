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
    Color(0xffe8a427),
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

    final double total = categoryTotals.values.fold(0, (a, b) => a + b);
    const double minPercent = 5;
    int i = 0;
    final List<double> realPercents = categoryTotals.values
        .map((v) => (v / total) * 100)
        .toList();

    List<double> displayPercents = [];
    double overflow = 0;

    for (final p in realPercents) {
      if (p < minPercent) {
        displayPercents.add(minPercent);
        overflow += minPercent - p;
      } else {
        displayPercents.add(p);
      }
    }

// reduce overflow from bigger slices
    for (int j = 0; j < displayPercents.length && overflow > 0; j++) {
      if (realPercents[j] > minPercent) {
        final reducible = displayPercents[j] - minPercent;
        final reduction = reducible.clamp(0, overflow);
        displayPercents[j] -= reduction;
        overflow -= reduction;
      }
    }

   // int i = 0;

    final sections = categoryTotals.entries.map((entry) {
      final realValue = entry.value;
      final realPercent = (realValue / total) * 100;
      final displayPercent = displayPercents[i];

      final color = colors[i % colors.length];
      i++;

      final showTitle = realPercent >= 3;

      return PieChartSectionData(
        value: displayPercent,
        title: showTitle
            ? '${entry.key}\n${realPercent.toStringAsFixed(0)}%'
            : '',
        radius: 90,
        color: color,
        titleStyle: GoogleFonts.raleway(
          fontSize: 12,
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            //
            SizedBox(
              height: 260,
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    final animatedSections = sections.map((s) {
                      return s.copyWith(
                        value: s.value * value,       // scale value by t
                        title: value == 1
                            ? s.title            // show title at end
                            : '',


                      ); // scale from 0 → full
                    }).toList();

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: PieChart(
                        PieChartData(
                          sections: animatedSections,
                          sectionsSpace: 0.5,
                          centerSpaceRadius: 55,
                          pieTouchData: PieTouchData(
                            enabled: true,
                            touchCallback: (event, response) {},
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Category Distribution',
              style: GoogleFonts.raleway(
                textStyle:  const TextStyle(letterSpacing: .2,fontWeight: FontWeight.bold,fontSize: 23),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),

      ),
    );
  }
}