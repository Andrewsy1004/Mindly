import 'package:mindly/domain/domain.dart';

abstract class PostDatasource {
  Future<List<Post>> getPosts();
  Future<List<Post>> getRecommendedPosts(String token);
}
