import 'package:flutter/material.dart';

import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:mindly/domain/domain.dart';

class PostCardLink extends StatelessWidget {
  final String imageUrl;
  final Post post;

  const PostCardLink({super.key, required this.imageUrl, required this.post});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: GestureDetector(
        onTap: () {
          // Navega usando el uid del post
          context.push('/post/${post.uid}');
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image, size: 50),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 150,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
}
