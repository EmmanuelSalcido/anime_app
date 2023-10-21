import 'package:flutter/material.dart';

class AnimeDetailScreen extends StatelessWidget {
  final String animeTitle;
  final Map<String, dynamic>? animeDetails; // Usa '?' para hacerlo opcional

  AnimeDetailScreen({required this.animeTitle, this.animeDetails});

  @override
  Widget build(BuildContext context) {
    final imageUrl = animeDetails?['images']?['largeImageUrl'];
    final synopsis = animeDetails?['synopsis'];

    return Scaffold(
      appBar: AppBar(
        title: Text(animeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageUrl != null
                ? Image.network(imageUrl, width: 200, height: 300)
                : Placeholder(),
            SizedBox(height: 16),
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
    );
  }
}
