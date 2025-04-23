import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// defines MatchaBrandsTab widget
// defines MatchaShopsTab widget
// defines FavoriteCafesList widget
// defines HomeScreen

part 'auto_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter {
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeScreen.page, initial: true),
        AutoRoute(page: MatchaBrandsTabScreen.page),
        AutoRoute(page: MatchaShopsTabScreen.page),
        AutoRoute(page: FavoriteCafesList.page),
      ];
}

@RoutePage()
class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  static PageRouteInfo<void> get page => HomeRoute.page;

  @override
  Widget build(BuildContext context) => const HomeRoute();
}

@RoutePage()
class MatchaBrandsTabScreen extends StatelessWidget {
  static var page;

  const MatchaBrandsTabScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Matcha Brands Tab'));
}

@RoutePage()
class MatchaShopsTabScreen extends StatelessWidget {
  static var page;

  const MatchaShopsTabScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Matcha Shops Tab'));
}

@RoutePage()
class FavoriteCafesListScreen extends StatelessWidget {
  const FavoriteCafesListScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Favorite Cafes'));
}
