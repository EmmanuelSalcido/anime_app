import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_app/providers/auth_provider.dart';
import 'Screen Details/anime_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class MyAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Esto oculta la flecha de retroceso
        title: Row(
          children: [
            Text(
              'Mi Cuenta',
              style: TextStyle(
                color: Colors.white, // Puedes cambiar el color del texto según tu diseño
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context),
            SizedBox(height: 16),
            Text(
              'Animes Favoritos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            _buildFavoritesList(context),
            Spacer(),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    String? currentNick = Provider.of<AuthProvider>(context).nick;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perfil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Text(
                currentNick != null ? currentNick[0].toUpperCase() : '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 16),
            Text(
              currentNick ?? 'Sin Nick',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoritesList(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<String>>(
        future: Provider.of<AuthProvider>(context).getFavoriteAnimes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> favoriteAnimes = snapshot.data ?? [];
            // Dividir el conjunto de imágenes en filas de tres
            List<List<String>> rowsOfAnimeIds = [];
            for (int i = 0; i < favoriteAnimes.length; i += 3) {
              int endIndex = i + 3;
              if (endIndex > favoriteAnimes.length) {
                endIndex = favoriteAnimes.length;
              }
              rowsOfAnimeIds.add(favoriteAnimes.sublist(i, endIndex));
            }

            return ListView.builder(
              itemCount: rowsOfAnimeIds.length,
              itemBuilder: (context, index) {
                return _buildRowOfAnimeWidgets(context, rowsOfAnimeIds[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildRowOfAnimeWidgets(BuildContext context, List<String> animeIds) {
    return Column(
      children: animeIds.map((animeId) => _buildAnimeWidget(context, animeId)).toList(),
    );
  }

  Widget _buildAnimeWidget(BuildContext context, String animeId) {
    return Container(
      margin: EdgeInsets.only(bottom: 8), // Ajusta el margen según tus necesidades
      child: _buildAnimeImage(context, animeId),
    );
  }

  Widget _buildAnimeImage(BuildContext context, String animeId) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getAnimeDetailsFromAPI(animeId),
      builder: (context, animeSnapshot) {
        if (animeSnapshot.connectionState == ConnectionState.waiting) {
          return _buildPlaceholder();
        } else if (animeSnapshot.hasError) {
          return _buildPlaceholder();
        } else {
          Map<String, dynamic> animeDetails = animeSnapshot.data ?? {};
          return GestureDetector(
            onTap: () {
              _navigateToAnimeDetail(context, animeDetails);
            },
            child: _buildAnimeImageWidget(animeDetails),
          );
        }
      },
    );
  }

  Widget _buildAnimeImageWidget(Map<String, dynamic> animeDetails) {
    String imageUrl = animeDetails['images']?['jpg']?['large_image_url'] ?? '';
    return imageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          )
        : _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey,
      height: 100,
      width: double.infinity,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await Provider.of<AuthProvider>(context, listen: false).logout();
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      },
      child: Text(
        'Cerrar Sesión',
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  void _navigateToAnimeDetail(BuildContext context, Map<String, dynamic> animeDetails) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AnimeDetailScreen(
              animeTitle: animeDetails['title'] ?? 'Sin Título',
              animeDetails: animeDetails,
            ),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getAnimeDetailsFromAPI(String animeName) async {
    final response = await http.get(
      Uri.parse('https://api.jikan.moe/v4/anime?q=$animeName'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final animeList = jsonData['data'].cast<Map<String, dynamic>>();

      if (animeList.isNotEmpty) {
        return animeList[0];
      } else {
        throw Exception('No se encontraron detalles para el anime: $animeName');
      }
    } else {
      throw Exception('Error al obtener detalles del anime desde la API');
    }
  }
}
