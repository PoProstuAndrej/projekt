import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/disney_character.dart';
import '../services/disney_api_service.dart';
import '../services/character_local_database.dart';
import '../services/character_sync_service.dart';
import 'character_detail_screen.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final DisneyApiService api = DisneyApiService();

  List<DisneyCharacter> characters = [];
  bool isLoading = true;
  bool isOffline = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadCharacters();
  }

  void loadCharacters() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
        isOffline = false;
      });

      await CharacterSyncService.loadInitialDataIfNeeded();
      final data = CharacterLocalDatabase.getCharacters();

      setState(() {
        characters = data;
        isLoading = false;
      });
    } catch (e) {
      final localData = CharacterLocalDatabase.getCharacters();
      if (localData.isNotEmpty) {
        setState(() {
          characters = localData;
          isLoading = false;
          isOffline = true;
        });
      } else {
        setState(() {
          error = 'Brak połączenia z internetem oraz brak zapisanych danych lokalnych.';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A6E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A6E),
        elevation: 0,
        title: Image.asset(
          'assets/images/logo.png',
          height: 48,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        bottom: isOffline
            ? PreferredSize(
                preferredSize: const Size.fromHeight(24),
                child: Container(
                  color: Colors.amber[700],
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Center(
                    child: Text(
                      'Tryb offline - załadowano z pamięci urządzenia',
                      style: GoogleFonts.walterTurncoat(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (error != null) {
      return Center(
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
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: loadCharacters,
                icon: const Icon(Icons.refresh),
                label: Text(
                  'Spróbuj ponownie',
                  style: GoogleFonts.walterTurncoat(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    CharacterDetailScreen(characterId: character.id),
                transitionDuration: const Duration(milliseconds: 400),
                reverseTransitionDuration: const Duration(milliseconds: 350),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  // Wejście: slide pełny z prawej + fade
                  final fadeTween = Tween(begin: 0.0, end: 1.0)
                      .chain(CurveTween(curve: Curves.easeIn));
                  final slideTween = Tween(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeInOut));

                  return FadeTransition(
                    opacity: animation.drive(fadeTween),
                    child: SlideTransition(
                      position: animation.drive(slideTween),
                      child: child,
                    ),
                  );
                },
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0077CC), Color(0xFF00C6FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                // Zdjęcie postaci
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: character.imageUrl.isNotEmpty
                        ? Image.network(
                            character.imageUrl,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                width: 52,
                                height: 52,
                                color: Colors.white24,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 52,
                                height: 52,
                                color: Colors.white24,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.white,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 52,
                            height: 52,
                            color: Colors.white24,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                  ),
                ),

                // Imię postaci
                Expanded(
                  child: Text(
                    character.name,
                    style: GoogleFonts.walterTurncoat(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.chevron_right, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}