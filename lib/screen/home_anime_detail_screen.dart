import 'package:flutter/material.dart';
import 'package:anime_app/screen/anime_detail_screen.dart';

class HomeAnimeDetailScreen extends StatefulWidget {
  final String animeTitle;
  final Map<String, dynamic>? animeDetails;

  HomeAnimeDetailScreen({required this.animeTitle, this.animeDetails});

  @override
  _HomeAnimeDetailScreenState createState() => _HomeAnimeDetailScreenState();
}

class _HomeAnimeDetailScreenState extends State<HomeAnimeDetailScreen> {
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
          icon: Icon(Icons.arrow_back),
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
                synopsis ?? 'Sin sinopsis disponible',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
