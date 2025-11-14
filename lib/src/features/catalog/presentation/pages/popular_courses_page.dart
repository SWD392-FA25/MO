import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:igcse_learning_hub/src/data/mock_data.dart';
import 'package:igcse_learning_hub/src/features/catalog/presentation/providers/course_provider.dart';
import 'package:igcse_learning_hub/src/models/course.dart';
import 'package:igcse_learning_hub/src/models/course_extensions.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/course_card.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class PopularCoursesPage extends StatefulWidget {
  const PopularCoursesPage({super.key});

  @override
  State<PopularCoursesPage> createState() => _PopularCoursesPageState();
}

class _PopularCoursesPageState extends State<PopularCoursesPage> {
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses(refresh: true, pageSize: 65);
    });
  }

  void _onFilterSelected(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
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
                        onSelected: (_) => _onFilterSelected(i),
                        label: Text(categoryFilters[i]),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _buildCoursesList(courseProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesList(CourseProvider courseProvider) {
    // Show loading indicator
    if (courseProvider.isLoading && courseProvider.courses.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error message
    if (courseProvider.errorMessage != null && courseProvider.courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                courseProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => courseProvider.loadCourses(refresh: true, pageSize: 65),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Get courses from API
    final courses = courseProvider.courses;

    // Show empty state
    if (courses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No courses available',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    // Filter courses by subjectGroup on client-side
    final selectedSubjectGroup = _selectedFilterIndex == 0 
        ? null 
        : categoryFilters[_selectedFilterIndex];
    
    final filteredCourses = selectedSubjectGroup == null
        ? courses
        : courses.where((course) => course.subjectGroup == selectedSubjectGroup).toList();

    // Show empty state if no courses match filter
    if (filteredCourses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'No courses found for this category',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    // Convert to UI models and display
    final uiCourses = filteredCourses.toUIModels();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: uiCourses.length,
      itemBuilder: (context, index) {
        final course = uiCourses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CourseCard(
            course: course,
            onTap: () => context.push('/courses/${course.id}'),
          ),
        );
      },
    );
  }
}
