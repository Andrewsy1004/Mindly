import 'package:dio/dio.dart';

import 'package:mindly/domain/domain.dart';
import 'package:mindly/config/config.dart';
import 'package:mindly/infrastructure/infrastructure.dart';

class PostDatasourceImpl extends PostDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<List<Post>> getPosts() async {
    try {
      final response = await dio.get('/posts/post-usuario');

      final List postsJson = response.data['posts'] ?? [];

      final List<Post> posts = postsJson
          .map((postJson) => PostMapper.postJsonToEntity(postJson))
          .toList();

      return posts;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Post>> getRecommendedPosts(String token) async {
    try {
      final response = await dio.get(
        '/posts/post-recomendados',
        options: Options(headers: {'jsonwebtoken': token}),
      );

      final List postsJson = response.data['posts'] ?? [];

      final List<Post> posts = postsJson
          .map((postJson) => PostMapper.postJsonToEntity(postJson))
          .toList();

      return posts;
    } catch (e) {
      print('Error en getRecommendedPosts: $e');
      throw Exception();
    }
  }

  @override
  Future<void> deletePost(String token, String postId) async {
    try {
      final response = await dio.delete(
        '/posts/eliminar-post/$postId',
        options: Options(headers: {'jsonwebtoken': token}),
      );

      return response.data;
    } catch (e) {
      throw Exception('Error al eliminar post: $e');
    }
  }

  @override
  Future<void> createPost(String token, Post post) async {
    try {
      final response = await dio.post(
        '/posts/crear-post',
        data: {
          'titulo': post.titulo,
          'descripcion': post.descripcion,
          'imagen': post.imagen,
          'categoria': post.categoria,
          'tags': post.tags,
        },
        options: Options(headers: {'jsonwebtoken': token}),
      );

      return response.data;
    } catch (e) {
      throw Exception('Error al crear post: $e');
    }
  }
}
