import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mindly/presentation/presentation.dart';
import 'package:mindly/domain/domain.dart';

class PostScrollVerticalSliver extends ConsumerStatefulWidget {
  const PostScrollVerticalSliver({super.key});

  @override
  ConsumerState<PostScrollVerticalSliver> createState() =>
      _PostScrollVerticalSliverState();
}

class _PostScrollVerticalSliverState
    extends ConsumerState<PostScrollVerticalSliver> {
  @override
  void initState() {
    super.initState();
  }

  Color _getCategoryColor(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'tecnología':
      case 'tecnologia':
        return Colors.blue;
      case 'viajes':
        return Colors.green;
      case 'cocina':
        return Colors.orange;
      case 'desarrollo personal':
        return Colors.purple;
      case 'salud':
        return Colors.red;
      case 'deportes':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);
    final recommendedPosts = postsState.recommendedPosts;

    // Si está cargando y no hay posts
    if (postsState.isLoading && recommendedPosts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Si no hay posts
    if (recommendedPosts.isEmpty && !postsState.isLoading) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(Icons.article_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No hay posts disponibles',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Título "Para ti" como primer elemento
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Para ti',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            );
          }

          final postIndex = index - 1;

          // Mostrar posts disponibles
          if (postIndex < recommendedPosts.length) {
            return _buildPostItem(recommendedPosts[postIndex]);
          }

          return null;
        },
        childCount: recommendedPosts.length + 1, // +1 por el título
      ),
    );
  }

  Widget _buildPostItem(Post post) {
    final categoryColor = _getCategoryColor(post.categoria);

    return GestureDetector(
      onTap: () {
        context.push('/post/${post.uid}');
      },
      child: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del post
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: categoryColor.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: post.imagen.isNotEmpty
                      ? Image.network(
                          post.imagen,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder(
                              post.categoria,
                              categoryColor,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return _buildImagePlaceholder(
                              post.categoria,
                              categoryColor,
                            );
                          },
                        )
                      : _buildImagePlaceholder(post.categoria, categoryColor),
                ),
              ),

              // Contenido del post
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categoría
                    Text(
                      post.categoria,
                      style: TextStyle(
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Título
                    Text(
                      post.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Descripción
                    Text(
                      post.descripcion,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // Autor y tags
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: post.usuario.fotoPerfil.isNotEmpty
                              ? NetworkImage(post.usuario.fotoPerfil)
                              : null,
                          child: post.usuario.fotoPerfil.isEmpty
                              ? const Icon(Icons.person, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Por ${post.usuario.nombre}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              if (post.tags.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  children: post.tags.take(3).map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: categoryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '#$tag',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: categoryColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(String categoria, Color color) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
            ),
          ),
        ),
      ],
    );
  }
}
