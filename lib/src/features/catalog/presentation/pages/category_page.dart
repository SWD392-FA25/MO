import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/data/mock_data.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/category_tile.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/filter_button.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/filter_selection_sheet.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/search_field.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'All Category',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SearchField(
                trailing: FilterButton(onPressed: _openFilterSheet),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(categoryFilters[_selectedFilter]),
                    avatar: const Icon(Icons.filter_alt_outlined, size: 18),
                  ),
                  Text(
                    '${items.length} kết quả',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final iconKey = item['icon']!;
                    return CategoryTile(
                      title: item['title']!,
                      icon: _mapIcon(iconKey),
                      imageAsset: _assetForIcon(iconKey),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _mapIcon(String key) {
    switch (key) {
      case 'math':
        return Icons.calculate_rounded;
      case 'science':
        return Icons.biotech_rounded;
      case 'tech':
        return Icons.computer_rounded;
      case 'language':
        return Icons.language_rounded;
      case 'pe':
        return Icons.self_improvement_rounded;
      case 'art':
        return Icons.brush_rounded;
      case 'humanities':
        return Icons.psychology_rounded;
      case 'business':
        return Icons.account_balance_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  String? _assetForIcon(String key) {
    switch (key) {
      case 'pe':
        return 'assets/images/category_physical_education.png';
      case 'humanities':
        return 'assets/images/category_social_science.png';
      default:
        return null;
    }
  }

  List<Map<String, String>> get _filteredItems {
    final filter = categoryFilters[_selectedFilter];
    if (filter == 'All') return categoryGridItems;
    return categoryGridItems
        .where(
          (item) => item['title']!
              .toLowerCase()
              .contains(filter.toLowerCase()),
        )
        .toList();
  }

  Future<void> _openFilterSheet() async {
    final selected = await showFilterSelectionSheet(
      context: context,
      options: categoryFilters,
      selectedIndex: _selectedFilter,
      title: 'Bộ lọc danh mục',
    );
    if (!mounted || selected == null) return;
    setState(() => _selectedFilter = selected);
  }
}
