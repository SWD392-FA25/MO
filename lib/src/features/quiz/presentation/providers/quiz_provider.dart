import 'package:flutter/foundation.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/usecases/create_quiz_attempt.dart';
import '../../domain/usecases/get_my_quiz_attempts.dart';
import '../../domain/usecases/get_quiz_for_take.dart';
import '../../domain/usecases/submit_quiz_attempt.dart';
import '../../domain/usecases/get_quizzes.dart';
import '../../domain/usecases/get_quiz_by_id.dart';
import '../../domain/usecases/get_student_assignments.dart';

class QuizProvider extends ChangeNotifier {
  final GetQuizForTake getQuizForTakeUseCase;
  final CreateQuizAttempt createQuizAttemptUseCase;
  final SubmitQuizAttempt submitQuizAttemptUseCase;
  final GetMyQuizAttempts getMyQuizAttemptsUseCase;
  final GetQuizzes getQuizzesUseCase;
  final GetQuizById getQuizByIdUseCase;
  final GetStudentAssignments getStudentAssignmentsUseCase;

  QuizProvider({
    required this.getQuizForTakeUseCase,
    required this.createQuizAttemptUseCase,
    required this.submitQuizAttemptUseCase,
    required this.getMyQuizAttemptsUseCase,
    required this.getQuizzesUseCase,
    required this.getQuizByIdUseCase,
    required this.getStudentAssignmentsUseCase,
  });

  // State
  List<Quiz> _quizzes = [];
  Quiz? _currentQuiz;
  Quiz? _selectedQuiz;
  QuizAttempt? _currentAttempt;
  List<QuizAttempt> _attempts = [];
  List<Quiz> _assignments = [];
  Map<String, String> _answers = {};
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Quiz> get quizzes => _quizzes;
  Quiz? get currentQuiz => _currentQuiz;
  Quiz? get selectedQuiz => _selectedQuiz;
  QuizAttempt? get currentAttempt => _currentAttempt;
  List<QuizAttempt> get attempts => _attempts;
  List<Quiz> get assignments => _assignments;
  Map<String, String> get answers => _answers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasAnswers => _answers.isNotEmpty;

  // Load quiz for taking
  Future<void> loadQuiz(String quizId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getQuizForTakeUseCase.call(quizId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (quiz) {
        _currentQuiz = quiz;
        _answers = {};
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Create quiz attempt
  Future<QuizAttempt?> startQuiz(String quizId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await createQuizAttemptUseCase.call(quizId);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (attempt) {
        _currentAttempt = attempt;
        _isLoading = false;
        notifyListeners();
        return attempt;
      },
    );
  }

  // Set answer for question
  void setAnswer(String questionId, String answer) {
    _answers[questionId] = answer;
    notifyListeners();
  }

  // Submit quiz
  Future<QuizAttempt?> submitQuiz(String quizId, String attemptId) async {
    if (_answers.isEmpty) {
      _errorMessage = 'Please answer at least one question';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await submitQuizAttemptUseCase.call(
      SubmitQuizParams(
        quizId: quizId,
        attemptId: attemptId,
        answers: _answers,
      ),
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return null;
      },
      (attempt) {
        _currentAttempt = attempt;
        _attempts.insert(0, attempt);
        _isLoading = false;
        notifyListeners();
        return attempt;
      },
    );
  }

  // Load my attempts
  Future<void> loadMyAttempts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getMyQuizAttemptsUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (attempts) {
        _attempts = attempts;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load all quizzes
  Future<void> loadQuizzes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getQuizzesUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (quizzes) {
        _quizzes = quizzes;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load quiz by ID
  Future<void> loadQuizById(String quizId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getQuizByIdUseCase.call(quizId);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (quiz) {
        _selectedQuiz = quiz;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Load student assignments
  Future<void> loadStudentAssignments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getStudentAssignmentsUseCase.call(NoParams());

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (assignments) {
        _assignments = assignments;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Clear quiz
  void clearQuiz() {
    _currentQuiz = null;
    _currentAttempt = null;
    _answers = {};
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
