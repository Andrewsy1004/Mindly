import 'package:go_router/go_router.dart';

import 'package:mindly/presentation/presentation.dart';
import 'package:mindly/shared/shared.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final bool isLoggedIn = await KeyValueStorageServices().isUserLoggedIn();
    final String location = state.uri.path;

    final publicRoutes = ['/', '/signin', '/signup'];
    final isPublicRoute = publicRoutes.contains(location);

    // Si no tiene token y trata de acceder a ruta privada
    if (!isLoggedIn && !isPublicRoute) {
      return '/signin';
    }

    // Si tiene token y trata de acceder a login/registro
    if (isLoggedIn && (location == '/signin' || location == '/signup')) {
      return '/home/0';
    }

    return null;
  },
  routes: [
    // Splash
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

    // Home (requiere token)
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        final isOwner = true;
        return HomeScreen(pageIndex: pageIndex, isOwner: isOwner);
      },
    ),

    // Profile Edit (requiere token)
    GoRoute(
      path: '/profile/edit',
      name: ProfileEdit.name,
      builder: (context, state) => const ProfileEdit(),
    ),

    // Profile User (requiere token)
    GoRoute(
      path: '/profileUser',
      name: Profile.name,
      builder: (context, state) => const Profile(),
    ),

    // Post Screen (requiere token)
    GoRoute(
      path: '/post/:id',
      name: PostScreen.name,
      builder: (context, state) => const PostScreen(),
    ),
  ],
);
