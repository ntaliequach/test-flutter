import 'dart:convert';
import 'package:http/http.dart' as http;

class MatchaBrandService {
  Future<List<Map<String, dynamic>>> fetchMatchaBrandData(String brand) async {
    final url = Uri.parse('http://127.0.0.1:5000/search-matcha?brand=$brand');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map<Map<String, dynamic>>((item) => {
        'title': item['title'],
        'snippet': item['snippet'],
        'link': item['link'],
        'stars': item['stars'],
        'reviews': item['reviews'],
      }).toList();
    } else {
      throw Exception('Failed to load brand data');
      
    }
  }
}
