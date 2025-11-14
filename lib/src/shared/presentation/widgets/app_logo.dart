import 'package:flutter/material.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.width, this.height});

  final double? width;
  final double? height;

  static const _logoAsset = 'assets/images/LogoHaveText.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _logoAsset,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, _, __) => _FallbackLogo(width: width, height: height),
    );
  }
}

class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Center(
        child: Text(
          'IGCSE MASTERY',
          style: TextStyle(
            fontSize: (width ?? 200) * 0.1,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
