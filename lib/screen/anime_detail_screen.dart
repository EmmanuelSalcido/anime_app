import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AnimeDetailScreen extends StatelessWidget {
  final String animeTitle;
  final Map<String, dynamic>? animeDetails;

  AnimeDetailScreen({required this.animeTitle, this.animeDetails});

  void _watchAnime() {
    final streamingApiUrl = 'https://api.jikan.moe/v4/anime/${animeDetails?['mal_id']}/streaming';
    launch(streamingApiUrl);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = animeDetails?['images']?['largeImageUrl'];
    final synopsis = animeDetails?['synopsis'];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            Text(animeTitle),
          ],
        ),
      ),
      body: Container(
        color: Colors.cyan,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl ?? 'https://via.placeholder.com/200x300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animeTitle,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          synopsis ?? 'Sin sinopsis disponible',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Cuadro grande para streaming
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _watchAnime,
                    child: Text('Ver en Streaming'),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Espacio en blanco
              Row(
                children: [
                  Expanded(child: Container()),
                  ElevatedButton(
                    onPressed: _watchAnime,
                    child: Text('Ver en Streaming'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
