import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mindly/config/theme/app_theme.dart';

final isDarkModeProvider = StateProvider<bool>((ref) => false);

final colorListProvider = Provider((ref) => ColorList);
final selectedColorProvider = StateProvider<int>((ref) => 0);

final appThemeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(darkMode: !state.darkMode);
  }

  void changeColor(int color) {
    state = state.copyWith(selectedColor: color);
  }
}
