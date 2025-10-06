import 'package:mindly/domain/domain.dart';
import 'package:mindly/infrastructure/infrastructure.dart';

class PostRepositoryImpl extends PostRepository {
  final PostDatasource datasource;

  PostRepositoryImpl({PostDatasource? datasource})
    : datasource = datasource ?? PostDatasourceImpl();

  @override
  Future<List<Post>> getPosts() {
    return datasource.getPosts();
  }

  @override
  Future<List<Post>> getRecommendedPosts(String token) {
    return datasource.getRecommendedPosts(token);
  }

  @override
  Future<void> deletePost(String token, String postId) {
    return datasource.deletePost(token, postId);
  }

  @override
  Future<void> createPost(String token, Post post) {
    return datasource.createPost(token, post);
  }

  @override
  Future<void> updatePost(String token, Post post) {
    return datasource.updatePost(token, post);
  }
}
