import 'package:anime_app/screen/Resultados_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anime_app/screen/explore_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> upcomingAnimeList = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchUpcomingAnimes() async {
    final num = 1;
    final apiUrl = Uri.parse('https://api.jikan.moe/v4/seasons/upcoming?page=$num&sfw');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final upcomingAnimes = jsonData['data'];

      setState(() {
        upcomingAnimeList = upcomingAnimes;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUpcomingAnimes();
  }

  Future<void> searchAnime(String query) async {
    final searchUrl = Uri.parse('https://api.jikan.moe/v4/anime?q=$query');
    final response = await http.get(searchUrl);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final searchResults = jsonData['data'];

      
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(searchResults: searchResults),
        ),
      );
    }
  }

  Widget _buildUpcomingAnimeSection() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: upcomingAnimeList.length,
      itemBuilder: (context, index) {
        final animeData = upcomingAnimeList[index];
        final imageUrl = animeData['images']['jpg']['large_image_url'];
        final synopsis = animeData['synopsis'] ?? 'Sin sinopsis disponible'; 

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExploreDetailScreen(
                  animeTitle: animeData['title'], 
                  imageUrl: imageUrl, 
                  synopsis: synopsis, 
                  trailerUrl: animeData['trailer_url'], 
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
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
                
                prefixIcon: null,
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                
                searchAnime(query);
              },
            ),
          ),
          
          Text(
            'Próximamente',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          
          Expanded(child: _buildUpcomingAnimeSection()),
        ],
      ),
    );
  }
}