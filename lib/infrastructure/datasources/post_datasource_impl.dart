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
}
