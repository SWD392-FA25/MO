class Course {
  final String id;
  final String title;
  final String subject;
  final String level;
  final String description;

  const Course({
    required this.id,
    required this.title,
    required this.subject,
    required this.level,
    required this.description,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json['id'] as String,
    title: json['title'] as String,
    subject: json['subject'] as String,
    level: json['level'] as String,
    description: json['description'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'level': level,
    'description': description,
  };
}
