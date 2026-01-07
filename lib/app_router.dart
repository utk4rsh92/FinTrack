
import 'package:fintrack/ui/screens/add_expense_screen.dart';
import 'package:fintrack/ui/screens/analytics_screen.dart';
import 'package:fintrack/ui/screens/dashboard_screen.dart';
import 'package:fintrack/ui/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
      routes: [
        GoRoute(
          path: 'home',
          name: 'home',
          builder: (context, state) => const DashboardScreens(),
        ),
        GoRoute(
          path: 'add',
          name: 'add',
          builder: (context, state) => const AddExpenseScreen(),
        ),
        GoRoute(
          path: 'analytics',
          name: 'analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
      ],
    ),
  ],
);
