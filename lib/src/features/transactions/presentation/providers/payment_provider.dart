import 'package:flutter/foundation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/usecases/get_active_payment_methods.dart';
import '../../domain/usecases/get_payment_methods.dart';

class PaymentProvider extends ChangeNotifier {
  final GetPaymentMethods getPaymentMethodsUseCase;
  final GetActivePaymentMethods getActivePaymentMethodsUseCase;

  PaymentProvider({
    required this.getPaymentMethodsUseCase,
    required this.getActivePaymentMethodsUseCase,
  });

  // State
  List<PaymentMethod> _paymentMethods = [];
  PaymentMethod? _selectedPaymentMethod;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<PaymentMethod> get paymentMethods => _paymentMethods;
  List<PaymentMethod> get activePaymentMethods =>
      _paymentMethods.where((pm) => pm.isActive).toList();
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPaymentMethods => _paymentMethods.isNotEmpty;

  // Load payment methods
  Future<void> loadPaymentMethods({
    bool onlyActive = true,
    bool refresh = false,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _paymentMethods = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = onlyActive
        ? await getActivePaymentMethodsUseCase.call(NoParams())
        : await getPaymentMethodsUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (methods) {
        _paymentMethods = methods;
        
        // Auto-select first method if none selected
        if (_selectedPaymentMethod == null && methods.isNotEmpty) {
          _selectedPaymentMethod = methods.first;
        }
        
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Select payment method
  void selectPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  // Get payment method by ID
  PaymentMethod? getPaymentMethodById(String id) {
    try {
      return _paymentMethods.firstWhere((pm) => pm.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh
  Future<void> refresh() async {
    await loadPaymentMethods(refresh: true);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedPaymentMethod = null;
    notifyListeners();
  }
}
