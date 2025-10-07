import 'package:flutter/material.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E8FDB), AppColors.primary],
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.76,
            height: size * 0.76,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.2),
              color: Colors.white.withAlpha(31),
            ),
          ),
          Icon(
            Icons.auto_stories_rounded,
            color: Colors.white,
            size: size * 0.54,
          ),
        ],
      ),
    );
  }
}
