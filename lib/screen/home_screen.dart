import 'package:flutter/material.dart';
import 'explore_screen.dart';
import 'package:anime_app/screen/anime_detail_screen.dart';
import 'package:anime_app/screen/top_anime_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'home_anime_detail_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> recentAnimes = [];

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
      final jsonData = json.decode(response.body);
      final recentAnimesData = jsonData['data'];

      setState(() {
        recentAnimes = recentAnimesData.cast<Map<String, dynamic>>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'ProyectoAnimeApi',
          style: TextStyle(color: Colors.white),
          
        ),
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
        // Agrega la pantalla "ExploreScreen" si la tienes
        return ExploreScreen();
      case 2:
        // Agrega la pantalla "TopAnimeScreen" si la tienes
        return TopAnimeScreen();
      default:
        return Container();
    }
  }

Widget _buildHomeContent() {
  return Column(
    children: [
      AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Animes De Temporada',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: recentAnimes.length,
          itemBuilder: (context, index) {
            final animeData = recentAnimes[index];
            final animeTitle = animeData['title'];
            final imageUrl = animeData['images']['jpg']['large_image_url'];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeAnimeDetailScreen(
                      animeTitle: animeTitle,
                      animeDetails: animeData,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8),
                child: Image.network(
                  imageUrl,
                  width: 250,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
}