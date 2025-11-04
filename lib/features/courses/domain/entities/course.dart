class Course {
  Course({
    required this.id,
    required this.title,
    required this.category,
    required this.subject,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.students,
    this.isBookmarked = false,
  });

  final String id;
  final String title;
  final String category;
  final String subject;
  final double price;
  final double originalPrice;
  final double rating;
  final int students;
  final bool isBookmarked;
}
