import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:anime_app/providers/auth_provider.dart';
import 'package:translator/translator.dart';

class AnimeReleaseDate extends StatelessWidget {
  final String? startDate;

  AnimeReleaseDate({required this.startDate});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        startDate != null ? _formatReleaseDate(startDate!) : 'N/A';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: 'Fecha de Estreno: ',
              style: TextStyle(
                color: Colors.black, // Cambiar a RGB
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: formattedDate,
              style: TextStyle(
                color: Colors.red, // Cambiar a RGB
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatReleaseDate(String dateString) {
    final releaseDate = DateTime.parse(dateString);
    return '${releaseDate.day.toString().padLeft(2, '0')} '
        '${_getMonthName(releaseDate.month)} ${releaseDate.year}';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Ene';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Abr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Ago';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dic';
      default:
        return '';
    }
  }
}

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
  String translatedSynopsis = 'Loading...';
  String ranking = 'N/A';

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
        videoError = 'Trailer no disponible.';
      });
    }

    _translateSynopsis();
    _extractRanking();
    _checkFavoriteStatus();
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
        translatedSynopsis = 'Sin sinopsis';
      });
    }
  }

  void _extractRanking() {
    final rank = widget.animeDetails?['rank'];
    if (rank != null) {
      setState(() {
        ranking = rank.toString();
      });
    } else {
      setState(() {
        ranking = 'N/A';
      });
    }
  }

  void _checkFavoriteStatus() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    List<String> favoriteAnimes = await authProvider.getFavoriteAnimes();
    setState(() {
      isFavorite = favoriteAnimes.contains(widget.animeTitle);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.animeDetails?['images']?['jpg']?['large_image_url'];
    final startDate = widget.animeDetails?['aired']?['from'];

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
                'Ranking: $ranking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              AnimeReleaseDate(startDate: startDate),
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
                        child: Text('Ver Tráiler'),
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

  void _toggleFavoriteStatus() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.toggleFavoriteAnime(widget.animeTitle);
      _checkFavoriteStatus();
    } catch (error) {
      print(error.toString());
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
