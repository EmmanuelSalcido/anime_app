import 'package:flutter/material.dart';
import 'package:anime_app/screen/Screen%20Details/anime_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<dynamic> searchResults;

  SearchResultsScreen({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de búsqueda'),
      ),
      body: _buildSearchResults(context),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final resultData = searchResults[index];
        final imageUrl = resultData['images']['jpg']['large_image_url'];
        final animeTitle = resultData['title'];

  return GestureDetector(
  onTap: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AnimeDetailScreen(
          animeTitle: animeTitle,
          animeDetails: {
            'images': {'jpg': {'large_image_url': imageUrl}},
            'trailer': {'embed_url': ''},
            'synopsis': '',
            'rank': resultData['rank'],
          },
        ),
      ),
    );
  },
  child: Material(
    child: Card(
      elevation: 4.0,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    ),
  ),
);
      },
    );
  }
}
