import 'package:flutter/foundation.dart';

import '../../domain/entities/course.dart';
import '../../domain/usecases/get_course_detail.dart';
import '../../domain/usecases/get_courses.dart';

class CourseProvider extends ChangeNotifier {
  final GetCourses getCoursesUseCase;
  final GetCourseDetail getCourseDetailUseCase;

  CourseProvider({
    required this.getCoursesUseCase,
    required this.getCourseDetailUseCase,
  });

  // State
  List<Course> _courses = [];
  Course? _selectedCourse;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  // Getters
  List<Course> get courses => _courses;
  Course? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;

  // Load courses
  Future<void> loadCourses({
    String? category,
    String? search,
    bool refresh = false,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _courses = [];
      _hasMore = true;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getCoursesUseCase.call(
      GetCoursesParams(
        category: category,
        search: search,
        page: _currentPage,
        pageSize: 20,
      ),
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (newCourses) {
        if (newCourses.isEmpty) {
          _hasMore = false;
        } else {
          _courses.addAll(newCourses);
          _currentPage++;
        }
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load course detail
  Future<void> loadCourseDetail(String courseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getCourseDetailUseCase.call(courseId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (course) {
        _selectedCourse = course;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Search courses
  Future<void> searchCourses(String query) async {
    await loadCourses(search: query, refresh: true);
  }

  // Filter by category
  Future<void> filterByCategory(String category) async {
    await loadCourses(category: category, refresh: true);
  }

  // Refresh
  Future<void> refresh() async {
    await loadCourses(refresh: true);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
