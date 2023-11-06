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

      // Navegar a la pantalla de resultados con los resultados de la búsqueda
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
        final animeTitle = animeData['title'];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExploreDetailScreen(
                  animeTitle: animeTitle,
                  synopsis: '',
                ),
              ),
            );
          },
          child: Image.network(
            animeData['images']['jpg']['large_image_url'],
            fit: BoxFit.cover,
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
          // Sección de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar animes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                // Realizar la búsqueda cuando el usuario presiona Enter
                searchAnime(query);
              },
            ),
          ),
          // Sección "Próximamente"
          Expanded(child: _buildUpcomingAnimeSection()),
        ],
      ),
    );
  }
}