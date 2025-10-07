import 'package:flutter/material.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.hintText = 'Search for..',
    this.onChanged,
    this.controller,
    this.trailing,
    this.onTap,
    this.readOnly = false,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          showCursor: !readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (trailing != null) Positioned(right: 12, child: trailing!),
      ],
    );
  }
}
