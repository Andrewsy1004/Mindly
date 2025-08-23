import 'package:flutter/material.dart';

const ColorList = <Color>[
  Color(0xFF0D80F2),
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

class AppTheme {
  final int selectedColor;
  final bool darkMode;

  AppTheme({this.selectedColor = 0, this.darkMode = false})
    : assert(
        selectedColor >= 0,
        'Color must be between 0 and ${ColorList.length - 1}',
      ),
      assert(
        selectedColor < ColorList.length,
        'Color must be between 0 and ${ColorList.length - 1}',
      );

  ThemeData theme() {
    final seedColor = ColorList[selectedColor];

    return ThemeData(
      useMaterial3: true,
      brightness: darkMode ? Brightness.dark : Brightness.light,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: darkMode ? Brightness.dark : Brightness.light,
          ).copyWith(
            primary: seedColor,
            onPrimary: Colors.white,
            secondary: seedColor,
          ),
    );
  }

  AppTheme copyWith({int? selectedColor, bool? darkMode}) => AppTheme(
    selectedColor: selectedColor ?? this.selectedColor,
    darkMode: darkMode ?? this.darkMode,
  );
}
