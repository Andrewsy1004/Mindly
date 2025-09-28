import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mindly/presentation/presentation.dart';

class PostScreen extends ConsumerWidget {
  static const name = 'post-screen';
  final String id;
  const PostScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postsProvider);
    final recommendedPosts = postsState.allPosts;
    final authState = ref.read(authProvider).user;

    // Buscar el post que coincide con el id
    final post = recommendedPosts.firstWhere((p) => p.uid == id);

    // Verificar si el post fue ceado por el usuario actual
    final isOwner = post.usuario.uid == authState!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
            ), // o Icons.favorite si ya está marcado
            onPressed: () {
              // aquí manejas el like
            },
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
                // Título
                Text(
                  post.titulo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // Autor + Fecha en la misma fila
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
                              fontSize: 14, // un poco más grande
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

            // const SizedBox(height: 12),

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
                    onPressed: () {},
                    child: const Text(
                      "Eliminar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
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

            // Texto del post
            const Text(
              "La vida sostenible ya no es un concepto de nicho, "
              "sino un movimiento creciente que está remodelando cómo interactuamos con nuestro planeta. "
              "Desde hogares ecológicos hasta consumo consciente, el futuro de la vida sostenible se trata de "
              "crear un equilibrio armonioso entre las necesidades humanas y la preservación del medio ambiente...",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            // const SizedBox(height: 16),

            // Likes y comentarios
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     // Likes
            //     Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Icon(
            //           Icons.favorite_border,
            //           size: 20,
            //           color: Colors.grey[600],
            //         ),
            //         const SizedBox(width: 4),
            //         Text(
            //           "123",
            //           style: TextStyle(color: Colors.grey[600], fontSize: 14),
            //         ),
            //       ],
            //     ),

            //     // Comments
            //     Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Icon(
            //           Icons.chat_bubble_outline,
            //           size: 20,
            //           color: Colors.grey[600],
            //         ),
            //         const SizedBox(width: 4),
            //         Text(
            //           "45",
            //           style: TextStyle(color: Colors.grey[600], fontSize: 14),
            //         ),
            //       ],
            //     ),

            //     // Share
            //     Icon(Icons.redo, size: 20, color: Colors.grey[600]),
            //   ],
            // ),

            // const Divider(height: 32),
            const SizedBox(height: 32),

            // Sección de comentarios
            const Text(
              "Comentarios",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _Comment(
              name: "Ethan Carter",
              time: "Hace 2 días",
              text:
                  "Excelente artículo. Estoy particularmente interesado en las nuevas energías renovables mencionadas.",
            ),
            _Comment(
              name: "Sofía Bernart",
              time: "Hace 1 día",
              text:
                  "¡Gracias Ethan! Sí, creo que los desarrollos más recientes en energía solar son muy prometedores.",
            ),

            const SizedBox(height: 12),

            // Caja de nuevo comentario
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=47",
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
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
                    ),
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
  final String name;
  final String time;
  final String text;

  const _Comment({required this.name, required this.time, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
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
                        "$name · $time",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red[400],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
