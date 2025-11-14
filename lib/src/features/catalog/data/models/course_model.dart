import '../../domain/entities/course.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.title,
    required super.description,
    super.imageUrl,
    required super.price,
    super.rating,
    super.reviewCount,
    super.studentCount,
    super.instructorName,
    super.category,
    super.subjectGroup,
    super.lessonCount,
    super.duration,
    super.level,
    super.isFeatured,
    super.isPopular,
    super.createdAt,
    super.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? json['thumbnailUrl'] ?? json['image'],
      price: (json['price'] ?? 0).toDouble(),
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['reviewCount'] ?? json['totalReviews'],
      studentCount: json['studentCount'] ?? json['enrollmentCount'] ?? json['totalStudents'],
      instructorName: json['instructorName'] ?? json['instructor']?['name'],
      category: json['category'] ?? json['categoryName'],
      subjectGroup: json['subjectGroup'],
      lessonCount: json['lessonCount'] ?? json['totalLessons'],
      duration: json['duration'] ?? json['totalDuration'],
      level: json['level'] ?? json['difficultyLevel'],
      isFeatured: json['isFeatured'] ?? false,
      isPopular: json['isPopular'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'studentCount': studentCount,
      'instructorName': instructorName,
      'category': category,
      'lessonCount': lessonCount,
      'duration': duration,
      'level': level,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Course toEntity() => Course(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        price: price,
        rating: rating,
        reviewCount: reviewCount,
        studentCount: studentCount,
        instructorName: instructorName,
        category: category,
        lessonCount: lessonCount,
        duration: duration,
        level: level,
        isFeatured: isFeatured,
        isPopular: isPopular,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
