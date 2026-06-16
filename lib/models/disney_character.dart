class DisneyCharacter {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> films;
  final List<String> tvShows;

  DisneyCharacter({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.films,
    required this.tvShows,
  });

  factory DisneyCharacter.fromJson(
    Map<String, dynamic> json,
  ) {
    return DisneyCharacter(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '',
      films: List<String>.from(
        json['films'] ?? [],
      ),
      tvShows: List<String>.from(
        json['tvShows'] ?? [],
      ),
    );
  }

  // na mape do hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'films': films,
      'tvShows': tvShows,
    };
  }

  // z mapy z hive
  factory DisneyCharacter.fromMap(Map<dynamic, dynamic> map) {
    return DisneyCharacter(
      id: map['id'] as int,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      films: List<String>.from(map['films'] ?? []),
      tvShows: List<String>.from(map['tvShows'] ?? []),
    );
  }
}