import 'package:anime_app/screen/explore_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<dynamic> searchResults;

  SearchResultsScreen({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de Búsqueda'),
      ),
      body: _buildSearchResults(context),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final animeData = searchResults[index];
        final animeTitle = animeData['title'];
        final animeSynopsis = animeData['synopsis']; // Sinopsis del anime
        final trailerUrl = animeData['trailer_url']; // URL del trailer (si está disponible)
       final imageUrl = animeData['images']['jpg']['large_image_url']; // URL de la imagen

        return ListTile(
          title: Text(animeTitle),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExploreDetailScreen(
                  animeTitle: animeTitle,
                  synopsis: animeSynopsis, // Pasamos la sinopsis
                  trailerUrl: trailerUrl, // Pasamos la URL del trailer
                  imageUrl: imageUrl, // Pasamos la URL de la imagen
                ),
              ),
            );
          },
        );
      },
    );
  }
}
