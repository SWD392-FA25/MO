import '../../domain/entities/package.dart';
import 'course_model.dart';

class PackageModel extends Package {
  const PackageModel({
    required super.id,
    required super.name,
    required super.description,
    super.imageUrl,
    required super.price,
    super.originalPrice,
    super.courses,
    super.courseIds,
    super.courseCount,
    super.isActive,
    super.createdAt,
    super.expiresAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    List<String>? courseIds;
    if (json['courseIds'] != null) {
      courseIds = (json['courseIds'] as List).map((e) => e.toString()).toList();
    }

    List<CourseModel>? courses;
    if (json['courses'] != null) {
      courses = (json['courses'] as List)
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return PackageModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? json['thumbnailUrl'],
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice'] != null 
          ? (json['originalPrice'] as num).toDouble() 
          : null,
      courses: courses?.map((c) => c.toEntity()).toList(),
      courseIds: courseIds,
      courseCount: json['courseCount'] ?? json['totalCourses'] ?? courses?.length,
      isActive: json['isActive'] ?? json['active'] ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'courseIds': courseIds,
      'courseCount': courseCount,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  Package toEntity() => Package(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
        price: price,
        originalPrice: originalPrice,
        courses: courses,
        courseIds: courseIds,
        courseCount: courseCount,
        isActive: isActive,
        createdAt: createdAt,
        expiresAt: expiresAt,
      );
}
