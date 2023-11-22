import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:translator/translator.dart'; 

class HomeAnimeDetailScreen extends StatefulWidget {
  final String animeTitle;
  final Map<String, dynamic>? animeDetails;

  HomeAnimeDetailScreen({required this.animeTitle, this.animeDetails});

  @override
  _HomeAnimeDetailScreenState createState() => _HomeAnimeDetailScreenState();
}

class _HomeAnimeDetailScreenState extends State<HomeAnimeDetailScreen> {
  late YoutubePlayerController _controller;
  bool isVideoVisible = false;
  String translatedSynopsis = 'Cargando...'; 

  @override
  void initState() {
    super.initState();
    final trailerUrl = widget.animeDetails?['trailer']?['embed_url'] as String?;
    if (trailerUrl != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(trailerUrl)!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }

    
    _translateSynopsis();
  }


  Future<void> _translateSynopsis() async {
    final translator = GoogleTranslator();

    final originalSynopsis = widget.animeDetails?['synopsis'];
    if (originalSynopsis != null) {
      final translation = await translator.translate(originalSynopsis, from: 'en', to: 'es');
      setState(() {
        translatedSynopsis = translation.text;
      });
    } else {
      setState(() {
        translatedSynopsis = 'Sin sinopsis disponible';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.animeDetails?['images']?['jpg']?['large_image_url'];
    final ranking = widget.animeDetails?['rank'] ?? 'Sin ranking';

    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.black,
  title: Text(
    'Animes de Temporada',
    style: TextStyle(color: Colors.white),
  ),
  leading: IconButton(
    icon: Icon(MdiIcons.arrowLeft), 
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
              
              if (imageUrl != null)
                Image.network(imageUrl)
              else
                Container(),

              SizedBox(height: 16),

              
              Text(
                widget.animeTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16),

              
              Text(
                'Ranking: $ranking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16),

            
              Text(
                'Sinopsis:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                translatedSynopsis, 
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 16),

            
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isVideoVisible = !isVideoVisible;
                  });
                },
                child: Text(isVideoVisible ? 'Ocultar Tráiler' : 'Ver Tráiler'),
              ),

              SizedBox(height: 16),

             
              if (isVideoVisible)
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
