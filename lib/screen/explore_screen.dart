import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final imageUrl = animeData['images']['jpg']['large_image_url'];
    final synopsis = animeData['synopsis'];
    final trailerUrl = animeData['trailer_url'] as String?;

    return ListTile(
      title: Text(animeTitle),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExploreDetailScreen(
              animeTitle: animeTitle,
              imageUrl: imageUrl,
              synopsis: synopsis,
              trailerUrl: trailerUrl,
            ),
          ),
        );
      },
    );
  }
}

class ExploreDetailScreen extends StatelessWidget {
  final String animeTitle;
  final String imageUrl;
  final String synopsis;
  final String? trailerUrl;

  ExploreDetailScreen({
    required this.animeTitle,
    required this.imageUrl,
    required this.synopsis,
    this.trailerUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animeTitle),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(imageUrl),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                synopsis,
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (trailerUrl != null)
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes abrir el reproductor de video o hacer lo que necesites con el tráiler
                  // Puedes utilizar el paquete de reproducción de videos que prefieras.
                },
                child: Text('Ver Trailer'),
              ),
          ],
        ),
      ),
    );
  }
}
