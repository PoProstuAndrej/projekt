import 'package:hive_ce/hive.dart';
import '../models/disney_character.dart';

// baza lokalna hive
class CharacterLocalDatabase {
  static Box get _box => Hive.box('characters');

  // pobieranie z hive
  static List<DisneyCharacter> getCharacters() {
    return _box.values.map((item) {
      return DisneyCharacter.fromMap(Map<dynamic, dynamic>.from(item));
    }).toList();
  }

  // czyszczenie i zapis
  static Future<void> saveCharacters(List<DisneyCharacter> characters) async {
    await _box.clear();
    for (final character in characters) {
      await _box.put(character.id, character.toMap());
    }
  }

  // czy pusta
  static bool isEmpty() {
    return _box.isEmpty;
  }
}
