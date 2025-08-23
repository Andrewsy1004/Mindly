import 'package:flutter/material.dart';

import 'package:mindly/presentation/presentation.dart';

class Favoritesview extends StatelessWidget {
  const Favoritesview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: PostMasonry());
  }
}
