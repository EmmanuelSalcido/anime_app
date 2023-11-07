import 'package:flutter/material.dart';
import 'package:anime_app/screen/explore_detail_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:translator/translator.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<dynamic> searchResults;

  SearchResultsScreen({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0), // Altura de la AppBar personalizada
        child: AppBar(
          backgroundColor: Colors.black, // Fondo negro
          leading: IconButton(
            icon: Icon(MdiIcons.arrowLeft), // Icono personalizado de flecha
            onPressed: () {
              Navigator.of(context).pop(); // Para regresar a la pantalla anterior
            },
          ),
          title: Text('Resultados De Busqueda'), // Cambia el título aquí
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
        final animeSynopsis = animeData['synopsis'];
        final trailerUrl = animeData['trailer_url'];
        final imageUrl = animeData['images']['jpg']['large_image_url'];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExploreDetailScreen(
                  animeTitle: animeTitle,
                  synopsis: animeSynopsis,
                  trailerUrl: trailerUrl,
                  imageUrl: imageUrl,
                ),
              ),
            );
          },
          child: Image.network(imageUrl),
        );
      },
    );
  }
}
