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
        title: Text('Top Animes'),
      ),
      body: ListView.builder(
        itemCount: topAnimeList.length,
        itemBuilder: (context, index) {
          return _buildAnimeItem(topAnimeList[index], index + 1);
        },
      ),
    );
  }

  Widget _buildAnimeItem(Map<String, dynamic> animeData, int rank) {
    final animeTitle = animeData['title'];
    final animeImageURL = animeData['imageURL'];

    return ListTile(
      leading: Text('$rank'), // Contador de rango
      title: Text(animeTitle),
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
  }
}