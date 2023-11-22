import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:translator/translator.dart';

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

  Future<String> _translateSynopsis(String synopsis) async {
    final translator = GoogleTranslator();
    final translation = await translator.translate(synopsis, from: 'en', to: 'es');
    return translation.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  leading: IconButton(
    icon: Icon(MdiIcons.arrowLeft),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
  title: Text('ProyectoAnimeApi'),
  backgroundColor: Colors.black,
),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
           
            Text(
              widget.animeTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

           
            if (widget.imageUrl != null)
              Image.network(widget.imageUrl!)
            else
              Container(),

           
            FutureBuilder(
              future: _translateSynopsis(widget.synopsis),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text(
                    snapshot.data as String,
                    style: TextStyle(fontSize: 16),
                  );
                } else {
                  return Text('Cargando sinopsis...');
                }
              },
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