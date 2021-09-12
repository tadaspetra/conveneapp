import 'package:flutter/material.dart';

import 'palette.dart';

class CustomTheme {
  static ThemeData lightTheme(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeData(
      primaryColor: Palette.niceBlack,
      scaffoldBackgroundColor: Palette.niceWhite,
      primaryTextTheme: theme.primaryTextTheme.apply(
        displayColor: Palette.niceBlack,
        bodyColor: Palette.niceBlack,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: Palette.niceWhite,
        iconTheme: IconThemeData(color: Palette.niceBlack),
      ),
      textTheme: theme.primaryTextTheme
          .copyWith(
            button: theme.primaryTextTheme.button?.copyWith(
              color: Palette.niceBlack,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
          .apply(
            displayColor: Palette.niceBlack,
            bodyColor: Palette.niceBlack,
          ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Palette.niceBlack),
    );
  }
}
