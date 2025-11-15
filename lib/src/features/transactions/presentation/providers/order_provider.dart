import 'package:flutter/foundation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/checkout_order.dart';
import '../../domain/usecases/create_order.dart';
import '../../domain/usecases/get_my_orders.dart';
import '../../domain/usecases/cash_payment.dart';
import '../../domain/usecases/enroll_sync.dart';

class OrderProvider extends ChangeNotifier {
  final CreateOrder createOrderUseCase;
  final GetMyOrders getMyOrdersUseCase;
  final CheckoutOrder checkoutOrderUseCase;
  final CashPayment cashPaymentUseCase;
  final EnrollSync enrollSyncUseCase;
  final OrderRepository repository;

  OrderProvider({
    required this.createOrderUseCase,
    required this.getMyOrdersUseCase,
    required this.checkoutOrderUseCase,
    required this.cashPaymentUseCase,
    required this.enrollSyncUseCase,
    required this.repository,
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
  OrderEntity? get selectedOrder => _currentOrder; // Alias for compatibility
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

  // Get order by ID (sync)
  OrderEntity? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Load order by ID (async - for detail page)
  Future<void> loadOrderById(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.getOrderById(orderId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (order) {
        _currentOrder = order;
        // Also update in orders list if exists
        final index = _orders.indexWhere((o) => o.id == orderId);
        if (index != -1) {
          _orders[index] = order;
        } else {
          _orders.insert(0, order);
        }
        _isLoading = false;
        notifyListeners();
      },
    );
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

  // Cash payment
  Future<bool> processCashPayment(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🔍 processCashPayment called with orderId: "$orderId" (length: ${orderId.length})');
      
      final result = await cashPaymentUseCase(CashPaymentParams(orderId: orderId));

      return result.fold(
        (failure) {
          print('❌ Cash payment failure: ${failure.message}');
          _errorMessage = failure.message;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (_) {
          print('✅ Cash payment success');
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception in processCashPayment: $e');
      print('Stack trace: $stackTrace');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Enroll sync
  Future<bool> syncEnrollment(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await enrollSyncUseCase(EnrollSyncParams(orderId: orderId));

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Complete cash payment flow (create order + cash payment + enroll sync)
  Future<bool> completeCashPaymentFlow(String courseId) async {
    try {
      print('🔵 Starting cash payment flow for courseId: $courseId');
      
      // Step 1: Create order
      final order = await createOrder([
        OrderItemRequest(
          courseId: courseId,
          quantity: 1,
        ),
      ]);

      if (order == null || _errorMessage != null) {
        print('❌ Failed to create order: $_errorMessage');
        return false;
      }

      print('✅ Order created successfully: ${order.id}');

      // Step 2: Process cash payment
      print('🔵 Processing cash payment for order: ${order.id}');
      final paymentSuccess = await processCashPayment(order.id);
      if (!paymentSuccess) {
        print('❌ Cash payment failed: $_errorMessage');
        return false;
      }

      print('✅ Cash payment processed successfully');

      // Step 3: Sync enrollment
      print('🔵 Syncing enrollment for order: ${order.id}');
      final enrollSuccess = await syncEnrollment(order.id);
      
      if (enrollSuccess) {
        print('✅ Enrollment synced successfully');
      } else {
        print('❌ Enrollment sync failed: $_errorMessage');
      }
      
      return enrollSuccess;
    } catch (e) {
      print('❌ Exception in cash payment flow: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
