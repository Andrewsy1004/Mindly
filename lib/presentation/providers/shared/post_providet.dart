import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindly/domain/domain.dart';
import 'package:mindly/infrastructure/infrastructure.dart';
import 'package:mindly/shared/shared.dart';

/// Provider global
final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  final postsRepository = PostRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServices();

  return PostsNotifier(
    postsRepository: postsRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

/// Notifier
class PostsNotifier extends StateNotifier<PostsState> {
  final PostRepositoryImpl postsRepository;
  final KeyValueStorageServices keyValueStorageService;

  PostsNotifier({
    required this.postsRepository,
    required this.keyValueStorageService,
  }) : super(PostsState()) {
    loadData();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);

    final token = await keyValueStorageService.getToken();

    try {
      final posts = await postsRepository.getPosts();
      final recommendedPosts = await postsRepository.getRecommendedPosts(
        token!,
      );

      state = state.copyWith(
        allPosts: posts,
        recommendedPosts: recommendedPosts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> AgregarFavorito(Post post) async {
    try {
      state = state.copyWith(isLoading: true);

      // await postsRepository.addFavoritePost(post);
      state = state.copyWith(isLoading: false, errorMessage: '');
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}

/// State
class PostsState {
  final List<Post> allPosts;
  final List<Post> favoritePosts;
  final List<Post> recommendedPosts;
  final bool isLoading;
  final String errorMessage;

  PostsState({
    this.allPosts = const [],
    this.favoritePosts = const [],
    this.recommendedPosts = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  PostsState copyWith({
    List<Post>? allPosts,
    List<Post>? favoritePosts,
    List<Post>? recommendedPosts,
    bool? isLoading,
    String? errorMessage,
  }) => PostsState(
    allPosts: allPosts ?? this.allPosts,
    favoritePosts: favoritePosts ?? this.favoritePosts,
    recommendedPosts: recommendedPosts ?? this.recommendedPosts,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
