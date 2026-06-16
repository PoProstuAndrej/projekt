import 'disney_api_service.dart';
import 'character_local_database.dart';

// sync z api do bazy
class CharacterSyncService {
  static final DisneyApiService _api = DisneyApiService();

  // pobieranie z api jak pusto w hive
  static Future<void> loadInitialDataIfNeeded() async {
    if (!CharacterLocalDatabase.isEmpty()) {
      return;
    }
    final characters = await _api.fetchCharacters();
    await CharacterLocalDatabase.saveCharacters(characters);
  }
}
