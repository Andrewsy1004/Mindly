import 'package:mindly/domain/domain.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<List<Post>> getRecommendedPosts(String token);
}
