import 'package:flutter/material.dart';

import '../models/disney_character.dart';
import '../services/disney_api_service.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() =>
      _CharacterListScreenState();
}

class _CharacterListScreenState
    extends State<CharacterListScreen> {
  final DisneyApiService api =
      DisneyApiService();

  List<DisneyCharacter> characters = [];

  bool isLoading = true;

  String? error;

  @override
  void initState() {
    super.initState();

    loadCharacters();
  }

  void loadCharacters() async {
    try {
      final data =
          await api.fetchCharacters();

      setState(() {
        characters = data;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Disney Characters'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return Center(
        child:
            CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Text(error!),
      );
    }

    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character =
            characters[index];

        return Card(
  child: ListTile(
    leading: character.imageUrl.isNotEmpty
        ? Image.network(
            character.imageUrl,
            width: 50,
            height: 50,
          )
        : Icon(Icons.person),
    title: Text(character.name),
  ),
);
      },
    );
  }
}