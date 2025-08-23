import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:mindly/presentation/presentation.dart';

class PostMasonry extends StatefulWidget {
  const PostMasonry({super.key});

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

  final List<String> postImages = [
    "https://img.freepik.com/vector-gratis/ilustracion-concepto-publicacion-blog_114360-26355.jpg",
    "https://img.freepik.com/foto-gratis/blogger-hombre-trabajando-computadora-portatil_23-2148720078.jpg",
    "https://img.freepik.com/vector-gratis/ilustracion-concepto-redes-sociales_114360-1432.jpg",
    "https://img.freepik.com/vector-gratis/ilustracion-concepto-articulos-blog_114360-7963.jpg",
    "https://img.freepik.com/foto-gratis/concepto-diseno-web-desarrollador_23-2149247161.jpg",
    "https://img.freepik.com/foto-gratis/persona-escribiendo-computadora-portatil_23-2147915629.jpg",
    "https://img.freepik.com/vector-gratis/ilustracion-concepto-marketing-digital_114360-1595.jpg",
    "https://img.freepik.com/vector-gratis/ilustracion-concepto-aplicaciones-moviles_114360-5220.jpg",
    "https://img.freepik.com/vector-gratis/ilustracion-concepto-ciberseguridad_114360-1099.jpg",
    "https://img.freepik.com/foto-gratis/mujer-usando-portatil-blogger_23-2148898562.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: 10,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 40),
                PostCardLink(imageUrl: postImages[index]),
              ],
            );
          }
          return PostCardLink(imageUrl: postImages[index]);
        },
      ),
    );
  }
}
