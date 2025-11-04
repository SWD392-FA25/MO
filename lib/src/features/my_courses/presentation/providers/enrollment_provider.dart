import 'package:flutter/foundation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/enrollment.dart';
import '../../domain/usecases/get_my_enrollments.dart';

class EnrollmentProvider extends ChangeNotifier {
  final GetMyEnrollments getMyEnrollmentsUseCase;

  EnrollmentProvider({required this.getMyEnrollmentsUseCase});

  // State
  List<Enrollment> _enrollments = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Enrollment> get enrollments => _enrollments;
  List<Enrollment> get activeEnrollments =>
      _enrollments.where((e) => e.isActive).toList();
  List<Enrollment> get completedEnrollments =>
      _enrollments.where((e) => e.isCompleted).toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasEnrollments => _enrollments.isNotEmpty;

  // Load enrollments
  Future<void> loadEnrollments({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _enrollments = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getMyEnrollmentsUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (enrollments) {
        _enrollments = enrollments;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Get enrollment by course ID
  Enrollment? getEnrollmentByCourseId(String courseId) {
    try {
      return _enrollments.firstWhere((e) => e.courseId == courseId);
    } catch (e) {
      return null;
    }
  }

  // Check if enrolled in course
  bool isEnrolledInCourse(String courseId) {
    return _enrollments.any((e) => e.courseId == courseId && e.isActive);
  }

  // Refresh
  Future<void> refresh() async {
    await loadEnrollments(refresh: true);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
