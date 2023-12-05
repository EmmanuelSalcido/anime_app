import 'package:flutter/material.dart';
import 'package:anime_app/screen/Screen%20Details/anime_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<dynamic> searchResults;

  SearchResultsScreen({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Colors.black,
          title: Text('Resultados de Búsqueda'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: _buildSearchResults(context),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final animeData = searchResults[index];
        final animeTitle = animeData['title'];
        final animeDetails = animeData; 

        return GestureDetector(
          onTap: () {
            print('Clic en la imagen de $animeTitle'); 
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AnimeDetailScreen(
                  animeTitle: animeTitle,
                  animeDetails: animeDetails,
                ),
              ),
            );
          },
          child: Image.network(animeDetails['images']['jpg']['large_image_url']),
        );
      },
    );
  }
}
