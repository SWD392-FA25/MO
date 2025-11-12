import 'package:flutter/foundation.dart';

import '../../domain/entities/assignment.dart';
import '../../domain/usecases/submit_assignment.dart';
import '../../domain/usecases/get_assignment_submissions.dart';

class AssignmentProvider extends ChangeNotifier {
  final SubmitAssignment submitAssignmentUseCase;
  final GetAssignmentSubmissions getAssignmentSubmissionsUseCase;

  AssignmentProvider({
    required this.submitAssignmentUseCase,
    required this.getAssignmentSubmissionsUseCase,
  });

  // State
  AssignmentSubmission? _lastSubmission;
  List<AssignmentSubmission> _submissions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  AssignmentSubmission? get lastSubmission => _lastSubmission;
  List<AssignmentSubmission> get submissions => List.unmodifiable(_submissions);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Submit assignment
  Future<bool> submitAssignment({
    required String assignmentId,
    required String content,
    String? fileUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await submitAssignmentUseCase.call(
      SubmitAssignmentParams(
        assignmentId: assignmentId,
        content: content,
        fileUrl: fileUrl,
      ),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (submission) {
        _lastSubmission = submission;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Load submissions
  Future<void> loadSubmissions(String assignmentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getAssignmentSubmissionsUseCase.call(assignmentId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (submissions) {
        _submissions = submissions;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
