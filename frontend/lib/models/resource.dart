class Resource {
  final String id;
  final String title;
  final String description;
  final String subject;
  final int semester;
  final String department;
  final String type;
  final String fileUrl;
  final String publicId;
  final Map<String, dynamic> uploadedBy;
  final DateTime createdAt;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.semester,
    required this.department,
    required this.type,
    required this.fileUrl,
    required this.publicId,
    required this.uploadedBy,
    required this.createdAt,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['_id'],
      title: json['title'],
      description: json['description'] ?? '',
      subject: json['subject'],
      semester: json['semester'],
      department: json['department'],
      type: json['type'],
      fileUrl: json['fileUrl'],
      publicId: json['publicId'] ?? '',
      uploadedBy: json['uploadedBy'] is Map ? json['uploadedBy'] : {'name': 'Unknown'},
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
