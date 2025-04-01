import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import '/favorite_tabs.dart';
import '/matcha_shops.dart';
import '/matcha_brands.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures platform plugins are initialized
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matcha-Go',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 178, 236, 178)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    //print(dotenv.env['KEY']);
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Correct way to initialize
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matcha-Go', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 209, 248, 209),
        foregroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: TabContainer(
          tabEdge: TabEdge.bottom,
          tabsStart: .05,
          tabsEnd: 1,
          tabMaxLength: 120,
          borderRadius: BorderRadius.circular(10),
          tabBorderRadius: BorderRadius.circular(10),
          childPadding: const EdgeInsets.all(0),
          selectedTextStyle: const TextStyle(
            color: Color.fromARGB(255, 41, 103, 41),
            fontSize: 10,
          ),
          unselectedTextStyle: const TextStyle(
            color: Color.fromARGB(255, 41, 103, 41),
            fontSize: 10,
          ),
          colors: const [
            Color.fromARGB(255, 209, 248, 209),
            Color.fromARGB(255, 209, 248, 209),
            Color.fromARGB(255, 209, 248, 209),
          ],
          tabs: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/tutorial.png', height: 35, ),
                const SizedBox(width: 5),
                const Flexible(
                  child: Text('Home', overflow: TextOverflow.ellipsis),
                ),
              ],
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/shop-brands.png', height: 30),
                const SizedBox(width: 4),
                const Flexible(child: Text('Search for brands', overflow: TextOverflow.ellipsis)),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/yelp.png', height: 35),
                const SizedBox(width: 8),
                const Flexible(child: Text('Matcha shops', overflow: TextOverflow.ellipsis)),
              ],
            ),
          ],

          children: const [
            HomeTab(),
            MatchaBrandsTab(),
            MatchaShopsTab(),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------- HOME TAB ---------------------------------------------------

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late TabController _favoritesTabController;

  @override
  void initState() {
    super.initState();
    _favoritesTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _favoritesTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Favorites',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        TabBar(
          controller: _favoritesTabController,
          labelColor: Colors.green,
          indicatorColor: Colors.green,
          tabs: const [
            Tab(text: 'Matcha Cafes'),
            //Tab(text: 'Matcha Brands'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _favoritesTabController,
            children: const [
              FavoriteCafesList(),
              //FavoriteBrandsList(),
            ],
          ),
        ),
      ],
    );
  }
}