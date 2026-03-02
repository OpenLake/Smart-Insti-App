class Feedback {
  final String id;
  final String type; // 'Complaint', 'Feedback', 'Suggestion', etc.
  final String? targetId;
  final String targetType; // 'User', 'Event', 'Club/Organization', 'POR', etc.
  final String feedbackBy;
  final String? feedbackByName;
  final double rating;
  final String comments;
  final bool isAnonymous;
  final bool isResolved;
  final DateTime? resolvedAt;
  final String? actionsTaken;
  final String? resolvedBy;
  final Map<String, dynamic>? targetData;
  final DateTime createdAt;

  Feedback({
    required this.id,
    required this.type,
    this.targetId,
    required this.targetType,
    required this.feedbackBy,
    this.feedbackByName,
    required this.rating,
    required this.comments,
    required this.isAnonymous,
    this.isResolved = false,
    this.resolvedAt,
    this.actionsTaken,
    this.resolvedBy,
    this.targetData,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    String name = '';
    if (json['feedback_by'] is Map) {
      name = json['feedback_by']['personal_info']?['name'] ??
          json['feedback_by']['username'] ??
          '';
    }

    return Feedback(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'] ?? 'Feedback',
      targetId: json['target_id'],
      targetType: json['target_type'] ?? 'General',
      feedbackBy: json['feedback_by'] is Map
          ? json['feedback_by']['_id'] ?? ''
          : json['feedback_by'] ?? '',
      feedbackByName: name.isNotEmpty ? name : null,
      rating: (json['rating'] ?? 0).toDouble(),
      comments: json['comments'] ?? '',
      isAnonymous: json['is_anonymous'] ?? false,
      isResolved: json['is_resolved'] ?? false,
      resolvedAt: DateTime.tryParse(json['resolved_at'] ?? ''),
      actionsTaken: json['actions_taken'],
      resolvedBy: json['resolved_by'] is Map
          ? json['resolved_by']['_id']
          : json['resolved_by'],
      targetData: json['target_data'],
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ??
              DateTime.now(),
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
