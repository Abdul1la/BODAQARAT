import 'package:aqarat_flutter_project/HomePage.dart';
import 'package:aqarat_flutter_project/SignUpUser.dart';
import 'package:aqarat_flutter_project/UserHomePage.dart';
import 'package:aqarat_flutter_project/app_theme.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:aqarat_flutter_project/ifAqarOffice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class askForLogin extends StatefulWidget {
  final Locale myLocale;
  const askForLogin({super.key, required this.myLocale});
  @override
  State<askForLogin> createState() => _AskForLogin(MyLocale: myLocale);
}

class _AskForLogin extends State<askForLogin> {
  final Locale MyLocale;
  _AskForLogin({required this.MyLocale});
  // global key for form
  GlobalKey<FormState> Validation = GlobalKey();

  // variable to save email to data base:
  String? email;
  // variable to save password to data base:
  String? password;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: MyLocale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: AppTheme.theme,
      home: Scaffold(
        backgroundColor: const Color(0xffEEF2FF),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    final target = (AccountValue ?? 0) == 0
                        ? ChangeLocale(myLocaly: MyLocale)
                        : ChangeLocalee(myLocaly: MyLocale);
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            target,
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          final tween = Tween(
                            end: end,
                            begin: begin,
                          ).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 400),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Color(0xff0F172A)),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff2567E8), Color(0xff1E40AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x330D3B66),
                        blurRadius: 20,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).UserOrAqarOwner,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).LoginToYourAccount,
                        style: const TextStyle(
                          color: Color(0xffE0E7FF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 20,
                        color: Color(0x15000000),
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _RoleButton(
                        title: S.of(context).User,
                        subtitle: S.of(context).LoginToYourAccount,
                        icon: Icons.person_outline,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUp(myLocale: MyLocale),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      _RoleButton(
                        title: S.of(context).AqarOwner,
                        subtitle: S.of(context).LoginToYourAccount,
                        icon: Icons.apartment_outlined,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  SignUpScreen(MYLocale: MyLocale),
                            ),
                          );
                        },
                      ),
                    ],
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

class _RoleButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xffF8FAFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xffE5E7EB)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xff2567E8).withOpacity(0.1),
              child: Icon(icon, color: const Color(0xff2567E8)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xff94A3B8)),
          ],
        ),
      ),
    );
  }
}
