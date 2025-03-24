import 'dart:convert';  //decode json
import 'package:http/http.dart' as http;

// ---------------------- Service class to make calls to Google Places API ----------------------

class GooglePlacesService {
  final String key = 'AIzaSyAiIU1Vsx8XSUhrW12J0MW9TqHnPNgnGyQ'; // Replace with your real key

  //fetches nearby matcha shops based on location
  Future<List<Map<String, dynamic>>> fetchMatchaShopsNearby({
    required String location, // "latitude,longitude"
    //search radius in meters
    int radius = 1000,
  }) async {
    //construct API request url
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$location&radius=$radius&keyword=matcha&key=$key',
    );

    //send GET request to google places api
    final response = await http.get(url);
    print('API response: ${response.body}');
    //if successful decode and return formatted list
    if (response.statusCode == 200) {
      //convert json string to map
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      //map each result to a simplified object
      return results.map((place) {
        return {
          'name': place['name'],
          'rating': place['rating'],
          'address': place['vicinity'],
        };
      }).toList();
    } else {
      //if the requests fail
      throw Exception('Failed to load matcha shops :(');
    }
  }
  
}