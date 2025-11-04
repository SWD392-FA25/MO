import 'package:equatable/equatable.dart';

class Livestream extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String? streamUrl;
  final String instructorName;
  final DateTime scheduledAt;
  final int durationMinutes;
  final double price;
  final int? viewerCount;
  final String status;
  final DateTime? createdAt;

  const Livestream({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    this.streamUrl,
    required this.instructorName,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.price,
    this.viewerCount,
    required this.status,
    this.createdAt,
  });

  bool get isLive => status == 'live' || status == 'Live';
  bool get isUpcoming => status == 'upcoming' || status == 'Upcoming';
  bool get isEnded => status == 'ended' || status == 'Ended';

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnailUrl,
        streamUrl,
        instructorName,
        scheduledAt,
        durationMinutes,
        price,
        viewerCount,
        status,
        createdAt,
      ];
}
