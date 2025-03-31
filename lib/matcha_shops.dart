import '/favorite_tabs.dart';
import 'package:flutter/material.dart';
import '../services/googleplaces.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MatchaShopsTab extends StatefulWidget {
  const MatchaShopsTab({super.key});

  @override
  State<MatchaShopsTab> createState() => _MatchaShopsTabState();
}

class _MatchaShopsTabState extends State<MatchaShopsTab> {

  late GoogleMapController _mapController;

  void _moveCameraTo(LatLng position) {
    _mapController.animateCamera(CameraUpdate.newLatLng(position));
  }
  CameraPosition _yourCameraPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default SF
    zoom: 12,
  );
  Set<Marker> _yourMarkersSet = {};


  final placesService = GooglePlacesService();
  final favoritesService = FavoritesService();
  final favoritesKey = 'favorite_cafes';
  final geocodingService = GeocodingService();
  final TextEditingController _locationController = TextEditingController();

  String? locationInput;
  String? resolvedLocation;
  String? userLocation;

  Future<List<dynamic>>? _placesFuture;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      final position = await Geolocator.getCurrentPosition();

      setState(() {
        resolvedLocation = "${position.latitude},${position.longitude}";
        _yourCameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        );
        _yourMarkersSet = {
          Marker(
            markerId: const MarkerId("current"),
            position: LatLng(position.latitude, position.longitude),
          ),
        };
        _placesFuture = placesService.fetchMatchaShopsNearby(
          location: resolvedLocation!,
        ); // Fetch places for the new location
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const FullScreenMapPage(),
              ));
            },
            child: ClipRRect(
              child: GoogleMap(
                initialCameraPosition: _yourCameraPosition,
                markers: _yourMarkersSet,
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (resolvedLocation != null) {
                    final coords = resolvedLocation!.split(',');
                    _moveCameraTo(LatLng(
                      double.parse(coords[0]),
                      double.parse(coords[1]),
                    ));
                  }
                },
                myLocationEnabled: true,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: '  Enter a city or zip code',
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  onChanged: (value) {
                    locationInput = value;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  if (locationInput != null && locationInput!.trim().isNotEmpty) {
                    final coords = await geocodingService.getCoordinatesFromAddress(locationInput!);
                    if (coords != null) {
                      final parts = coords.split(',');
                      final lat = double.parse(parts[0]);
                      final lng = double.parse(parts[1]);
                      final position = LatLng(lat, lng);

                      setState(() {
                        resolvedLocation = coords;
                        _yourCameraPosition = CameraPosition(target: position, zoom: 14);
                        _yourMarkersSet = {
                          Marker(
                            markerId: const MarkerId("searched"),
                            position: position,
                          ),
                        };
                      });

                      _moveCameraTo(position);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not find location')),
                      );
                    }
                  }
                },

              ),
              IconButton(
                icon: const Icon(Icons.my_location),
                onPressed: _getCurrentLocation,
              ),
            ],
          ),
        ),
        Expanded(
          child: resolvedLocation == null
              ? const Center(child: Text('No location selected'))
              : FutureBuilder(
                  future: _placesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No matcha shops found.'));
                    }
                    final shops = snapshot.data!;
                    return ListView.builder(
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final shop = shops[index];
                        return ListTile(
                          title: Text(shop['name']),
                          subtitle: Text('${shop['address']} - ${shop['rating']}'),
                          trailing: FutureBuilder<bool>(
                            future: favoritesService.isFavorite(
                                favoritesKey, shop['name']),
                            builder: (context, snapshot) {
                              final isFav = snapshot.data ?? false;
                              return IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? Colors.red : null,
                                  size: 20,
                                ),
                                onPressed: () async {
                                  await favoritesService.toggleFavorite(
                                      favoritesKey, shop['name']);
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class GeocodingService {
  final String? API_KEY = dotenv.env['GOOGLE_API_KEY'];

  Future<String?> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$API_KEY',
    );

    try {
      final response = await http.get(url);
      print('Geocoding API URL: $url');
      print('Status Code: \${response.statusCode}');

      final data = jsonDecode(response.body);
      print('Geocoding Response: $data');

      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        return '${location['lat']},${location['lng']}';
      } else {
        print('Geocoding failed with status: ${data['status']}');
        if (data.containsKey('error_message')) {
          print('Error message: ${data['error_message']}');
        }
      }
    } catch (e) {
      print('Geocoding exception: \$e');
    }

    return null;
  }
}

class FullScreenMapPage extends StatelessWidget {
  const FullScreenMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Screen Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
      ),
    );
  }
}
