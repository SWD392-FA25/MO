import 'package:flutter/material.dart';

import 'package:igcse_learning_hub/src/features/home/presentation/pages/home_page.dart';
import 'package:igcse_learning_hub/src/features/lunaby/presentation/pages/lunaby_page.dart';
import 'package:igcse_learning_hub/src/features/my_courses/presentation/pages/my_courses_page.dart';
import 'package:igcse_learning_hub/src/features/profile/presentation/pages/profile_page.dart';
import 'package:igcse_learning_hub/src/features/transactions/presentation/pages/transactions_page.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _index = 0;

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const MyCoursesPage();
      case 2:
        return const LunabyPage();
      case 3:
        return const TransactionsPage();
      case 4:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildPage(_index),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: Colors.white,
        elevation: 12,
        shadowColor: AppColors.cardShadow,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'My Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'Lunaby',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
