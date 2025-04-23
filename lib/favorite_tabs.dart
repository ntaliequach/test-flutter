import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class FavoriteCafesList extends StatefulWidget {
  const FavoriteCafesList({super.key});

  @override
  State<FavoriteCafesList> createState() => _FavoriteCafesListState();
}

class _FavoriteCafesListState extends State<FavoriteCafesList> {
  final favoritesService = FavoritesService();
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await favoritesService.getFavorites('favorite_cafes');
    setState(() => favorites = favs);
  }

  Future<void> _removeFavorite(String name) async {
    await favoritesService.toggleFavorite('favorite_cafes', name);
    _loadFavorites(); // Reload the favorites list after removing
  }

  @override
  Widget build(BuildContext context) {
    return favorites.isEmpty
    ? const Center(child: Text('No favorites yet'))
    : ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return ListTile(
          title: Text(favorite),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red, size: 20,),
            onPressed: () => _removeFavorite(favorite),
          ),
        );
      },
    );
  }
}


// class FavoriteBrandsList extends StatelessWidget {
//   const FavoriteBrandsList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: const [
//         ListTile(title: Text('Ippodo')),
//         ListTile(title: Text('Matchaeologist')),
//       ],
//     );
//   }
// }



// ------------------------------------------- FAVORITES SERVICE ---------------------------------------------------


class FavoritesService {
  // static const _cafesKey = 'favorite_cafes';
  // static const _brandsKey = 'favorite_brands';

  Future<void> toggleFavorite(String key, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(key) ?? [];

    if (current.contains(name)) {
      current.remove(name);
    } else {
      current.add(name);
    }

    await prefs.setStringList(key, current);
  }

  Future<List<String>> getFavorites(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<bool> isFavorite(String key, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(key) ?? [];
    return current.contains(name);
  }
}