import '../models/course.dart';
import '../models/course_detail.dart';

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

Course _courseById(String id) =>
    mockCourses.firstWhere((course) => course.id == id);

final Map<String, CourseDetail> mockCourseDetails = {
  'course-1': CourseDetail(
    course: _courseById('course-1'),
    headline: 'Master Visual Storytelling for Modern Brands',
    description:
        'Khóa học tập trung vào việc xây dựng bộ nhận diện thương hiệu thông qua thiết kế đồ họa dựa trên dự án thực tế.',
    instructor: 'Luna Maxwell',
    duration: '12h 30m',
    lessonCount: 48,
    moduleCount: 6,
    language: 'English',
    highlights: [
      'Bài tập thực hành theo dự án với phản hồi chi tiết',
      'Tải về tài nguyên template cho Photoshop, Illustrator',
      'Cập nhật xu hướng thiết kế 2025',
    ],
    curriculum: [
      CurriculumSection(
        title: 'Introduction & Branding Fundamentals',
        lessons: [
          'Welcome & mục tiêu khóa học',
          'Tổng quan về thương hiệu',
          'Case study: Rebranding thành công',
        ],
      ),
      CurriculumSection(
        title: 'Design Systems & Typography',
        lessons: [
          'Thiết lập hệ thống màu',
          'Chọn typography phù hợp',
          'Ứng dụng trong bộ nhận diện',
        ],
      ),
      CurriculumSection(
        title: 'Practical Project',
        lessons: [
          'Phân tích yêu cầu khách hàng',
          'Phát triển moodboard',
          'Trình bày và phản biện',
        ],
      ),
    ],
  ),
  'course-3': CourseDetail(
    course: _courseById('course-3'),
    headline: 'Become a Full Stack Web Developer',
    description:
        'Lộ trình toàn diện từ front-end tới back-end với dự án thực tế và best practices mới nhất.',
    instructor: 'Ethan Barker',
    duration: '18h 05m',
    lessonCount: 72,
    moduleCount: 8,
    language: 'English',
    highlights: [
      'Dự án cuối khóa triển khai thực tế',
      'Hướng dẫn cấu trúc thư mục chuyên nghiệp',
      'Bản cập nhật framework hàng quý',
    ],
    curriculum: [
      CurriculumSection(
        title: 'Modern Front-end Foundations',
        lessons: [
          'Thiết lập môi trường chuyên nghiệp',
          'Responsive layout nâng cao',
          'State management pattern',
        ],
      ),
      CurriculumSection(
        title: 'Back-end & API Integrations',
        lessons: [
          'Thiết kế RESTful API',
          'Bảo mật và xác thực',
          'Triển khai trên cloud',
        ],
      ),
      CurriculumSection(
        title: 'Deployment & Monitoring',
        lessons: [
          'CI/CD pipeline cơ bản',
          'Giám sát hiệu năng',
          'Checklist trước khi go-live',
        ],
      ),
    ],
  ),
};
