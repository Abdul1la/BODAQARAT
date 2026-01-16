import 'package:aqarat_flutter_project/HomePage.dart';
import 'package:aqarat_flutter_project/UserHomePage.dart';
import 'package:aqarat_flutter_project/app_theme.dart';
import 'package:aqarat_flutter_project/flutter_notification.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:aqarat_flutter_project/navigation.dart';
import 'package:aqarat_flutter_project/officeHomePage.dart';
import 'package:aqarat_flutter_project/theme_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();
  await restoreUserSession();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Locale _defaultLocale = const Locale('ps');
  bool _showSplash = true;
  ThemeMode _themeMode = ThemeMode.light;
  static const _themePrefKey = 'app_theme_mode';

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themePrefKey);
    if (!mounted) return;
    setState(() {
      _themeMode = _stringToThemeMode(stored) ?? ThemeMode.light;
    });
  }

  ThemeMode? _stringToThemeMode(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  Future<void> _updateThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themePrefKey,
      mode == ThemeMode.dark
          ? 'dark'
          : mode == ThemeMode.light
          ? 'light'
          : 'system',
    );
    if (!mounted) return;
    setState(() {
      _themeMode = mode;
    });
  }

  Widget _resolveHome() {
    switch (AccountValue) {
      case 0:
        return ChangeLocale(myLocaly: _defaultLocale);
      case 1:
        return ChangeLocalee(myLocaly: _defaultLocale);
      case 2:
        return ChangeOfficeLocale(myLocaly: _defaultLocale);
      case 3:
        return ChangeOfficeLocale(myLocaly: _defaultLocale);
      case 4:
        return ChangeOfficeLocale(myLocaly: _defaultLocale);
      default:
        return ChangeLocale(myLocaly: _defaultLocale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: rootNavigatorKey,
      theme: AppTheme.theme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      locale: _defaultLocale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      routes: {
        ThemeSettingsPage.routeName: (_) => ThemeSettingsPage(
          currentMode: _themeMode,
          onModeChanged: _updateThemeMode,
        ),
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: _showSplash ? const _SplashScreen() : _resolveHome(),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffF7F0E8), Color(0xffFDF8EE), Color(0xffEEF2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 18),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    'images/bodFinal.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: const Color(0xffE0E7FF),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.home_work_rounded,
                        color: Color(0xff1E3A8A),
                        size: 48,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'BoD Real Estate',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crafting homes for modern living',
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.4,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 30),
                const SizedBox(
                  width: 90,
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: Color(0xffE0E7FF),
                    valueColor: AlwaysStoppedAnimation(Color(0xff6366F1)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
