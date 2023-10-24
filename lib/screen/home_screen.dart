import 'package:flutter/material.dart';
import 'explore_screen.dart';
import 'package:anime_app/screen/anime_detail_screen.dart';
import 'package:anime_app/screen/top_anime_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Anime> recentAnimes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecentAnimes();
  }

  Future<void> _fetchRecentAnimes() async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/seasons/now?sfw'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final animeList = data['data'] as List;

      setState(() {
        recentAnimes = animeList.map((json) => Anime.fromJson(json)).toList();
      });
    } else {
      throw Exception('Error al cargar los animes recientes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProyectoAnimeApi'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: _buildScreen(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Top Animes',
          ),
        ],
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return _buildHomeContent();
      case 1:
        return ExploreScreen();
      case 2:
        return TopAnimeScreen();
      default:
        return Container();
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/goku.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Animes Recientes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: recentAnimes.length,
            itemBuilder: (context, index) {
              final anime = recentAnimes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return HomeDetailScreen(anime: anime);
                    },
                  ));
                },
                child: CachedNetworkImage(
                  imageUrl: anime.imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Anime {
  final String title;
  final String imageUrl;

  Anime({required this.title, required this.imageUrl});

  factory Anime.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['images']['jpg']['large_image_url'] ?? '';
    return Anime(
      title: json['title'] ?? 'Sin título',
      imageUrl: imageUrl,
    );
  }
}

class HomeDetailScreen extends StatelessWidget {
  final Anime anime;

  HomeDetailScreen({required this.anime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anime.title),
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: anime.imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              anime.title,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}