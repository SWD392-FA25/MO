import 'package:flutter/material.dart';

import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.imageAsset,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 16,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(18),
              ),
              child: imageAsset != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        imageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(icon, color: AppColors.primary, size: 28),
                      ),
                    )
                  : Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
