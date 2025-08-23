import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

class PostCardLink extends StatelessWidget {
  final String imageUrl;

  const PostCardLink({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          // Aquí puedes navegar a detalle si quieres
          context.push('/post/1');
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
