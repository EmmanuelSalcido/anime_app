import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeDetailScreen extends StatelessWidget {
  final String animeTitle;
  final Map<String, dynamic>? animeDetails; // Usa '?' para hacerlo opcional

  AnimeDetailScreen({required this.animeTitle, this.animeDetails});

  void _watchAnime() {
    final streamingApiUrl = 'https://api.jikan.moe/v4/anime/${animeDetails?['mal_id']}/streaming';
    launch(streamingApiUrl);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = animeDetails?['images']?['jpg']?['large_image_url'];
    final synopsis = animeDetails?['synopsis'];

    return Scaffold(
      appBar: AppBar(
        title: Text(animeTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Imagen del anime
              imageUrl != null
                  ? Image.network(imageUrl, width: double.infinity, height: 300, fit: BoxFit.cover)
                  : Placeholder(
                      fallbackHeight: 300,
                    ),
              SizedBox(height: 16),

              // Sinopsis
              Text(
                animeTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                synopsis ?? 'Sin sinopsis disponible',
                style: TextStyle(fontSize: 16),
              ),

              // Botón para ver en streaming
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 200, // Altura del cuadro para streaming
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Borde del cuadro
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _watchAnime,
                    child: Text('Ver en Streaming'),
                  ),
                ),
              ),

              // Espacio en blanco
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}