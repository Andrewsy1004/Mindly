import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';

class PostScrollVerticalSliver extends StatefulWidget {
  const PostScrollVerticalSliver({super.key});

  @override
  State<PostScrollVerticalSliver> createState() =>
      _PostScrollVerticalSliverState();
}

class _PostScrollVerticalSliverState extends State<PostScrollVerticalSliver> {
  final List<Map<String, dynamic>> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadInitialPosts();
  }

  Future<void> _loadInitialPosts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final newPosts = _generatePosts(0, 10);
    if (mounted) {
      setState(() {
        _posts.addAll(newPosts);
        _isLoading = false;
        _currentPage = 1;
      });
    }
  }

  Future<void> _loadMorePosts() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 2));

    final newPosts = _generatePosts(_currentPage, 10);

    if (mounted) {
      setState(() {
        _posts.addAll(newPosts);
        _isLoadingMore = false;
        _currentPage++;

        if (_currentPage >= 3) {
          _hasMore = false;
        }
      });
    }
  }

  List<Map<String, dynamic>> _generatePosts(int page, int count) {
    final categories = [
      'Tecnología',
      'Viajes',
      'Cocina',
      'Desarrollo personal',
      'Salud',
      'Deportes',
    ];
    final authors = [
      'Amelia Harper',
      'Lucas Bennett',
      'Chloe Foster',
      'Owen Carter',
      'Emma Wilson',
      'Noah Thompson',
    ];
    final dates = [
      '20 de mayo',
      '18 de mayo',
      '15 de mayo',
      '12 de mayo',
      '10 de mayo',
      '8 de mayo',
    ];

    return List.generate(count, (index) {
      final globalIndex = page * count + index;
      return {
        'category': categories[globalIndex % categories.length],
        'title': _generatePostTitle(globalIndex % categories.length),
        'author': authors[globalIndex % authors.length],
        'date': dates[globalIndex % dates.length],
        'color': _getCategoryColor(globalIndex % categories.length),
      };
    });
  }

  String _generatePostTitle(int categoryIndex) {
    final titles = [
      'El futuro de la IA en la atención médica',
      'Explorando las maravillas ocultas de Islandia',
      'Recetas de verano refrescantes y fáciles',
      'Construyendo hábitos saludables para una vida equilibrada',
      'Los beneficios del ejercicio regular para la salud mental',
      'Tendencias actuales en el mundo del fitness',
    ];
    return titles[categoryIndex];
  }

  Color _getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[index];
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Tecnología':
        return Icons.computer;
      case 'Viajes':
        return Icons.flight_takeoff;
      case 'Cocina':
        return Icons.restaurant;
      case 'Desarrollo personal':
        return Icons.psychology;
      case 'Salud':
        return Icons.favorite;
      case 'Deportes':
        return Icons.fitness_center;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _posts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
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

        final postIndex = index - 1; // Restar 1 por el título

        // Si llegamos cerca del final, cargar más posts
        if (postIndex == _posts.length - 2 && _hasMore && !_isLoadingMore) {
          _loadMorePosts();
        }

        // Mostrar posts
        if (postIndex < _posts.length) {
          return _buildPostItem(_posts[postIndex]);
        }

        // Mostrar loader al final
        if (postIndex == _posts.length) {
          return _buildLoader();
        }

        return null;
      }, childCount: _posts.length + 1 + (_hasMore || _isLoadingMore ? 1 : 0)),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    return GestureDetector(
      onTap: () {
        context.push('/post/1');
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
                  color: post['color'].withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Fondo con color de categoría
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              post['color'].withOpacity(0.3),
                              post['color'].withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                      // Icono representativo basado en la categoría
                      Center(
                        child: Icon(
                          _getCategoryIcon(post['category']),
                          size: 60,
                          color: post['color'].withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
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
                      post['category'],
                      style: TextStyle(
                        color: post['color'],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Título
                    Text(
                      post['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Autor y fecha
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Por ${post['author']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post['date'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
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

  Widget _buildLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Center(
        child: _isLoadingMore
            ? Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Text(
                    'Cargando más posts...',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              )
            : !_hasMore
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'No hay más posts para mostrar',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
