class Feedback {
  final String id;
  final String type; // 'Complaint' or 'Feedback'
  final String? targetId;
  final String targetType; // 'Mess', 'Hostel', 'Event', 'General', etc.
  final String feedbackBy;
  final double rating;
  final String comments;
  final bool isAnonymous;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.type,
    this.targetId,
    required this.targetType,
    required this.feedbackBy,
    required this.rating,
    required this.comments,
    required this.isAnonymous,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'Feedback',
      targetId: json['target_id'],
      targetType: json['target_type'] ?? 'General',
      feedbackBy: json['feedback_by'] is Map ? json['feedback_by']['_id'] ?? '' : json['feedback_by'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comments: json['comments'] ?? '',
      isAnonymous: json['is_anonymous'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'target_id': targetId,
      'target_type': targetType,
      'rating': rating,
      'comments': comments,
      'is_anonymous': isAnonymous,
    };
  }
}
