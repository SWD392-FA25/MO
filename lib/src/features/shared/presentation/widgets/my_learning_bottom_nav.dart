import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../my_courses/presentation/providers/order_provider.dart';
import '../../../theme/app_theme.dart';

class MyLearningBottomNav extends StatelessWidget {
  const MyLearningBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: const Color(0xFF141B1F3B),
            offset: Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Trang chủ',
              onTap: () => GoRouter.of(context).go('/dashboard'),
              isActive: _isActiveRoute(context, '/dashboard'),
            ),
            _NavItem(
              icon: Icons.school,
              label: 'Khóa học',
              onTap: () => GoRouter.of(context).go('/catalog'),
              isActive: _isActiveRoute(context, '/catalog'),
            ),
            _NavItem(
              icon: Icons.book,
              label: 'My Courses',
              onTap: () => GoRouter.of(context).go('/my-courses'),
              isActive: _isActiveRoute(context, '/my-courses'),
            ),
            _NavItem(
              icon: Icons.receipt_long,
              label: 'Đơn hàng',
              onTap: () => GoRouter.of(context).go('/transactions'),
              isActive: _isActiveRoute(context, '/transactions'),
            ),
            _NavItem(
              icon: Icons.person,
              label: 'Tài khoản',
              onTap: => GoRouter.of(context).go('/profile'),
              isActive: _isActiveRoute(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }

  bool _isActiveRoute(BuildContext context, String routePath) {
    return GoRouter.of(context).location.path == routePath ||
           GoRouter.of(context).location.path == '$routePath/';
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
