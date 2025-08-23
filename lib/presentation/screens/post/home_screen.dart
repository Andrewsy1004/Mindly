import 'package:flutter/material.dart';

import 'package:mindly/presentation/presentation.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final int pageIndex;
  final bool isOwner;

  const HomeScreen({super.key, required this.pageIndex, required this.isOwner});

  final viewRoutes = const <Widget>[
    HomeView(),
    Text(''),
    Favoritesview(),
    Profile(isOwner: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: pageIndex, children: viewRoutes),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}
