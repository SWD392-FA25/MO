import 'package:flutter/foundation.dart';

import '../../domain/entities/order.dart';
import '../../domain/usecases/checkout_order.dart';
import '../../domain/usecases/get_order_by_id.dart';
import '../../domain/usecases/get_my_orders.dart';
import '../../domain/usecases/retry_checkout.dart';

class OrderProvider extends ChangeNotifier {
  final GetMyOrders getMyOrdersUseCase;
  final GetOrderById getOrderByIdUseCase;
  final CheckoutOrder checkoutOrderUseCase;
  final RetryCheckout retryCheckoutUseCase;

  OrderProvider({
    required this.getMyOrdersUseCase,
    required this.getOrderByIdUseCase,
    required this.checkoutOrderUseCase,
    required this.retryCheckoutUseCase,
  });

  // State
  List<Order> _orders = [];
  Order? _selectedOrder;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Order> get orders => List.unmodifiable(_orders);
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get all orders
  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getMyOrdersUseCase.call();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (orders) {
        _orders = orders;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Get order by ID
  Future<void> loadOrderById(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getOrderByIdUseCase.call(orderId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (order) {
        _selectedOrder = order;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Checkout order
  Future<bool> checkoutOrder(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await checkoutOrderUseCase.call(orderId);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (order) {
        // Update order in the list
        final index = _orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          _orders[index] = order;
        }
        _selectedOrder = order;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Retry checkout
  Future<bool> retryCheckout(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await retryCheckoutUseCase.call(orderId);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (order) {
        // Update order in the list
        final index = _orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          _orders[index] = order;
        }
        _selectedOrder = order;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear selected order
  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }

  // Get orders by status
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => 
        order.status.toLowerCase() == status.toLowerCase()).toList();
  }

  // Get pending orders
  List<Order> get pendingOrders => getOrdersByStatus('pending');

  // Get completed orders
  List<Order> get completedOrders => getOrdersByStatus('paid');

  // Get failed orders
  List<Order> get failedOrders => getOrdersByStatus('failed');
}
