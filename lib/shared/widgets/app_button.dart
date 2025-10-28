import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final bool isExpanded;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.width,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final buttonChild = Row(
      mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 8),
        ],
        if (isLoading)
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == ButtonType.primary
                    ? Colors.white
                    : theme.colorScheme.primary,
              ),
            ),
          )
        else
          Text(label),
      ],
    );

    final button = switch (type) {
      ButtonType.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            padding: _getPadding(),
          ),
          child: buttonChild,
        ),
      ButtonType.secondary => FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: _getPadding(),
          ),
          child: buttonChild,
        ),
      ButtonType.outline => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: _getPadding(),
          ),
          child: buttonChild,
        ),
      ButtonType.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: _getPadding(),
          ),
          child: buttonChild,
        ),
    };

    if (width != null) {
      return SizedBox(width: width, child: button);
    }
    
    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    
    return button;
  }

  EdgeInsetsGeometry _getPadding() {
    return switch (size) {
      ButtonSize.small => const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ButtonSize.medium => const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ButtonSize.large => const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
    };
  }

  double _getIconSize() {
    return switch (size) {
      ButtonSize.small => 16,
      ButtonSize.medium => 20,
      ButtonSize.large => 24,
    };
  }
}
