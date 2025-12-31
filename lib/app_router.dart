
import 'package:fintrack/ui/screens/add_expense_screen.dart';
import 'package:fintrack/ui/screens/analytics_screen.dart';
import 'package:fintrack/ui/screens/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

// final appRouter = GoRouter(
//    initialLocation: '/',
//    routes: [
//      GoRoute(path: '/',
//      builder: (context,state)=>const DashboardScreens() ),
//      GoRoute(path: '/add',
//      builder: (context,state)=>const AddExpenseScreen() ),
//    ],
// );


final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreens(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddExpenseScreen(),
        ),
        GoRoute(
          path: 'analytics',
          builder: (context, state) =>  const AnalyticsScreen(),
        ),

      ],
    ),
  ],
);