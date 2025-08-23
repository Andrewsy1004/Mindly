import 'package:go_router/go_router.dart';

import 'package:mindly/presentation/presentation.dart';

final appRouter = GoRouter(
  initialLocation: '/',
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

    // Home
    GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        final isOwner = true;

        return HomeScreen(pageIndex: pageIndex, isOwner: isOwner);
      },
    ),

    // Favorites
    GoRoute(
      path: '/profile/edit',
      name: ProfileEdit.name,
      builder: (context, state) => const ProfileEdit(),
    ),

    // Usuarios
    GoRoute(
      path: '/profileUser',
      name: Profile.name,
      builder: (context, state) => const Profile(),
    ),

    // Post Screen
    GoRoute(
      path: '/post/:id',
      name: PostScreen.name,
      builder: (context, state) => const PostScreen(),
    ),

    GoRoute(path: '/', redirect: (_, __) => '/home/0'),
  ],
);
