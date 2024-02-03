class LostAndFoundItem {
  String userId;
  String name;
  String lastSeenLocation;
  String imagePath;
  String description;
  String contactNumber;
  bool isLost;

  LostAndFoundItem({
    required this.userId,
    required this.name,
    required this.lastSeenLocation,
    required this.imagePath,
    required this.description,
    required this.contactNumber,
    required this.isLost,
  });

  factory LostAndFoundItem.fromJson(Map<String, dynamic> json) {
    return LostAndFoundItem(
      userId: json['user_id'],
      name: json['name'],
      lastSeenLocation: json['lastSeenLocation'],
      imagePath: json['imagePath'],
      description: json['description'],
      contactNumber: json['contactNumber'],
      isLost: json['isLost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'lastSeenLocation': lastSeenLocation,
      'imagePath': imagePath,
      'description': description,
      'contactNumber': contactNumber,
      'isLost': isLost,
    };
  }
}
