import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/mock_data.dart';
import '../../models/course.dart';
import '../../theme/design_tokens.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_button.dart';
import '../widgets/search_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(textTheme: textTheme),
                    const SizedBox(height: 24),
                    SearchField(trailing: FilterButton(onPressed: () {})),
                    const SizedBox(height: 24),
                    const _SpecialOfferCard(),
                    const SizedBox(height: 28),
                    _SectionHeading(
                      title: 'Categories',
                      onActionTap: () => context.go('/categories'),
                    ),
                    const SizedBox(height: 16),
                    _CategoryScroller(items: homeCategories),
                    const SizedBox(height: 24),
                    _SectionHeading(
                      title: 'Popular Courses',
                      onActionTap: () => context.go('/courses/popular'),
                    ),
                    const SizedBox(height: 16),
                    _FilterChips(
                      selectedIndex: _selectedFilterIndex,
                      onSelected: (index) =>
                          setState(() => _selectedFilterIndex = index),
                    ),
                    const SizedBox(height: 20),
                    ..._buildCoursesForFilter(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _HomeNavigationBar(
        onItemSelected: (index) {
          if (index == 0) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Only Home is implemented in this mockup.'),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(label: 'Close', onPressed: () {}),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCoursesForFilter() {
    final filter = categoryFilters[_selectedFilterIndex];
    final Iterable<Course> filtered = filter == 'All'
        ? mockCourses
        : mockCourses.where(
            (course) => course.category == filter || course.subject == filter,
          );
    return filtered
        .map(
          (course) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CourseCard(course: course),
          ),
        )
        .toList();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, Shirayuki Luna',
                style: textTheme.titleLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                'What would you like to learn today?\nSearch below.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _SpecialOfferCard extends StatelessWidget {
  const _SpecialOfferCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5C53FF), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '25% OFF*',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Today's Special",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Get a discount for every course order only valid for today.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.onActionTap});

  final String title;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(title, style: textTheme.titleMedium),
        const Spacer(),
        TextButton(onPressed: onActionTap, child: const Text('SEE ALL')),
      ],
    );
  }
}

class _CategoryScroller extends StatelessWidget {
  const _CategoryScroller({required this.items});

  final List<Map<String, String>> items;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final label = items[index]['label']!;
          return Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: index == 1 ? AppColors.primary : AppColors.textSecondary,
              fontWeight: index == 1 ? FontWeight.w600 : FontWeight.w500,
            ),
          );
        },
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < categoryFilters.length; i++)
            Padding(
              padding: EdgeInsets.only(
                right: i == categoryFilters.length - 1 ? 0 : 12,
              ),
              child: ChoiceChip(
                selected: selectedIndex == i,
                onSelected: (_) => onSelected(i),
                label: Text(categoryFilters[i]),
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeNavigationBar extends StatefulWidget {
  const _HomeNavigationBar({required this.onItemSelected});

  final ValueChanged<int> onItemSelected;

  @override
  State<_HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<_HomeNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      height: 72,
      onDestinationSelected: (index) {
        setState(() => _currentIndex = index);
        widget.onItemSelected(index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          label: 'My Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_books_outlined),
          label: 'Library',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Transaction',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
