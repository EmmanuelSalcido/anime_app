import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:anime_app/providers/auth_provider.dart';

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
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    final embedUrl = widget.animeDetails?['trailer']?['embed_url'] as String?;
    if (embedUrl != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(embedUrl)!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } else {
      setState(() {
        videoError = 'No se encontró la fuente del video.';
      });
    }

    // Verificar si el anime actual está en la lista de favoritos
    _checkFavoriteStatus();
  }

  // Nuevo: Método para verificar el estado de favoritos al cargar la pantalla
  void _checkFavoriteStatus() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    List<String> favoriteAnimes = await authProvider.getFavoriteAnimes();
    setState(() {
      isFavorite = favoriteAnimes.contains(widget.animeTitle); // Cambia a tu lógica de identificación del anime
    });
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
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(MdiIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Nuevo: Botón de Favoritos
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              _toggleFavoriteStatus();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (imageUrl != null) Image.network(imageUrl) else Container(),
              SizedBox(height: 16),
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

  // Nuevo: Método para agregar/quitar de favoritos
  void _toggleFavoriteStatus() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      // Toggle the favorite status
      await authProvider.toggleFavoriteAnime(widget.animeTitle);

      // Actualizar el estado local de favoritos
      _checkFavoriteStatus();
    } catch (error) {
      print(error.toString());
      // Manejar el error, si es necesario
    }
  }

  @override
  void dispose() {
    if (_controller.value.isReady) {
      _controller.dispose();
    }
    super.dispose();
  }
}
