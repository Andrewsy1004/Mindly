import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindly/presentation/presentation.dart';

import '../../../domain/entities/Post.dart';

class Profile extends ConsumerStatefulWidget {
  static const name = 'profile';
  final bool isOwner;
  final String? userId;

  const Profile(this.userId, {super.key, this.isOwner = false});

  @override
  ConsumerState<Profile> createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {
  Set<String> favorites = {};

  // Función para toggle favorito (solo para owner)
  void toggleFavorite(String postId) {
    if (!widget.isOwner) return;
    setState(() {
      if (favorites.contains(postId)) {
        favorites.remove(postId);
      } else {
        favorites.add(postId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final authState = ref.watch(authProvider);
    final usersState = ref.watch(usersSliderProvider).users;
    final postsState = ref.watch(postsProvider);

    // Seleccionar el usuario actual
    final user = widget.isOwner
        ? authState.user
        : usersState.firstWhere((u) => u.uid == widget.userId);

    // Filtrar posts del usuario específico
    final userPosts = postsState.allPosts
        .where((post) => post.usuario.uid == user!.uid)
        .toList();

    // Filtrar posts favoritos (solo para owner)
    final favoritePosts = widget.isOwner
        ? userPosts.where((post) => favorites.contains(post.uid)).toList()
        : <Post>[];

    return DefaultTabController(
      length: widget.isOwner ? 2 : 1, // 2 tabs para owner, 1 para otros
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Perfil",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(user!.fotoPerfil),
              ),
              const SizedBox(height: 10),
              Text(
                user.nombre,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(user.profesion, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 15),

              if (widget.isOwner)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.push('/profile/edit');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Editar perfil"),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  user.biografia,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),

              // TabBar condicional
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: [
                  const Tab(text: "Publicaciones"),
                  if (widget.isOwner) const Tab(text: "Favoritos"),
                ],
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: TabBarView(
                  children: [
                    // Tab de Publicaciones
                    _buildPostsGrid(userPosts),
                    // Tab de Favoritos (solo si es owner)
                    if (widget.isOwner) _buildFavoritesGrid(favoritePosts),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsGrid(List<Post> posts) {
    if (posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.post_add, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No hay publicaciones",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Aún no se han compartido publicaciones",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 6,
          childAspectRatio: 0.85,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return _OptimizedPostCard(
            post: post,
            isFavorite: favorites.contains(post.uid),
            showFavoriteButton: widget.isOwner,
            onFavoritePressed: () => toggleFavorite(post.uid),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesGrid(List<Post> favoritePosts) {
    if (favoritePosts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No tienes favoritos aún",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Toca el ⭐ en tus posts favoritos",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 6,
          childAspectRatio: 0.85,
        ),
        itemCount: favoritePosts.length,
        itemBuilder: (context, index) {
          final post = favoritePosts[index];
          return _OptimizedPostCard(
            post: post,
            isFavorite: true,
            showFavoriteButton: true,
            onFavoritePressed: () => toggleFavorite(post.uid),
          );
        },
      ),
    );
  }
}

class _OptimizedPostCard extends StatelessWidget {
  final Post post;
  final bool isFavorite;
  final bool showFavoriteButton;
  final VoidCallback onFavoritePressed;

  const _OptimizedPostCard({
    required this.post,
    this.isFavorite = false,
    this.showFavoriteButton = true,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/post/${post.uid}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con botón de favorito
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    child: Image.network(
                      post.imagen,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  // Botón de favorito solo para owner
                  if (showFavoriteButton)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: onFavoritePressed,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite ? Colors.amber : Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Contenido de texto
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Títulos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            post.descripcion,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Categoría en la parte inferior
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        post.categoria,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
