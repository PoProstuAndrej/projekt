import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/disney_character.dart';

class DisneyApiService {
  Future<List<DisneyCharacter>> fetchCharacters() async {
    final url = Uri.parse(
      'https://api.disneyapi.dev/character',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List characters = data['data'];

      return characters
          .map(
            (character) =>
                DisneyCharacter.fromJson(character),
          )
          .toList();
    } else {
      throw Exception(
        'Nie udało się pobrać danych',
      );
    }
  }

  Future<DisneyCharacter> fetchCharacterDetails(
    int id,
  ) async {
    final url = Uri.parse(
      'https://api.disneyapi.dev/character/$id',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return DisneyCharacter.fromJson(
        data['data'],
      );
    } else {
      throw Exception(
        'Nie udało się pobrać szczegółów postaci',
      );
    }
  }
}