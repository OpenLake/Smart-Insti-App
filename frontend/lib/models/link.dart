class Link {
  final String id;
  final String title;
  final String url;
  final String category;
  final String? iconURI;

  Link({
    required this.id,
    required this.title,
    required this.url,
    required this.category,
    this.iconURI,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      id: json['_id'],
      title: json['title'],
      url: json['url'],
      category: json['category'],
      iconURI: json['iconURI'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'category': category,
      'iconURI': iconURI,
    };
  }
}
