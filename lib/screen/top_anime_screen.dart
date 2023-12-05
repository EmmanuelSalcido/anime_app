import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_app/screen/Screen%20Details/anime_detail_screen.dart';
import 'package:translator/translator.dart';

class TopAnimeScreen extends StatefulWidget {
  @override
  _TopAnimeScreenState createState() => _TopAnimeScreenState();
}

class _TopAnimeScreenState extends State<TopAnimeScreen> {
  List<Map<String, dynamic>> topAnimeList = [];
  final translator = GoogleTranslator();

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

  Future<String> _translateSynopsis(String englishSynopsis) async {
    var translation = await translator.translate(englishSynopsis, from: 'en', to: 'es');
    return translation.text;
  }

  @override
  void initState() {
    super.initState();
    fetchTopAnimes();
  }

    @override
  Widget build(BuildContext context) {
    final itemCount = topAnimeList.length > 25 ? 25 : topAnimeList.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, 
        title: Center(
          child: Text(
            'Top Animes',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: itemCount, 
        itemBuilder: (context, index) {
          final animeData = topAnimeList[index];
          final animeTitle = animeData['title'];
          final imageUrl = animeData['images']['jpg']['large_image_url'];
          final englishSynopsis = animeData['synopsis'];

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
            onTap: () async {
              final translatedSynopsis = await _translateSynopsis(englishSynopsis);
              animeData['synopsis'] = translatedSynopsis; 
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