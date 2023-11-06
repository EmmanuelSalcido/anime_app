import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExploreDetailScreen extends StatefulWidget {
  final String animeTitle;
  final String synopsis;
  final String? imageUrl;
  final String? trailerUrl;

  ExploreDetailScreen({
    required this.animeTitle,
    required this.synopsis,
    this.imageUrl,
    this.trailerUrl,
  });

  @override
  _ExploreDetailScreenState createState() => _ExploreDetailScreenState();
}

class _ExploreDetailScreenState extends State<ExploreDetailScreen> {
  late YoutubePlayerController? _controller;
  bool isVideoVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.trailerUrl != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.trailerUrl!)!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animeTitle),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Título del anime
            Text(
              widget.animeTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Imagen del anime
            if (widget.imageUrl != null)
              Image.network(widget.imageUrl!)
            else
              Container(),

            // Sinopsis del anime
            Text(
              widget.synopsis,
              style: TextStyle(fontSize: 16),
            ),

            // Botón para ver u ocultar el video
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isVideoVisible = !isVideoVisible;
                });
              },
              child: Text(isVideoVisible ? 'Ocultar Tráiler' : 'Ver Tráiler'),
            ),

            // Reproductor de YouTube para el tráiler si está disponible
            if (isVideoVisible && widget.trailerUrl != null)
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                ),
                builder: (context, player) {
                  return Column(
                    children: [
                      Divider(), // Línea divisoria
                      player,
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.trailerUrl != null && _controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }
}
