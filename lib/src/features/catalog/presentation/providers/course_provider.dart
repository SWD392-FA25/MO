import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/course_lesson.dart';
import '../../domain/usecases/get_course_detail.dart';
import '../../domain/usecases/get_courses.dart';
import '../../domain/usecases/get_course_lessons.dart';

class CourseProvider extends ChangeNotifier {
  final GetCourses getCoursesUseCase;
  final GetCourseDetail getCourseDetailUseCase;
  final GetCourseLessons getCourseLessonsUseCase;
  final GetLessonDetail getLessonDetailUseCase;

  CourseProvider({
    required this.getCoursesUseCase,
    required this.getCourseDetailUseCase,
    required this.getCourseLessonsUseCase,
    required this.getLessonDetailUseCase,
  });

  // State
  List<Course> _courses = [];
  Course? _selectedCourse;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;

  // Lessons state
  List<CourseLesson> _courseLessons = [];
  CourseLesson? _selectedLesson;
  bool _isLessonsLoading = false;
  String? _lessonsErrorMessage;

  // Getters
  List<Course> get courses => _courses;
  Course? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  List<CourseLesson> get courseLessons => _courseLessons;
  CourseLesson? get selectedLesson => _selectedLesson;
  bool get isLessonsLoading => _isLessonsLoading;
  String? get lessonsErrorMessage => _lessonsErrorMessage;

  // Load courses
  Future<void> loadCourses({
    String? q,
    bool refresh = false,
    int pageSize = 20,
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
        q: q,
        page: _currentPage,
        pageSize: pageSize,
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

  // Load course lessons
  Future<void> loadCourseLessons(String courseId) async {
    if (_isLessonsLoading) return;

    _isLessonsLoading = true;
    _lessonsErrorMessage = null;
    notifyListeners();

    final result = await getCourseLessonsUseCase.call(courseId);

    result.fold(
      (failure) {
        _lessonsErrorMessage = failure.message;
        _isLessonsLoading = false;
        notifyListeners();
      },
      (lessons) {
        _courseLessons = lessons;
        _isLessonsLoading = false;
        notifyListeners();
      },
    );
  }

  // Search courses
  Future<void> searchCourses(String query) async {
    await loadCourses(q: query, refresh: true);
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

  // Load lesson detail
  Future<void> loadLessonDetail(String courseId, String lessonId) async {
    if (_isLessonsLoading) return;

    _isLessonsLoading = true;
    _lessonsErrorMessage = null;
    notifyListeners();

    final result = await getLessonDetailUseCase.call(
      GetLessonDetailParams(courseId: courseId, lessonId: lessonId),
    );

    result.fold(
      (failure) {
        _lessonsErrorMessage = failure.message;
        _isLessonsLoading = false;
        notifyListeners();
      },
      (lesson) {
        _selectedLesson = lesson;
        _isLessonsLoading = false;
        notifyListeners();
      },
    );
  }

  // Get lesson detail result
  Future<Either<Failure, CourseLesson>> getLessonDetail(
    String courseId,
    String lessonId,
  ) async {
    return await getLessonDetailUseCase.call(
      GetLessonDetailParams(courseId: courseId, lessonId: lessonId),
    );
  }

  // Clear lessons error
  void clearLessonsError() {
    _lessonsErrorMessage = null;
    notifyListeners();
  }
}
