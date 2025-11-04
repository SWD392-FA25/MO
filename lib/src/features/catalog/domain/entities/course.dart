import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final double price;
  final double? rating;
  final int? reviewCount;
  final int? studentCount;
  final String? instructorName;
  final String? category;
  final int? lessonCount;
  final int? duration;
  final String? level;
  final bool isFeatured;
  final bool isPopular;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.price,
    this.rating,
    this.reviewCount,
    this.studentCount,
    this.instructorName,
    this.category,
    this.lessonCount,
    this.duration,
    this.level,
    this.isFeatured = false,
    this.isPopular = false,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        price,
        rating,
        reviewCount,
        studentCount,
        instructorName,
        category,
        lessonCount,
        duration,
        level,
        isFeatured,
        isPopular,
        createdAt,
        updatedAt,
      ];
}
