import 'package:flutter/material.dart';
import 'package:anime_app/screen/explore_screen.dart';
//import 'package:anime_app/screen/anime_detail_screen.dart';
import 'package:anime_app/screen/top_anime_screen.dart';
import 'package:anime_app/screen/goku_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anime_app/screen/home_anime_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> recentAnimes = [];
  List<Map<String, dynamic>> scheduleAnimes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecentAnimes();
    _fetchScheduleAnimes();
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

  Future<void> _fetchScheduleAnimes() async {
    final DateTime now = DateTime.now();
    final String day = _getDay(now.weekday);
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/schedules?filter=$day'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final scheduleAnimesData = jsonData['data'];

      setState(() {
        scheduleAnimes = scheduleAnimesData.cast<Map<String, dynamic>>();
      });
    }
  }

  String _getDay(int dayNumber) {
    switch (dayNumber) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return 'monday';
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
            icon: Icon(Icons.home, color: Colors.transparent),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, color: Colors.transparent),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, color: Colors.transparent),
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
        SizedBox(
          height: 200,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GokuScreen(),
                ),
              );
            },
            child: Image.asset(
              'assets/goku.jpg',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        _buildScheduleAnimes(),
        SizedBox(height: 8),
        _buildRecentAnimes(),
      ],
    );
  }

  Widget _buildScheduleAnimes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Episodios Nuevos Hoy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 160, // Ajusté la altura
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: scheduleAnimes.length,
            itemBuilder: (context, index) {
              final animeData = scheduleAnimes[index];
              final imageUrl = animeData['images']['jpg']['large_image_url'];

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeAnimeDetailScreen(
                        animeTitle: animeData['title'],
                        animeDetails: animeData,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  width: 80,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 80,
                    height: 160,
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

 Widget _buildRecentAnimes() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Animes de Temporada',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recentAnimes.length,
          itemBuilder: (context, index) {
            final animeData = recentAnimes[index];
            final imageUrl = animeData['images']['jpg']['large_image_url'];

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => HomeAnimeDetailScreen(
                      animeTitle: animeData['title'],
                      animeDetails: animeData,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8),
                width: 80,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 80,
                  height: 160,
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


  Widget _buildTopAnimeScreen() {
    return TopAnimeScreen();
  }
}