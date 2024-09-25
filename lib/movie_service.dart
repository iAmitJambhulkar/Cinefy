import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieService {
  final String baseUrl = 'https://api.tvmaze.com/search/shows?q=all';

  Future<List<Map<String, dynamic>>> fetchMovies() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);

        // Extract the 'show' details from the response
        return jsonResponse.map((item) => item['show'] as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      throw Exception('Failed to load movies: $error');
    }
  }
}
