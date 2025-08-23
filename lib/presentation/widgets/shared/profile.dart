import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatefulWidget {
  static const name = 'profile';
  final bool isOwner;

  const Profile({super.key, this.isOwner = false});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  // Lista de posts
  final List<Map<String, dynamic>> allPosts = [
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/fondo-abstracto-tecnologia_23-2148907685.jpg",
      "title": "Análisis de datos",
      "subtitle": "Explorando datos",
      "likes": 120,
      "liked": true,
      "id": 1,
    },
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/infografia-analisis-datos-graficos-estadisticos_52683-84209.jpg",
      "title": "Modelos predictivos",
      "subtitle": "Creando modelos",
      "likes": 98,
      "liked": false,
      "id": 2,
    },
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/plantilla-presentacion-big-data_23-2148944034.jpg",
      "title": "Machine Learning",
      "subtitle": "Aprendizaje automático",
      "likes": 150,
      "liked": true,
      "id": 3,
    },
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/analisis-datos-abstracto_52683-84881.jpg",
      "title": "Big Data",
      "subtitle": "Gestión de datos",
      "likes": 87,
      "liked": false,
      "id": 4,
    },
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/machine-learning-ilustracion_23-2149223680.jpg",
      "title": "Estadística",
      "subtitle": "Análisis avanzado",
      "likes": 64,
      "liked": false,
      "id": 5,
    },
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/visualizacion-datos-estadisticos_23-2148890935.jpg",
      "title": "Visualización",
      "subtitle": "Datos en gráficos",
      "likes": 132,
      "liked": true,
      "id": 6,
    },
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/fondo-abstracto-tecnologia_23-2148907685.jpg",
      "title": "IA Avanzada",
      "subtitle": "Inteligencia artificial",
      "likes": 89,
      "liked": false,
      "id": 7,
    },
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/infografia-analisis-datos-graficos-estadisticos_52683-84209.jpg",
      "title": "Deep Learning",
      "subtitle": "Redes neuronales",
      "likes": 156,
      "liked": true,
      "id": 8,
    },
    // Agregué más posts para mejor demostración
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/fondo-abstracto-tecnologia_23-2148907685.jpg",
      "title": "Python Analytics",
      "subtitle": "Programación en Python",
      "likes": 75,
      "liked": false,
      "id": 9,
    },
    {
      "imageUrl":
          "https://img.freepik.com/vector-gratis/infografia-analisis-datos-graficos-estadisticos_52683-84209.jpg",
      "title": "Data Mining",
      "subtitle": "Minería de datos",
      "likes": 112,
      "liked": true,
      "id": 10,
    },
  ];

  // Lista de favoritos
  Set<int> favorites = {1, 3, 6, 8}; // Algunos favoritos por defecto

  // Función para toggle favorito
  void toggleFavorite(int postId) {
    setState(() {
      if (favorites.contains(postId)) {
        favorites.remove(postId);
      } else {
        favorites.add(postId);
      }
    });
  }

  // Función para toggle like
  void toggleLike(int postId) {
    setState(() {
      final post = allPosts.firstWhere((p) => p['id'] == postId);
      if (post['liked']) {
        post['likes']--;
        post['liked'] = false;
      } else {
        post['likes']++;
        post['liked'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    // Filtrar posts favoritos
    final favoritePosts = allPosts
        .where((post) => favorites.contains(post['id']))
        .toList();

    return DefaultTabController(
      length: 2,
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
              const CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(
                  "https://cdn-icons-png.flaticon.com/512/2202/2202112.png",
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ethan Carter",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text("@ethan_c", style: TextStyle(color: Colors.grey)),
              const Text(
                "Científico de datos",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 15),

              if (widget.isOwner)
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CounterItem(
                    label: "Publicaciones",
                    value: "${allPosts.length}",
                  ),
                  const _CounterItem(label: "Seguidores", value: "100"),
                  const _CounterItem(label: "Siguiendo", value: "250"),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Soy un científico de datos apasionado por el análisis "
                  "de datos y la creación de modelos predictivos. "
                  "Me encanta aprender nuevas técnicas y colaborar en proyectos innovadores.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Intereses",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text("Machine Learning")),
                  Chip(label: Text("Big Data")),
                  Chip(label: Text("Estadística")),
                ],
              ),
              const SizedBox(height: 20),
              const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: "Publicaciones"),
                  Tab(text: "Favoritos"),
                ],
              ),
              // OPTIMIZADO: Mejor altura y espaciado
              Container(
                height: MediaQuery.of(context).size.height * 0.65, // Más altura
                child: TabBarView(
                  children: [
                    // Tab de Publicaciones - ESPACIADO OPTIMIZADO
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4, // REDUCIDO de 8 a 4
                              crossAxisSpacing: 6, // REDUCIDO de 8 a 6
                              childAspectRatio: 0.85, // MEJORADO de 0.75 a 0.85
                            ),
                        itemCount: allPosts.length,
                        itemBuilder: (context, index) {
                          final post = allPosts[index];
                          return _OptimizedPostCard(
                            imageUrl: post["imageUrl"],
                            title: post["title"],
                            subtitle: post["subtitle"],
                            likes: post["likes"],
                            liked: post["liked"],
                            isFavorite: favorites.contains(post["id"]),
                            onLikePressed: () => toggleLike(post["id"]),
                            onFavoritePressed: () => toggleFavorite(post["id"]),
                          );
                        },
                      ),
                    ),
                    // Tab de Favoritos
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: favoritePosts.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "No tienes favoritos aún",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Toca el ⭐ en tus posts favoritos",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 6,
                                    childAspectRatio: 0.85,
                                  ),
                              itemCount: favoritePosts.length,
                              itemBuilder: (context, index) {
                                final post = favoritePosts[index];
                                return _OptimizedPostCard(
                                  imageUrl: post["imageUrl"],
                                  title: post["title"],
                                  subtitle: post["subtitle"],
                                  likes: post["likes"],
                                  liked: post["liked"],
                                  isFavorite: true,
                                  onLikePressed: () => toggleLike(post["id"]),
                                  onFavoritePressed: () =>
                                      toggleFavorite(post["id"]),
                                );
                              },
                            ),
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
}

class _CounterItem extends StatelessWidget {
  final String label;
  final String value;
  const _CounterItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// NUEVA: Card optimizada para menor espacio y mejor diseño
class _OptimizedPostCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final int likes;
  final bool liked;
  final bool isFavorite;
  final VoidCallback onLikePressed;
  final VoidCallback onFavoritePressed;

  const _OptimizedPostCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.likes,
    this.liked = false,
    this.isFavorite = false,
    required this.onLikePressed,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            flex: 7, // Más espacio para imagen
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // Botón de favorito optimizado
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
          // Contenido de texto - MÁS COMPACTO
          Expanded(
            flex: 3, // Menos espacio para texto
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
                          title,
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
                          subtitle,
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
                  // Likes en la parte inferior
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onLikePressed,
                        child: Icon(
                          Icons.favorite,
                          size: 14,
                          color: liked ? Colors.red : Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$likes",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
