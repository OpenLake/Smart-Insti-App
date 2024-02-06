// This class is used to create an object of Lost and Found item

class LostAndFoundItem {
  String? id;
  String name;
  String lastSeenLocation;
  String? imagePath;
  String description;
  String contactNumber;
  bool isLost;

  LostAndFoundItem({
    this.id,
    required this.name,
    required this.lastSeenLocation,
    this.imagePath,
    required this.description,
    required this.isLost,
    required this.contactNumber,
  });

  factory LostAndFoundItem.fromJson(Map<String, dynamic> json) {
    return LostAndFoundItem(
      id: json['_id'],
      name: json['name'],
      lastSeenLocation: json['lastSeenLocation'],
      imagePath: json['imagePath'],
      description: json['description'],
      isLost: json['isLost'],
      contactNumber: json['contactNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastSeenLocation': lastSeenLocation,
      'imagePath': imagePath,
      'description': description,
      'isLost': isLost,
      'contact': contactNumber,
    };
  }
}
