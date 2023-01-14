class Por{
  final String position;
  final String at;
  Por({required this.position, required this.at});
  Map<String, dynamic> toJson() => {
    'position': position,
    'at': at,
  };
  Por.fromJson(Map<String, dynamic> hashMap)
      : position = hashMap['position'], at = hashMap['at'];
}
