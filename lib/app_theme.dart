import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorSchemeSeed: const Color(0xff1E3A8A),
    scaffoldBackgroundColor: const Color(0xfff7f8fc),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ModernPageTransitionsBuilder(),
        TargetPlatform.iOS: ModernPageTransitionsBuilder(),
        TargetPlatform.windows: ModernPageTransitionsBuilder(),
        TargetPlatform.macOS: ModernPageTransitionsBuilder(),
        TargetPlatform.linux: ModernPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ModernPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorSchemeSeed: const Color(0xff60a5fa),
    scaffoldBackgroundColor: const Color(0xff0f172a),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ModernPageTransitionsBuilder(),
        TargetPlatform.iOS: ModernPageTransitionsBuilder(),
        TargetPlatform.windows: ModernPageTransitionsBuilder(),
        TargetPlatform.macOS: ModernPageTransitionsBuilder(),
        TargetPlatform.linux: ModernPageTransitionsBuilder(),
        TargetPlatform.fuchsia: ModernPageTransitionsBuilder(),
      },
    ),
  );
}

class ModernPageTransitionsBuilder extends PageTransitionsBuilder {
  const ModernPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation);
    final scale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeIn,
      ),
    );

    return FadeTransition(
      opacity: fade,
      child: ScaleTransition(scale: scale, child: child),
    );
  }
}
