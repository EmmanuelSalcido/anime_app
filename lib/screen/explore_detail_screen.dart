import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExploreDetailScreen extends StatelessWidget {
  final String animeTitle;
  final String synopsis;
  final String? trailerUrl;

  ExploreDetailScreen({
    required this.animeTitle,
    required this.synopsis,
    this.trailerUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animeTitle),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Imagen del anime si la tienes
            // Agrega aquí la imagen si la tienes

            // Título del anime
            Text(
              animeTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Trailer del anime si está disponible
            if (trailerUrl != null)
              ElevatedButton(
                onPressed: () {
                  // Abre el reproductor de YouTube al hacer clic en el botón
                  YoutubePlayerController _controller = YoutubePlayerController(
                    initialVideoId: YoutubePlayer.convertUrlToId(trailerUrl!)!,
                    flags: YoutubePlayerFlags(
                      autoPlay: true, // Reproducir automáticamente el video
                    ),
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _controller,
                        ),
                        builder: (context, player) {
                          return Scaffold(
                            appBar: AppBar(
                              title: Text(animeTitle),
                            ),
                            body: Center(child: player),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: Text('Ver Trailer'),
              ),

            // Sinopsis del anime
            Text(
              synopsis,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
