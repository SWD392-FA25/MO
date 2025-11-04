import 'package:flutter/foundation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/checkout_order.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/get_my_orders.dart';

class OrderProvider extends ChangeNotifier {
  final CreateOrder createOrderUseCase;
  final GetMyOrders getMyOrdersUseCase;
  final CheckoutOrder checkoutOrderUseCase;

  OrderProvider({
    required this.createOrderUseCase,
    required this.getMyOrdersUseCase,
    required this.checkoutOrderUseCase,
  });

  // State
  List<OrderEntity> _orders = [];
  OrderEntity? _currentOrder;
  bool _isLoading = false;
  String? _errorMessage;
  String? _checkoutUrl;

  // Getters
  List<OrderEntity> get orders => _orders;
  List<OrderEntity> get pendingOrders =>
      _orders.where((o) => o.isPending).toList();
  List<OrderEntity> get paidOrders => _orders.where((o) => o.isPaid).toList();
  OrderEntity? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get checkoutUrl => _checkoutUrl;

  // Create order
  Future<OrderEntity?> createOrder(List<OrderItemRequest> items) async {
    _isLoading = true;
    _errorMessage = null;
    _checkoutUrl = null;
    notifyListeners();

    final result = await createOrderUseCase.call(CreateOrderParams(items: items));

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (order) {
        _currentOrder = order;
        _orders.insert(0, order);
        _isLoading = false;
        notifyListeners();
        return order;
      },
    );
  }

  // Load orders
  Future<void> loadOrders({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _orders = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getMyOrdersUseCase.call(NoParams());

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

  // Checkout order
  Future<String?> checkoutOrder(String orderId, String paymentMethod) async {
    _isLoading = true;
    _errorMessage = null;
    _checkoutUrl = null;
    notifyListeners();

    final result = await checkoutOrderUseCase.call(
      CheckoutOrderParams(orderId: orderId, paymentMethod: paymentMethod),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (url) {
        _checkoutUrl = url;
        _isLoading = false;
        notifyListeners();
        return url;
      },
    );
  }

  // Get order by ID
  OrderEntity? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Refresh
  Future<void> refresh() async {
    await loadOrders(refresh: true);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear current order
  void clearCurrentOrder() {
    _currentOrder = null;
    _checkoutUrl = null;
    notifyListeners();
  }
}
