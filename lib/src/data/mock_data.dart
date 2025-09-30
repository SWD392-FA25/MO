import '../models/course.dart';
import '../models/quiz.dart';
import '../models/membership.dart';
import '../models/profile.dart';

class MockData {
  static final List<Course> courses = [
    Course(
      id: 'c1',
      title: 'IGCSE Mathematics Foundation',
      subject: 'Math',
      level: 'Core',
      description:
          'Master core mathematics concepts with step-by-step explanations.',
    ),
    Course(
      id: 'c2',
      title: 'IGCSE Physics Essentials',
      subject: 'Physics',
      level: 'Extended',
      description: 'Understand physical principles with visual examples.',
    ),
    Course(
      id: 'c3',
      title: 'IGCSE Chemistry Concepts',
      subject: 'Chemistry',
      level: 'Core',
      description: 'Build a strong foundation in chemistry for IGCSE.',
    ),
  ];

  static final List<QuizQuestion> quiz = [
    QuizQuestion(
      id: 'q1',
      question: 'What is 2 + 2?',
      options: ['3', '4', '5', '6'],
      correctIndex: 1,
    ),
    QuizQuestion(
      id: 'q2',
      question: 'Which is a noble gas?',
      options: ['Oxygen', 'Nitrogen', 'Argon', 'Hydrogen'],
      correctIndex: 2,
    ),
  ];

  static final List<MembershipPlan> plans = const [
    MembershipPlan(
      id: 'free',
      name: 'Free',
      features: ['Limited courses', 'Basic quizzes'],
    ),
    MembershipPlan(
      id: 'standard',
      name: 'Standard',
      features: ['All courses', 'Practice sets'],
    ),
    MembershipPlan(
      id: 'premium',
      name: 'Premium',
      features: ['Mock tests', 'Progress insights'],
    ),
  ];

  static final Profile profile = const Profile(
    name: 'IGCSE Learner',
    enrolledCourses: 2,
    membership: 'Free',
  );
}
