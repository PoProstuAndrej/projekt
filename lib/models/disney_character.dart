class DisneyCharacter {
  final int id;
  final String name;
  final String imageUrl;

  DisneyCharacter({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory DisneyCharacter.fromJson(
    Map<String, dynamic> json,
  ) {
    return DisneyCharacter(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}