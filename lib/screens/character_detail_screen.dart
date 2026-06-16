import 'package:flutter/material.dart';

import '../models/disney_character.dart';
import '../services/disney_api_service.dart';

class CharacterDetailScreen
    extends StatefulWidget {
  final int characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  @override
  State<CharacterDetailScreen>
      createState() =>
          _CharacterDetailScreenState();
}

class _CharacterDetailScreenState
    extends State<CharacterDetailScreen> {
  final DisneyApiService api =
      DisneyApiService();

  DisneyCharacter? character;

  bool isLoading = true;

  String? error;

  @override
  void initState() {
    super.initState();

    loadCharacter();
  }

  void loadCharacter() async {
    try {
      final data =
          await api.fetchCharacterDetails(
        widget.characterId,
      );

      setState(() {
        character = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error =
            'Nie udało się pobrać danych';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(error!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(character!.name),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            if (character!
                .imageUrl
                .isNotEmpty)
              Center(
                child: Image.network(
                  character!.imageUrl,
                  height: 200,
                ),
              ),

            SizedBox(height: 20),

            Text(
              character!.name,
              style: TextStyle(
                fontSize: 24,
              ),
            ),

            SizedBox(height: 20),

            Text('Filmy:'),

            ...character!.films.map(
              (film) => Text(film),
            ),

            SizedBox(height: 20),

            Text('Seriale:'),

            ...character!.tvShows.map(
              (show) => Text(show),
            ),
          ],
        ),
      ),
    );
  }
}