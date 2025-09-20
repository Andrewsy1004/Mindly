import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindly/domain/domain.dart';
import 'package:mindly/infrastructure/infrastructure.dart';
import 'package:mindly/shared/shared.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServices();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageServices keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Credenciales incorrectas !');
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.saveToken(user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.logout();

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getToken();
    if (token == null) return logout();

    // try {
    //   final user = await authRepository.checkAuthStatus(token);
    //   _setLoggedUser(user);
    // } catch (e) {
    //   logout();
    // }
  }

  Future<void> registerUser(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      final user = await authRepository.register(email, password, fullName);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    }
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
