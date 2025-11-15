import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../transactions/presentation/providers/order_provider.dart';
import '../../../transactions/domain/entities/order.dart';
import '../../../../theme/design_tokens.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({
    super.key,
    required this.orderId,
  });

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order Details #$orderId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, _) {
          return FutureBuilder<void>(
            future: () async {
              if (orderProvider.selectedOrder?.id != orderId) {
                await orderProvider.loadOrderById(orderId);
              }
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  orderProvider.selectedOrder == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (orderProvider.errorMessage != null &&
                  orderProvider.selectedOrder == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        orderProvider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => orderProvider.loadOrderById(orderId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (orderProvider.selectedOrder == null) {
                return const Center(
                  child: Text('Order not found'),
                );
              }

              final order = orderProvider.selectedOrder!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Status Card
                    _OrderStatusCard(order: order),

                    const SizedBox(height: 24),

                    // Order Items Card
                    _OrderItemsCard(order: order),

                    const SizedBox(height: 24),

                    // Order Summary Card
                    _OrderSummaryCard(order: order),

                    const SizedBox(height: 24),

                    // Action Buttons
                    if (order.isPending) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final checkoutUrl = await orderProvider.checkoutOrder(order.id, 'vnpay');
                            if (!context.mounted) return;
                            
                            if (checkoutUrl != null) {
                              // Open VNPay URL in browser
                              context.push('/payment/vnpay?url=${Uri.encodeComponent(checkoutUrl)}');
                            } else if (orderProvider.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(orderProvider.errorMessage!),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text('Pay Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Status',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getOrderStatusColor(order.status).withAlpha(24),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  _getOrderStatusIcon(order.status),
                  color: _getOrderStatusColor(order.status),
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getOrderStatusText(order.status),
                        style: textTheme.titleMedium?.copyWith(
                          color: _getOrderStatusColor(order.status),
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _OrderInfoRow(
            label: 'Order ID',
            value: order.id,
          ),
          _OrderInfoRow(
            label: 'Created At',
            value: _formatFullDate(order.createdAt),
          ),
          if (order.paidAt != null)
            _OrderInfoRow(
              label: 'Paid At',
              value: _formatFullDate(order.paidAt!),
            ),
        ],
      ),
    );
  }
}

class _OrderItemsCard extends StatelessWidget {
  const _OrderItemsCard({
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ...order.items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primary.withAlpha(24),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.itemName,
                          style: textTheme.titleSmall,
                        ),
                        Text(
                          'Quantity: ${item.quantity}',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: Offset(0, 10),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _OrderSummaryRow(
            label: 'Subtotal',
            value: '\$${order.totalAmount.toStringAsFixed(2)}',
          ),
          _OrderSummaryRow(
            label: 'Shipping',
            value: '\$0.00',
          ),
          _OrderSummaryRow(
            label: 'Tax',
            value: '\$0.00',
          ),
          const Divider(),
          _OrderSummaryRow(
            label: 'Total',
            value: '\$${order.totalAmount.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _OrderInfoRow extends StatelessWidget {
  const _OrderInfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  const _OrderSummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: (isBold ? textTheme.titleMedium : textTheme.bodyMedium)
                ?.copyWith(
              color: isBold ? AppColors.primary : null,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _getOrderStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Icons.pending;
    case 'paid':
    case 'completed':
      return Icons.check_circle;
    case 'failed':
    case 'cancelled':
      return Icons.error;
    default:
      return Icons.receipt_long;
  }
}

Color _getOrderStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return AppColors.primary;
    case 'paid':
    case 'completed':
      return Colors.green;
    case 'failed':
    case 'cancelled':
      return Colors.red;
    default:
      return AppColors.textSecondary;
  }
}

String _getOrderStatusText(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'Pending';
    case 'paid':
    case 'completed':
      return 'Completed';
    case 'failed':
      return 'Failed';
    case 'cancelled':
      return 'Cancelled';
    default:
      return status;
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String _formatFullDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}
