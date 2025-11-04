import 'package:equatable/equatable.dart';

import 'course.dart';

class Package extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double price;
  final double? originalPrice;
  final List<Course>? courses;
  final List<String>? courseIds;
  final int? courseCount;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  const Package({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.price,
    this.originalPrice,
    this.courses,
    this.courseIds,
    this.courseCount,
    this.isActive = true,
    this.createdAt,
    this.expiresAt,
  });

  double? get discount {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice!) * 100;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        price,
        originalPrice,
        courses,
        courseIds,
        courseCount,
        isActive,
        createdAt,
        expiresAt,
      ];
}
