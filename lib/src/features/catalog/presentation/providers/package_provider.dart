import 'package:flutter/foundation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/package.dart';
import '../../domain/usecases/get_package_detail.dart';
import '../../domain/usecases/get_packages.dart';

class PackageProvider extends ChangeNotifier {
  final GetPackages getPackagesUseCase;
  final GetPackageDetail getPackageDetailUseCase;

  PackageProvider({
    required this.getPackagesUseCase,
    required this.getPackageDetailUseCase,
  });

  // State
  List<Package> _packages = [];
  Package? _selectedPackage;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Package> get packages => _packages;
  Package? get selectedPackage => _selectedPackage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPackages => _packages.isNotEmpty;

  // Load packages
  Future<void> loadPackages({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _packages = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getPackagesUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (packages) {
        _packages = packages;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load package detail
  Future<void> loadPackageDetail(String packageId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getPackageDetailUseCase.call(packageId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (package) {
        _selectedPackage = package;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Refresh
  Future<void> refresh() async {
    await loadPackages(refresh: true);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear selected
  void clearSelected() {
    _selectedPackage = null;
    notifyListeners();
  }
}
