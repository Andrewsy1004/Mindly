import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:mindly/presentation/presentation.dart';
import 'package:mindly/domain/domain.dart';

class PostMasonry extends StatefulWidget {
  final List<Post> posts;

  const PostMasonry({super.key, required this.posts});

  @override
  State<PostMasonry> createState() => _PostMasonryState();
}

class _PostMasonryState extends State<PostMasonry> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          final post = widget.posts[index];

          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 40),
                PostCardLink(imageUrl: post.imagen, post: post),
              ],
            );
          }

          return PostCardLink(imageUrl: post.imagen, post: post);
        },
      ),
    );
  }
}
