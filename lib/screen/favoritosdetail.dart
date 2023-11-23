// Importa las bibliotecas necesarias
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_app/providers/auth_provider.dart';
import 'anime_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Widget principal para la pantalla de detalles de favoritos
class FavoritosDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        backgroundColor: Colors.black,
      ),
      body: _buildFavoritesList(context),
    );
  }

  // Construye la lista de animes favoritos
  Widget _buildFavoritesList(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Provider.of<AuthProvider>(context).getFavoriteAnimes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> favoriteAnimes = snapshot.data ?? [];
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: favoriteAnimes.length,
            itemBuilder: (context, index) {
              String animeId = favoriteAnimes[index];
              return FutureBuilder<Map<String, dynamic>>(
                future: _getAnimeDetailsFromAPI(animeId),
                builder: (context, animeSnapshot) {
                  if (animeSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (animeSnapshot.hasError) {
                    return Center(child: Text('Error: ${animeSnapshot.error}'));
                  } else {
                    return _buildAnimeWidget(context, animeSnapshot.data ?? {});
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  // Construye el widget para cada anime en la lista de favoritos
  Widget _buildAnimeWidget(BuildContext context, Map<String, dynamic> animeDetails) {
    String imageUrl = animeDetails['images']?['jpg']?['large_image_url'] ?? '';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeDetailScreen(
              animeTitle: animeDetails['title'] ?? 'Sin Título',
              animeDetails: animeDetails,
            ),
          ),
        );
      },
      child: imageUrl.isNotEmpty
          ? Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover)
          : Placeholder(),
    );
  }

  // Obtiene los detalles del anime desde la API por el nombre
  // ...

Future<Map<String, dynamic>> _getAnimeDetailsFromAPI(String animeName) async {
  final response = await http.get(
    Uri.parse('https://api.jikan.moe/v4/anime?q=$animeName'),
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final animeList = jsonData['data'].cast<Map<String, dynamic>>();
    
    if (animeList.isNotEmpty) {
      return animeList[0]; // Tomar el primer elemento de la lista como detalles del anime
    } else {
      throw Exception('No se encontraron detalles para el anime: $animeName');
    }
  } else {
    throw Exception('Error al obtener detalles del anime desde la API');
  }
}

// ...


// ...

}
