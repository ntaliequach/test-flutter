import 'package:flutter/material.dart';
import '../services/matcha_brand_service.dart';
import 'package:url_launcher/url_launcher.dart';


class MatchaBrandsTab extends StatefulWidget {
  const MatchaBrandsTab({super.key});

  @override
  State<MatchaBrandsTab> createState() => _MatchaBrandsTabState();
}

class _MatchaBrandsTabState extends State<MatchaBrandsTab> {
  final brandService = MatchaBrandService();
  Future<List<Map<String, dynamic>>>? brandData;
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for a matcha brand',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onSubmitted: (value) {
              setState(() {
                query = value;
                brandData = brandService.fetchMatchaBrandData(query);
              });
            },
          ),
        ),
        Expanded(
          child: brandData == null
              ? const Center(child: Text("Search to get started"))
              : FutureBuilder<List<Map<String, dynamic>>>(
                  future: brandData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    final brands = snapshot.data!;
                    return ListView.builder(
                      itemCount: brands.length,
                      itemBuilder: (context, index) {
                        final brand = brands[index];
                        return ListTile(
                          title: GestureDetector(
                            onTap: () => launchUrl(Uri.parse(brand['link'])),
                            child: Text(
                              brand['title'],
                              style: const TextStyle(
                                color: Colors.blue, // Make the title blue
                                decoration: TextDecoration.underline, // Underline the title
                              ),
                            ),
                          ),
                          subtitle: Text(
                            '${brand['snippet']}}',
                          ),
                          isThreeLine: true,
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