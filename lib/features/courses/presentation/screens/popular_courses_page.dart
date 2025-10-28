import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../src/data/mock_data.dart';
import '../../../../src/models/course.dart';
import '../../../../src/theme/design_tokens.dart';
import '../widgets/course_card.dart';

class PopularCoursesPage extends StatefulWidget {
  const PopularCoursesPage({super.key});

  @override
  State<PopularCoursesPage> createState() => _PopularCoursesPageState();
}

class _PopularCoursesPageState extends State<PopularCoursesPage> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Popular Courses',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (var i = 0; i < categoryFilters.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        right: i == categoryFilters.length - 1 ? 0 : 12,
                      ),
                      child: ChoiceChip(
                        selected: _selectedFilterIndex == i,
                        onSelected: (_) =>
                            setState(() => _selectedFilterIndex = i),
                        label: Text(categoryFilters[i]),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = _filteredCourses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CourseCard(course: course),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Course> get _filteredCourses {
    final filter = categoryFilters[_selectedFilterIndex];
    if (filter == 'All') return mockCourses;
    return mockCourses
        .where(
          (course) => course.category == filter || course.subject == filter,
        )
        .toList();
  }
}
