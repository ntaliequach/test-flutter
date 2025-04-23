import 'dart:convert';  // decode JSON
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ---------------------- Service class to make calls to Google Places API ----------------------

class GooglePlacesService {
  final String? _key = dotenv.env['GOOGLE_PLACES_API_KEY'];

  // Fetch nearby matcha shops based on location
  Future<List<Map<String, dynamic>>> fetchMatchaShopsNearby({
    required String location, // "latitude,longitude"
    int radius = 1000,        // search radius in meters
  }) async {
    if (_key == null || _key.isEmpty) {
      throw Exception('❌ API key is missing or not loaded from .env');
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$location&radius=$radius&keyword=matcha&key=$_key',
    );

    final response = await http.get(url);
    print('🌐 API Request: $url');
    print('📦 API Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'REQUEST_DENIED') {
        throw Exception('❌ API Error: ${data['error_message']}');
      }

      final results = data['results'] as List;

      return results.map((place) {
        return {
          'name': place['name'],
          'rating': place['rating'],
          'address': place['vicinity'],
        };
      }).toList();
    } else {
      throw Exception('❌ HTTP Error: ${response.statusCode}');
    }
  }
}
