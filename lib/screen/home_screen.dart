import 'package:flutter/material.dart';
import 'explore_screen.dart';
import 'top_anime_screen.dart';
import 'package:anime_app/screen/anime_detail_screen.dart';
import 'package:anime_app/screen/top_anime_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProyectoAnimeApi'),
        centerTitle: true,
        backgroundColor: Colors.black, // Fondo negro
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
          BottomNavigationBarItem( // Barra de abajo vinculada a las pantallas
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
        return Container(); // Valor de retorno por defecto
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildRecientesAnadidosSection(),
        _buildAnimesSection(),
      ],
    );
  }

  Widget _buildRecientesAnadidosSection() {
    // Sección 1: Recientes añadidos
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen grande en la sección de Recientes añadidos
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/goku.jpg'), // Imagen 1 grande
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Recientes añadidos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Cantidad de imágenes
              itemBuilder: (context, index) {
                return Image.asset(
                  'assets/no-image.jpg',
                  width: 150,
                  height: 150,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimesSection() {
    // Sección 2: Animes
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Animes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // Cantidad de imágenes
              itemBuilder: (context, index) {
                return Image.asset(
                  'assets/no-image.jpg',
                  width: 150,
                  height: 150,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}