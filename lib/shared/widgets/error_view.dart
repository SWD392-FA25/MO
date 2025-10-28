import 'package:flutter/material.dart';
import 'app_button.dart';

class ErrorView extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Widget? image;

  const ErrorView({
    super.key,
    this.title,
    required this.message,
    this.onRetry,
    this.icon,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) ...[
              image!,
              const SizedBox(height: 24),
            ] else ...[
              Icon(
                icon ?? Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: 'Retry',
                onPressed: onRetry,
                type: ButtonType.primary,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  final String? title;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;
  final IconData? icon;
  final Widget? image;

  const EmptyView({
    super.key,
    this.title,
    required this.message,
    this.onAction,
    this.actionLabel,
    this.icon,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) ...[
              image!,
              const SizedBox(height: 24),
            ] else ...[
              Icon(
                icon ?? Icons.inbox,
                size: 64,
                color: theme.hintColor.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                type: ButtonType.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
