import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../src/data/mock_data.dart';
import '../../../../src/models/course.dart';
import '../../../../src/theme/design_tokens.dart';
import '../widgets/course_card.dart';
import '../widgets/filter_button.dart';
import '../../../../shared/widgets/search_field.dart';

class CoursesListPage extends StatefulWidget {
  const CoursesListPage({super.key, this.initialQuery = 'Graphic Design'});

  final String initialQuery;

  @override
  State<CoursesListPage> createState() => _CoursesListPageState();
}

class _CoursesListPageState extends State<CoursesListPage> {
  late final TextEditingController _controller;
  int _selectedFilterIndex = 1;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courses = _filteredCourses;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Online Courses',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchField(
                controller: _controller,
                trailing: FilterButton(onPressed: () {}),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Result for 'Creative Arts'",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    '${courses.length * 620} Founds',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
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
    if (filter == 'All') {
      return mockCourses;
    }
    return mockCourses
        .where(
          (course) => course.category == filter || course.subject == filter,
        )
        .toList();
  }
}
