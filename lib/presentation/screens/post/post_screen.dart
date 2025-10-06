import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindly/domain/domain.dart';
import 'package:mindly/presentation/presentation.dart';

class PostScreen extends ConsumerStatefulWidget {
  static const name = 'post-screen';
  final String id;
  const PostScreen({super.key, required this.id});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar comentarios al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(comentariosProvider.notifier).cargarComentarios();
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> deletePostById(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(postsProvider.notifier).eliminarPost(widget.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post eliminado correctamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el post: $e')),
        );
      }
    }
  }

  Future<void> _crearComentario() async {
    if (_comentarioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe un comentario'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final authState = ref.read(authProvider).user!;

      await ref
          .read(comentariosProvider.notifier)
          .crearComentario(widget.id, _comentarioController.text.trim());

      _comentarioController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comentario agregado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _eliminarComentario(String comentarioId) async {
    try {
      await ref
          .read(comentariosProvider.notifier)
          .eliminarComentario(comentarioId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comentario eliminado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);
    final comentariosState = ref.watch(comentariosProvider);
    final recommendedPosts = postsState.allPosts;
    final authState = ref.read(authProvider).user;

    // Buscar el post en la lista
    final post = recommendedPosts.where((p) => p.uid == widget.id).firstOrNull;

    // Si el post no existe, redirigir automáticamente
    if (post == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.pop();
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Verificar si el post pertenece al usuario
    final isOwner = post.usuario.uid == authState!.uid;

    // Filtrar comentarios del post actual
    final comentariosDelPost = comentariosState.comentarios
        .where((c) => c.post.uid == widget.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              ref
                      .watch(postsProvider)
                      .favoritePosts
                      .any((p) => p.uid == post.uid)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color:
                  ref
                      .watch(postsProvider)
                      .favoritePosts
                      .any((p) => p.uid == post.uid)
                  ? Colors.red
                  : Colors.grey,
            ),
            onPressed: () =>
                ref.read(postsProvider.notifier).toggleFavorite(post),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título y autor
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          context.push('/profileUser/${post.usuario.uid}'),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              post.usuario.fotoPerfil,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            post.usuario.nombre,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat(
                        "dd/MM/yyyy · HH:mm",
                      ).format(DateTime.parse(post.createdAt)),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),

            // Chips
            Wrap(
              spacing: 8,
              children: post.tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const SizedBox(height: 12),

            // Botones de acciones
            if (isOwner)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => deletePostById(ref, context),
                    child: const Text(
                      "Eliminar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () =>
                        context.push('/actualizar-post/${post.uid}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0D80F2),
                    ),
                    child: const Text(
                      "Editar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),

            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.imagen,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Descripción del post
            Text(
              post.descripcion,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),

            // Sección de comentarios
            const Text(
              "Comentarios",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Lista de comentarios
            if (comentariosState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (comentariosDelPost.isEmpty)
              const Text(
                'No hay comentarios aún. ¡Sé el primero en comentar!',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...comentariosDelPost.map((comentario) {
                final isComentarioOwner =
                    comentario.usuario.uid == authState.uid;
                return _Comment(
                  comentario: comentario,
                  isOwner: isComentarioOwner,
                  onDelete: () => _eliminarComentario(comentario.uid),
                );
              }).toList(),

            const SizedBox(height: 12),

            // Caja de nuevo comentario
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(authState.fotoPerfil),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _comentarioController,
                    decoration: InputDecoration(
                      hintText: "Añadir un comentario...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _crearComentario,
                      ),
                    ),
                    onSubmitted: (_) => _crearComentario(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para comentario
class _Comment extends StatelessWidget {
  final Comentario comentario;
  final bool isOwner;
  final VoidCallback onDelete;

  const _Comment({
    required this.comentario,
    required this.isOwner,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comentario.usuario.fotoPerfil),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${comentario.usuario.nombre} · ${_formatearFecha(comentario.createdAt)}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isOwner)
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red[400],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comentario.contenido,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(String fecha) {
    final now = DateTime.now();
    final dateTime = DateTime.parse(fecha);
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Hace un momento';
    }
  }
}
