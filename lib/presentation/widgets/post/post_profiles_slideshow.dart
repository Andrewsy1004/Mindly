import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

class UserProfilesSlideshow extends StatelessWidget {
  const UserProfilesSlideshow({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    // Lista de usuarios con sus datos
    final List<Map<String, dynamic>> users = [
      {
        'name': 'Ana García',
        'role': 'Desarrolladora',
        'image':
            'https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZGUlMjBwZXJmaWx8ZW58MHx8MHx8fDA%3D',
      },
      {
        'name': 'Carlos López',
        'role': 'Diseñador UX',
        'image':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      },
      {
        'name': 'María Rodríguez',
        'role': 'Marketing Digital',
        'image':
            'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      },
      {
        'name': 'Juan Martínez',
        'role': 'Analista de Datos',
        'image':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      },
      {
        'name': 'Laura Sánchez',
        'role': 'Project Manager',
        'image':
            'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
      },
    ];

    return SizedBox(
      width: double.infinity,
      height: 120, // Altura para el diseño circular
      child: Swiper(
        viewportFraction: 0.3, // Más pequeño para mostrar varios círculos
        scale: 0.8,
        autoplay: true,
        loop: true,
        duration: 600,
        itemCount: users.length,
        itemBuilder: (context, index) => _UserCircleSlide(
          name: users[index]['name'],
          imageUrl: users[index]['image'],
          color: color,
        ),
      ),
    );
  }
}

class _UserCircleSlide extends StatelessWidget {
  final String name;
  final String imageUrl;
  final Color color;

  const _UserCircleSlide({
    required this.name,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/profileUser');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Círculo de perfil con efecto de elevación
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  // Imagen de perfil
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return Container(
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: color,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }
                      return child;
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: color, size: 30),
                    ),
                  ),

                  // Borde circular
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Nombre del usuario
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
