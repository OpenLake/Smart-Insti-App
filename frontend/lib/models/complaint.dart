class Complaint {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String createdBy;
  final String? createdByName;
  final List<String> upvotes;
  final String? imageURI;
  final Map<String, dynamic>? resolvedBy;
  final String? resolutionNote;
  final DateTime createdAt;


  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdBy,
    this.createdByName,
    required this.upvotes,
    this.imageURI,
    this.resolvedBy,
    this.resolutionNote,
    required this.createdAt,

  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      status: json['status'],
      createdBy: json['createdBy'],
      createdByName: json['createdByName'],
      upvotes: (json['upvotes'] as List).map((e) => e.toString()).toList(),
      imageURI: json['imageURI'],
      resolvedBy: json['resolvedBy'],
      resolutionNote: json['resolutionNote'],
      createdAt: DateTime.parse(json['createdAt']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'imageURI': imageURI,
    };
  }
}
