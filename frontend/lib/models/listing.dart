class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String condition;
  final List<String> images;
  final String sellerId;
  final String sellerName;
  final String sellerImage;
  final String status;
  final DateTime createdAt;
  final int views;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.images,
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.status,
    required this.createdAt,
    this.views = 0,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      condition: json['condition'],
      images: List<String>.from(json['images'] ?? []),
      sellerId: json['seller']['_id'],
      sellerName: json['seller']['name'] ?? 'Unknown',
      sellerImage: json['seller']['profilePicURI'] ?? '',
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      views: json['views'] ?? 0,
    );
  }
}
