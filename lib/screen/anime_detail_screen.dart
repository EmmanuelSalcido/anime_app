import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AnimeDetailScreen extends StatefulWidget {
  final String animeTitle;
  final Map<String, dynamic>? animeDetails;

  AnimeDetailScreen({required this.animeTitle, this.animeDetails});

  @override
  _AnimeDetailScreenState createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  late YoutubePlayerController _controller;
  String videoError = '';
  bool isVideoVisible = false;

  @override
  void initState() {
    super.initState();
    final embedUrl = widget.animeDetails?['trailer']?['embed_url'] as String?;
    if (embedUrl != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(embedUrl)!,
        flags: YoutubePlayerFlags(
          autoPlay: false, // No se reproduce automáticamente
          mute: false,
        ),
      );
    } else {
      setState(() {
        videoError = 'No se encontró la fuente del video.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.animeDetails?['images']?['jpg']?['large_image_url'];
    final synopsis = widget.animeDetails?['synopsis'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.animeTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black, // Color de fondo de la barra
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icono de flecha para regresar
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Imagen del anime
              if (imageUrl != null)
                Image.network(imageUrl)
              else
                Container(), // Puedes personalizar esto si la imagen no está disponible

              SizedBox(height: 16),

              // Sinopsis
              Text(
                widget.animeTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                synopsis ?? 'Sin sinopsis disponible',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 16),

              // Video del trailer del anime o mensaje de error
              if (videoError.isNotEmpty)
                Center(
                  child: Text(
                    videoError,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
              else
                !isVideoVisible
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isVideoVisible = true;
                          });
                        },
                        child: Text('Ver Trailer'),
                      )
                    : YoutubePlayer(
                        controller: _controller,
                        liveUIColor: Colors.amber,
                      ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_controller.value.isReady) {
      _controller.dispose();
    }
    super.dispose();
  }
}
