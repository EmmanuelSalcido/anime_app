import 'package:http/http.dart' as http;

class AnimeProvider {
  final String baseUrl = 'https://api.jikan.moe/v4';

  Future<http.Response> fetchAnimeById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/anime/$id/full'));
    return response;
  }
}
