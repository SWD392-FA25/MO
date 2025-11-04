import '../../domain/entities/livestream.dart';

class LivestreamModel extends Livestream {
  const LivestreamModel({
    required super.id,
    required super.title,
    required super.description,
    super.thumbnailUrl,
    super.streamUrl,
    required super.instructorName,
    required super.scheduledAt,
    required super.durationMinutes,
    required super.price,
    super.viewerCount,
    required super.status,
    super.createdAt,
  });

  factory LivestreamModel.fromJson(Map<String, dynamic> json) {
    return LivestreamModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? json['imageUrl'] ?? json['thumbnail'],
      streamUrl: json['streamUrl'] ?? json['url'] ?? json['videoUrl'],
      instructorName: json['instructorName'] ?? json['instructor']?['name'] ?? 'Unknown',
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : json['startTime'] != null
              ? DateTime.parse(json['startTime'])
              : DateTime.now(),
      durationMinutes: json['durationMinutes'] ?? json['duration'] ?? 60,
      price: (json['price'] ?? 0).toDouble(),
      viewerCount: json['viewerCount'] ?? json['viewers'],
      status: json['status'] ?? 'upcoming',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'streamUrl': streamUrl,
      'instructorName': instructorName,
      'scheduledAt': scheduledAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'price': price,
      'viewerCount': viewerCount,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  Livestream toEntity() => Livestream(
        id: id,
        title: title,
        description: description,
        thumbnailUrl: thumbnailUrl,
        streamUrl: streamUrl,
        instructorName: instructorName,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        price: price,
        viewerCount: viewerCount,
        status: status,
        createdAt: createdAt,
      );
}
