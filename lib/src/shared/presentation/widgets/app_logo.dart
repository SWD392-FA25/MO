import 'package:flutter/material.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  static const _primaryAsset = 'assets/images/app_logo_mobile.png';
  static const _fallbackAsset = 'assets/images/app_logo.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.24),
        child: Image.asset(
          _primaryAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, _, __) {
            return Image.asset(
              _fallbackAsset,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, __, ___) => _FallbackLogo(size: size),
            );
          },
        ),
      ),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E8FDB), AppColors.primary],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_stories_rounded,
          color: Colors.white,
          size: size * 0.54,
        ),
      ),
    );
  }
}
