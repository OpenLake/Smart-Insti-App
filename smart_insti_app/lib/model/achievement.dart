class Achievement{
  final String title;
  final String description;
  Achievement({required this.title, required this.description});

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description
  };
  Achievement.fromJson(Map<String, dynamic> hashMap)
  : title = hashMap['title'], description = hashMap['description'];
}
