import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

void main() {
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
            seedColor: const Color.fromARGB(255, 107, 214, 107)),
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
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 209, 248, 209),
        foregroundColor: const Color.fromARGB(255, 107, 214, 107),
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
            color: Color.fromARGB(255, 107, 214, 107),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
          unselectedTextStyle: const TextStyle(
            color: Color.fromARGB(255, 107, 214, 107),
            fontSize: 9,
          ),
          colors: const [
            Color.fromARGB(255, 178, 236, 178),
            Color.fromARGB(255, 107, 214, 107),
            Color.fromARGB(255, 107, 214, 107),
          ],
          tabs: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icons/tutorial.png', height: 15),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Home', overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icons/shop-brands.png', height: 15),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Search for brands', overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icons/yelp.png', height: 15),
                  const SizedBox(width: 5),
                  const Flexible(child: Text('Matcha shops', overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ],

          children: const [
            HomeTab(),
            SearchTab(),
            SettingsTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------- Tab Contents ----------------------

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('This is the Home Tab'));
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search for brands here'));
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Find matcha shops near you'));
  }
}
