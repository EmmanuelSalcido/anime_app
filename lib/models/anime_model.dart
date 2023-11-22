class Anime {
  final int id;
  final String title;
  final String synopsis;
  final String imageUrl;
  bool isFavorite; // Nuevo campo

  Anime({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.imageUrl,
    this.isFavorite = false, // Valor predeterminado
  });
}
