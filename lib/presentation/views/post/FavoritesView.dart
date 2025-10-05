import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindly/presentation/presentation.dart';

class Favoritesview extends ConsumerWidget {
  const Favoritesview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritePosts = ref.watch(postsProvider).favoritePosts;
    final isLoading = ref.watch(postsProvider).isLoading;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (favoritePosts.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // centra verticalmente
            children: [
              Icon(
                Icons.favorite_border_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "No hay publicaciones",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(body: PostMasonry(posts: favoritePosts));
  }
}
