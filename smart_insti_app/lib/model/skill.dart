class Skill{
  final String title;
  final int profeciency;
  Skill({required this.title, required this.profeciency});
  
  Map<String, dynamic> toJson() => {
    'title': title,
    'profeciency': profeciency,
  };
  Skill.fromJson(Map<String, dynamic> hashMap)
  : title = hashMap['title'], profeciency = hashMap['profeciency'];
}
