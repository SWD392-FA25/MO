import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart';
import '../../domain/entities/order.dart';
import '../../../../theme/design_tokens.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Đơn hàng của tôi'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Tất cả'),
                  Tab(text: 'Đang xử lý'),
                  Tab(text: 'Hoàn thành'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _OrdersList(
                  orders: orderProvider.orders,
                  onTap: (order) => context.push('/orders/${order.id}'),
                  loading: orderProvider.isLoading,
                  errorMessage: orderProvider.errorMessage,
                  onRetry: () => orderProvider.loadOrders(),
                ),
                _OrdersList(
                  orders: orderProvider.pendingOrders,
                  onTap: (order) => context.push('/orders/${order.id}'),
                  loading: orderProvider.isLoading,
                  errorMessage: orderProvider.errorMessage,
                  onRetry: () => orderProvider.loadOrders(),
                ),
                _OrdersList(
                  orders: orderProvider.completedOrders,
                  onTap: (order) => context.push('/orders/${order.id}'),
                  loading: orderProvider.isLoading,
                  errorMessage: orderProvider.errorMessage,
                  onRetry: () => orderProvider.loadOrders(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({
    required this.orders,
    required this.onTap,
    required this.loading,
    required this.errorMessage,
    required this.onRetry,
  });

  final List<Order> orders;
  final ValueChanged<Order> onTap;
  final bool loading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (loading && orders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (errorMessage != null && orders.isEmpty) {
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
              errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
              ElevatedButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (orders.isEmpty) {
      return const Center(
        child: Text('Không có đơn hàng nào ở danh mục này'),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => onTap(order),
          child: Ink(
            padding: const EdgeInsets.all(20),
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
                Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.primary.withAlpha(20),
                      ),
                      child: Icon(
                        _getOrderStatusIcon(order.status),
                        color: _getOrderStatusColor(order.status),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Đơn hàng #${order.id.substring(0, 8)}',
                                style: textTheme.titleMedium,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: _getOrderStatusColor(order.status)
                                      .withAlpha(24),
                                ),
                                child: Text(
                                  _getOrderStatusText(order.status),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: _getOrderStatusColor(order.status),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${order.items.length} khóa học',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(order.createdAt),
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng cộng:',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (order.canRetry) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<OrderProvider>()
                            .retryCheckout(order.id);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại thanh toán'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
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
        return 'Đang xử lý';
      case 'paid':
      case 'completed':
        return 'Hoàn thành';
      case 'failed':
        return 'Thất bại';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
