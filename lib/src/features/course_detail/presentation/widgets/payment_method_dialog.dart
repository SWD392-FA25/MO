import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:igcse_learning_hub/src/theme/design_tokens.dart';
import 'package:igcse_learning_hub/src/features/transactions/presentation/providers/order_provider.dart';
import 'package:igcse_learning_hub/src/features/transactions/domain/repositories/order_repository.dart';

class PaymentMethodDialog extends StatefulWidget {
  final String courseId;
  final double price;
  final VoidCallback onPaymentSuccess;

  const PaymentMethodDialog({
    super.key,
    required this.courseId,
    required this.price,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentMethodDialog> createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  String? _selectedMethod;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Total: \$${widget.price.toStringAsFixed(2)}',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            
            // Cash Payment Option
            _PaymentMethodTile(
              icon: Icons.money,
              title: 'Cash Payment',
              subtitle: 'Pay with cash',
              isSelected: _selectedMethod == 'cash',
              isEnabled: true,
              onTap: () => setState(() => _selectedMethod = 'cash'),
            ),
            
            const SizedBox(height: 12),
            
            // VNPay QR Option (Disabled)
            _PaymentMethodTile(
              icon: Icons.qr_code,
              title: 'VNPay QR',
              subtitle: 'Under Maintenance',
              isSelected: _selectedMethod == 'vnpay',
              isEnabled: false,
              onTap: () {}, // Disabled
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing || _selectedMethod == null
                        ? null
                        : _handlePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    if (_selectedMethod == null) return;

    setState(() => _isProcessing = true);

    try {
      if (_selectedMethod == 'cash') {
        final orderProvider = context.read<OrderProvider>();
        final success = await orderProvider.completeCashPaymentFlow(widget.courseId);
        
        if (mounted) {
          if (success) {
            Navigator.of(context).pop();
            widget.onPaymentSuccess();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(orderProvider.errorMessage ?? 'Payment failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final opacity = isEnabled ? 1.0 : 0.4;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        opacity: opacity,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
            color: isSelected ? AppColors.primary.withAlpha(13) : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withAlpha(26)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primary : Colors.grey.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: isEnabled
                            ? AppColors.textSecondary
                            : Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
