import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/disney_character.dart';
import '../services/disney_api_service.dart';
import '../services/character_local_database.dart';

class CharacterDetailScreen extends StatefulWidget {
  final int characterId;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
  });

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  final DisneyApiService api = DisneyApiService();

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
      setState(() {
        isLoading = true;
        error = null;
      });

      // szukamy w hive
      final localCharacters = CharacterLocalDatabase.getCharacters();
      final found = localCharacters.where((c) => c.id == widget.characterId);

      if (found.isNotEmpty) {
        setState(() {
          character = found.first;
          isLoading = false;
        });
        return;
      }

      // nie ma lokalnie, pytamy api
      final data = await api.fetchCharacterDetails(widget.characterId);

      setState(() {
        character = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Nie udało się pobrać szczegółowych danych postaci (brak internetu).';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A3A6E),
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A3A6E),
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.walterTurncoat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: loadCharacter,
                  icon: const Icon(Icons.refresh),
                  label: Text(
                    'Spróbuj ponownie',
                    style: GoogleFonts.walterTurncoat(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A6E),
        foregroundColor: Colors.white,
        title: Text(
          character!.name,
          style: GoogleFonts.walterTurncoat(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zdjęcie postaci
            if (character!.imageUrl.isNotEmpty)
              Center(
                child: Image.network(
                  character!.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 200,
                      width: 200,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            // Nagłówek "Filmy:"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0077CC), Color(0xFF00C6FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Filmy:',
                style: GoogleFonts.walterTurncoat(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Lista filmów
            ...character!.films.map(
              (film) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: Text(
                  film,
                  style: GoogleFonts.walterTurncoat(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nagłówek "Seriale:"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0077CC), Color(0xFF00C6FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Seriale:',
                style: GoogleFonts.walterTurncoat(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Lista seriali
            ...character!.tvShows.map(
              (show) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: Text(
                  show,
                  style: GoogleFonts.walterTurncoat(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}