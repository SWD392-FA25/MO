import 'package:flutter/material.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Icon(Icons.tune, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
