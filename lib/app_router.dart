
import 'package:fintrack/ui/screens/add_expense_screen.dart';
import 'package:fintrack/ui/screens/dashboard_screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
   initialLocation: '/',
   routes: [
     GoRoute(path: '/',
     builder: (context,state)=>const DashboardScreens() ),
     GoRoute(path: '/add',
     builder: (context,state)=>const AddExpenseScreen() ),
   ],
);