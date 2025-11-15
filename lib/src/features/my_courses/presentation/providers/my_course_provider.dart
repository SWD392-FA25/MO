import 'package:flutter/foundation.dart';

import '../../../catalog/domain/entities/lesson.dart';
import '../../domain/entities/course_progress.dart';
import '../../domain/usecases/complete_lesson.dart';
import '../../domain/usecases/get_course_progress.dart';
import '../../domain/usecases/get_my_course_lessons.dart';
import '../../domain/usecases/get_my_course_detail.dart';

class MyCourseProvider extends ChangeNotifier {
  final GetMyCourseLessons getMyCourseLessonsUseCase;
  final CompleteLesson completeLessonUseCase;
  final GetCourseProgress getCourseProgressUseCase;
  final GetMyCourseDetail getMyCourseDetailUseCase;

  MyCourseProvider({
    required this.getMyCourseLessonsUseCase,
    required this.completeLessonUseCase,
    required this.getCourseProgressUseCase,
    required this.getMyCourseDetailUseCase,
  });

  // State
  Map<String, List<Lesson>> _courseLessons = {};
  Map<String, CourseProgress> _courseProgress = {};
  Map<String, Map<String, dynamic>> _courseDetails = {};
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentCourseId;

  // Getters
  List<Lesson> getLessons(String courseId) => _courseLessons[courseId] ?? [];
  CourseProgress? getProgress(String courseId) => _courseProgress[courseId];
  Map<String, dynamic>? getCourse(String courseId) => _courseDetails[courseId];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentCourseId => _currentCourseId;

  // Load course lessons
  Future<void> loadCourseLessons(String courseId) async {
    _isLoading = true;
    _errorMessage = null;
    _currentCourseId = courseId;
    notifyListeners();

    final result = await getMyCourseLessonsUseCase.call(courseId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (lessons) {
        _courseLessons[courseId] = lessons;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load my course detail
  Future<void> loadMyCourseDetail(String courseId) async {
    final result = await getMyCourseDetailUseCase.call(courseId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (courseDetail) {
        _courseDetails[courseId] = courseDetail;
        notifyListeners();
      },
    );
  }

  // Load course progress
  Future<void> loadCourseProgress(String courseId) async {
    final result = await getCourseProgressUseCase.call(courseId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
      },
      (progress) {
        _courseProgress[courseId] = progress;
        notifyListeners();
      },
    );
  }

  // Complete a lesson
  Future<bool> completeLesson(String courseId, String lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await completeLessonUseCase.call(
      CompleteLessonParams(courseId: courseId, lessonId: lessonId),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) async {
        // Reload lessons to get updated completion status
        await loadCourseLessons(courseId);
        
        // Reload progress
        await loadCourseProgress(courseId);

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

  // Clear course data
  void clearCourseData(String courseId) {
    _courseLessons.remove(courseId);
    _courseProgress.remove(courseId);
    _courseDetails.remove(courseId);
    notifyListeners();
  }

  // Load course detail
  Future<void> loadCourseDetail(String courseId) async {
    _isLoading = true;
    _errorMessage = null;
    _currentCourseId = courseId;
    notifyListeners();

    final result = await getMyCourseDetailUseCase.call(courseId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (courseDetail) {
        _courseDetails[courseId] = courseDetail;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Get course detail
  Map<String, dynamic>? getCourseDetail(String courseId) {
    return _courseDetails[courseId];
  }
}
