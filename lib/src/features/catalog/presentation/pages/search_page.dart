import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/data/mock_data.dart';
import 'package:igcse_learning_hub/src/models/course.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/course_card.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/filter_button.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/search_field.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;
  String _query = '';
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredCourses;
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
                    'Search Courses',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchField(
                controller: _controller,
                hintText: 'Tìm khóa học, chủ đề, giáo viên...',
                onChanged: (value) => setState(() => _query = value.trim()),
                trailing: FilterButton(onPressed: () {}),
              ),
            ),
            const SizedBox(height: 12),
            _buildSuggestionChips(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Found ${results.length} courses',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: results.isEmpty
                  ? _EmptyState(onReset: _clearQuery)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final course = results[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == results.length - 1 ? 24 : 16,
                          ),
                          child: CourseCard(
                            course: course,
                            onTap: () => context.push(
                              '/courses/${course.id}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < categoryFilters.length; i++)
            Padding(
              padding: EdgeInsets.only(
                right: i == categoryFilters.length - 1 ? 0 : 12,
              ),
              child: ChoiceChip(
                selected: _selectedCategory == i,
                onSelected: (_) => setState(() => _selectedCategory = i),
                label: Text(categoryFilters[i]),
              ),
            ),
        ],
      ),
    );
  }

  void _clearQuery() {
    setState(() {
      _controller.clear();
      _query = '';
      _selectedCategory = 0;
    });
  }

  List<Course> get _filteredCourses {
    final normalizedQuery = _query.toLowerCase();
    final selectedFilter = categoryFilters[_selectedCategory];
    Iterable<Course> filtered = mockCourses;

    if (selectedFilter != 'All') {
      filtered = filtered.where(
        (course) =>
            course.category == selectedFilter ||
            course.subject == selectedFilter,
      );
    }

    if (normalizedQuery.isEmpty) {
      return filtered.toList();
    }

    return filtered
        .where(
          (course) =>
              course.title.toLowerCase().contains(normalizedQuery) ||
              course.subject.toLowerCase().contains(normalizedQuery),
        )
        .toList();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Không tìm thấy kết quả',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Hãy thử lại với từ khóa khác hoặc chọn danh mục khác phù hợp hơn.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onReset,
              child: const Text('Làm mới bộ lọc'),
            ),
          ],
        ),
      ),
    );
  }
}
