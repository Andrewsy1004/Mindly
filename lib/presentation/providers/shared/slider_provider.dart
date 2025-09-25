import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindly/domain/domain.dart';
import 'package:mindly/infrastructure/infrastructure.dart';
import 'package:mindly/shared/shared.dart';

final usersSliderProvider =
    StateNotifierProvider<UsersSliderNotifier, UsersSliderState>((ref) {
      final userRepository = AuthRepositoryImpl();
      final keyValueStorageService = KeyValueStorageServices();

      return UsersSliderNotifier(
        keyValueStorageService: keyValueStorageService,
        userRepository: userRepository,
      );
    });

class UsersSliderNotifier extends StateNotifier<UsersSliderState> {
  final AuthRepository userRepository;
  final KeyValueStorageServices keyValueStorageService;

  UsersSliderNotifier({
    required this.userRepository,
    required this.keyValueStorageService,
  }) : super(UsersSliderState()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    final token = await keyValueStorageService.getToken();
    state = state.copyWith(isLoading: true);

    try {
      final users = await userRepository.getAllUsersWithSimilarity(token!);

      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar usuarios',
      );
    }
  }
}

class UsersSliderState {
  final List<User> users;
  final bool isLoading;
  final String errorMessage;

  UsersSliderState({
    this.users = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  UsersSliderState copyWith({
    List<User>? users,
    bool? isLoading,
    String? errorMessage,
  }) => UsersSliderState(
    users: users ?? this.users,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
