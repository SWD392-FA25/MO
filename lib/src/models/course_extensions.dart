import 'package:igcse_learning_hub/src/features/catalog/domain/entities/course.dart'
    as api;
import 'package:igcse_learning_hub/src/models/course.dart' as ui;

extension CourseEntityToUI on api.Course {
  ui.Course toUIModel() {
    return ui.Course(
      id: id,
      title: title,
      category: category ?? level ?? 'General',
      subject: category ?? level ?? 'General',
      price: price,
      originalPrice: price * 1.5, // Fake original price for discount display
      rating: rating ?? 4.0,
      students: studentCount ?? 0,
      isBookmarked: false,
    );
  }
}

extension CourseListToUI on List<api.Course> {
  List<ui.Course> toUIModels() {
    return map((course) => course.toUIModel()).toList();
  }
}
