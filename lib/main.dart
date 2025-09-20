import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindly/presentation/presentation.dart';
import 'package:mindly/shared/shared.dart';
import 'config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initEnvironment();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeProvider);
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: appTheme.theme(),
      // theme: AppTheme().theme(),
    );
  }
}
