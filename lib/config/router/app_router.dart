import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindly/config/router/app_router_notifier.dart';

import 'package:mindly/presentation/presentation.dart';
// import 'package:mindly/shared/shared.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authStatus = notifier.authStatus;
      final location = state.uri.path;
      final publicRoutes = ['/', '/signin', '/signup'];
      final isPublicRoute = publicRoutes.contains(location);

      // Si aún está verificando, mantener en splash
      if (authStatus == AuthStatus.checking && location != '/') {
        return '/';
      }

      // Si no está autenticado y trata de acceder a ruta privada
      if (authStatus == AuthStatus.notAuthenticated && !isPublicRoute) {
        return '/signin';
      }

      // Si está autenticado y trata de acceder a login/registro
      if (authStatus == AuthStatus.authenticated &&
          (location == '/signin' || location == '/signup')) {
        return '/home/0';
      }

      return null;
    },
    routes: [
      // ... tus rutas existentes
      GoRoute(
        path: '/',
        name: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: Signup.name,
        builder: (context, state) => const Signup(),
      ),
      GoRoute(
        path: '/signin',
        name: Sigin.name,
        builder: (context, state) => const Sigin(),
      ),
      GoRoute(
        path: '/home/:page',
        name: HomeScreen.name,
        builder: (context, state) {
          final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
          final isOwner = true;
          return HomeScreen(pageIndex: pageIndex, isOwner: isOwner);
        },
      ),
      GoRoute(
        path: '/profile/edit',
        name: ProfileEdit.name,
        builder: (context, state) => const ProfileEdit(),
      ),
      GoRoute(
        path: '/profileUser/:id',
        name: Profile.name,
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return Profile(userId);
        },
      ),
      GoRoute(
        path: '/post/:id',
        name: PostScreen.name,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PostScreen(id: id);
        },
      ),
    ],
  );
});
