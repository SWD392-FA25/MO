import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:igcse_learning_hub/src/data/mock_data.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/category_tile.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/filter_button.dart';
import 'package:igcse_learning_hub/src/shared/presentation/widgets/search_field.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              SearchField(trailing: FilterButton(onPressed: () {})),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: categoryGridItems.length,
                  itemBuilder: (context, index) {
                    final item = categoryGridItems[index];
                    return CategoryTile(
                      title: item['title']!,
                      icon: _mapIcon(item['icon']!),
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
}
