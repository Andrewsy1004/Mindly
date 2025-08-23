import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:animate_do/animate_do.dart';

class PostTopicsSlideshow extends StatelessWidget {
  const PostTopicsSlideshow({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    // Lista de temas con sus respectivos iconos
    final List<Map<String, dynamic>> topics = [
      {'title': 'Tecnología', 'icon': Icons.computer},
      {'title': 'Salud', 'icon': Icons.favorite},
      {'title': 'Viajes', 'icon': Icons.flight_takeoff},
      {'title': 'Deportes', 'icon': Icons.sports_basketball},
      {'title': 'Cultura', 'icon': Icons.theater_comedy},
      {'title': 'Tecnología', 'icon': Icons.computer},
      {'title': 'Salud', 'icon': Icons.favorite},
      {'title': 'Viajes', 'icon': Icons.flight_takeoff},
      {'title': 'Deportes', 'icon': Icons.sports_basketball},
      {'title': 'Cultura', 'icon': Icons.theater_comedy},
    ];

    return SizedBox(
      width: double.infinity,
      height: 70, // Altura ajustada para texto e icono
      child: Swiper(
        viewportFraction: 0.4, // Más estrecho para mejor visualización
        scale: 0.9,
        autoplay: true,
        loop: true, // Para que no se trabe al final
        duration: 800,
        itemCount: topics.length,
        itemBuilder: (context, index) => _Slide(
          title: topics[index]['title'],
          icon: topics[index]['icon'],
          color: color,
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _Slide({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.withOpacity(0.1), color.withOpacity(0.2)],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
