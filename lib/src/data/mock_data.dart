import '../models/course.dart';

const List<String> categoryFilters = [
  'All',
  'Creative Arts',
  'Sciences',
  'Business',
  'Technology',
];

const List<Map<String, String>> homeCategories = [
  {'label': 'Sciences'},
  {'label': 'Technology & Computing'},
  {'label': 'Creative Arts'},
];

const List<Map<String, String>> categoryGridItems = [
  {'title': 'Mathematics', 'icon': 'math'},
  {'title': 'Sciences', 'icon': 'science'},
  {'title': 'Technology & Computing', 'icon': 'tech'},
  {'title': 'Languages', 'icon': 'language'},
  {'title': 'Physical Education & Wellbeing', 'icon': 'pe'},
  {'title': 'Creative Arts', 'icon': 'art'},
  {'title': 'Humanities & Social Sciences', 'icon': 'humanities'},
  {'title': 'Business & Economics', 'icon': 'business'},
];

final List<Course> mockCourses = [
  Course(
    id: 'course-1',
    title: 'Graphic Design Advanced',
    category: 'Creative Arts',
    subject: 'Creative Arts',
    price: 28,
    originalPrice: 42,
    rating: 4.2,
    students: 7830,
    isBookmarked: true,
  ),
  Course(
    id: 'course-2',
    title: 'Advertisement Design',
    category: 'Creative Arts',
    subject: 'Creative Arts',
    price: 42,
    originalPrice: 61,
    rating: 3.9,
    students: 12680,
  ),
  Course(
    id: 'course-3',
    title: 'Web Developer Concepts',
    category: 'Technology & Computing',
    subject: 'Technology & Computing',
    price: 56,
    originalPrice: 71,
    rating: 4.9,
    students: 14580,
  ),
  Course(
    id: 'course-4',
    title: 'Advance Diploma in Graphic Design',
    category: 'Creative Arts',
    subject: 'Creative Arts',
    price: 39,
    originalPrice: 46,
    rating: 4,
    students: 12680,
  ),
  Course(
    id: 'course-5',
    title: 'Digital Marketing Crash Course',
    category: 'Business & Economics',
    subject: 'Business & Economics',
    price: 33,
    originalPrice: 51,
    rating: 4.3,
    students: 8860,
  ),
];
