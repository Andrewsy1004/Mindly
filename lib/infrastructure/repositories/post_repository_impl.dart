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
}
