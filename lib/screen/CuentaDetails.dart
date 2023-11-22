import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_app/providers/auth_provider.dart';

class MyAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Cuenta'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(context),
            SizedBox(height: 16),
            _buildFavoritesSection(context),
            SizedBox(height: 16),
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
            color: Colors.white,
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
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFavoritesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Animes Favoritos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        _buildFavoritesList(context), // Agregado: Lista de animes favoritos
      ],
    );
  }

  Widget _buildFavoritesList(BuildContext context) {
  return FutureBuilder<List<String>>(
    future: Provider.of<AuthProvider>(context).getFavoriteAnimes(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Muestra un indicador de carga mientras se espera la lista de favoritos
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // Muestra un mensaje de error si hay un problema al obtener la lista
        return Text('Error al obtener la lista de animes favoritos.');
      } else {
        // Se obtuvo la lista de favoritos, muestra los elementos
        List<String> favoriteAnimes = snapshot.data ?? [];
        return _buildFavoritesListContent(favoriteAnimes);
      }
    },
  );
}

Widget _buildFavoritesListContent(List<String> favoriteAnimes) {
  if (favoriteAnimes.isEmpty) {
    return Text(
      'No tienes animes favoritos.',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  return Column(
    children: favoriteAnimes.map((animeId) {
      // Puedes personalizar la visualización de cada anime favorito aquí
      // Por ahora, solo muestro el ID como ejemplo
      return Text(
        'Anime ID: $animeId',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      );
    }).toList(),
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
}
