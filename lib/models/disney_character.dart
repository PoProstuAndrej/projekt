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
}