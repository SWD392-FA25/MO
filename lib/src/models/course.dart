class Course {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String thumbnailUrl;
  final String category;
  final String instructor;
  final double rating;
  final int reviewCount;
  final int studentCount;
  final double price;
  final String duration;
  final int lessonCount;
  final String level;
  final List<String> tags;
  final bool isFeatured;
  final bool isPopular;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Additional fields for compatibility
  final String? subject;
  final double? originalPrice;
  final int? students;
  final bool isBookmarked;

  const Course({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.thumbnailUrl,
    required this.category,
    required this.instructor,
    required this.rating,
    required this.reviewCount,
    required this.studentCount,
    required this.price,
    required this.duration,
    required this.lessonCount,
    required this.level,
    required this.tags,
    this.isFeatured = false,
    this.isPopular = false,
    required this.createdAt,
    this.updatedAt,
    this.subject,
    this.originalPrice,
    this.students,
    this.isBookmarked = false,
  });

  Course copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? thumbnailUrl,
    String? category,
    String? instructor,
    double? rating,
    int? reviewCount,
    int? studentCount,
    double? price,
    String? duration,
    int? lessonCount,
    String? level,
    List<String>? tags,
    bool? isFeatured,
    bool? isPopular,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      instructor: instructor ?? this.instructor,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      studentCount: studentCount ?? this.studentCount,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      lessonCount: lessonCount ?? this.lessonCount,
      level: level ?? this.level,
      tags: tags ?? this.tags,
      isFeatured: isFeatured ?? this.isFeatured,
      isPopular: isPopular ?? this.isPopular,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
