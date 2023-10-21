import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_app/screen/anime_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> animeList = [];
  TextEditingController searchController = TextEditingController();

  Future<void> searchAnimes(String query) async {
    final apiUrl = Uri.parse('https://api.jikan.moe/v4/anime?q=$query');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['data'];

      setState(() {
        animeList = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorar'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar animes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  searchAnimes(query);
                } else {
                  setState(() {
                    animeList.clear();
                  });
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                return _buildAnimeItem(animeList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeItem(dynamic animeData) {
    final animeTitle = animeData['title'];
    final animeImageURL = animeData['imageURL'];

    return ListTile(
      title: Text(animeTitle),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnimeDetailScreen(
              animeTitle: animeTitle,
              //animeImageURL: animeImageURL,
            ),
          ),
        );
      },
    );
  }
}
