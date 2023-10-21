import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
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
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Lista de categorías
          Expanded(
            child: ListView(
              children: [
                _buildCategoryItem('Categoría 1'),
                _buildCategoryItem('Categoría 2'),
                _buildCategoryItem('Categoría 3'),
                _buildCategoryItem('Categoría 4'),
                _buildCategoryItem('Categoría 5'),
                // Agrega más elementos de categoría según sea necesario
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String categoryName) {
    return ListTile(
      title: Text(categoryName),
      onTap: () {
        // Agregar acción al hacer clic en una categoría si es necesario
      },
    );
  }
}
