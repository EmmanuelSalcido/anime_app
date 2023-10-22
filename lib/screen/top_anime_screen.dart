import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_app/screen/anime_detail_screen.dart';

class TopAnimeScreen extends StatefulWidget {
  @override
  _TopAnimeScreenState createState() => _TopAnimeScreenState();
}

class _TopAnimeScreenState extends State<TopAnimeScreen> {
  List<Map<String, dynamic>> topAnimeList = [];

  Future<void> fetchTopAnimes() async {
    final apiUrl = Uri.parse('https://api.jikan.moe/v4/top/anime');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final topAnimes = jsonData['data'];

      setState(() {
        topAnimeList = topAnimes.cast<Map<String, dynamic>>();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTopAnimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Fondo negro en toda la barra del título
        title: Text(
          'Top Animes',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: topAnimeList.length,
        itemBuilder: (context, index) {
          final animeData = topAnimeList[index];
          final animeTitle = animeData['title'];
          final imageUrl = animeData['images']['jpg']['large_image_url'];

          return ListTile(
            title: Text('Top ${index + 1} - $animeTitle', style: TextStyle(fontSize: 18)),
            contentPadding: EdgeInsets.all(16),
            leading: imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: 200,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                : Image.asset('assets/placeholder.png'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AnimeDetailScreen(
                    animeTitle: animeTitle,
                    animeDetails: animeData,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
