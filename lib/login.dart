import 'package:aqarat_flutter_project/HomePage.dart';
import 'package:aqarat_flutter_project/UserHomePage.dart';
import 'package:aqarat_flutter_project/app_theme.dart';
import 'package:aqarat_flutter_project/backend/forgetpass.dart';
import 'package:aqarat_flutter_project/backend/login.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:aqarat_flutter_project/officeHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:aqarat_flutter_project/SignUpUser.dart';
import 'package:aqarat_flutter_project/askForLogin.dart';
import 'package:http/http.dart' as http;

class loginPage extends StatefulWidget {
  final Locale myLocale;
  const loginPage({super.key, required this.myLocale});
  @override
  State<loginPage> createState() => _LoginPage(MyLocale: myLocale);
}

class _LoginPage extends State<loginPage> {
  final Locale MyLocale;
  _LoginPage({required this.MyLocale});
  // global key for form
  GlobalKey<FormState> Validation = GlobalKey();

  // variable to save email to data base:
  String username = '';
  // variable to save password to data base:
  String password = '';
  int accountId = 0;
  String _message = ""; // to show API message in screen
  bool _isSubmitting = false;
  String subscribeStatus = "";

  void _handleLogin() async {
    final result = await loginUser(username, password);

    if (!mounted) return;

    setState(() {
      _message = result.message; // Login message
      if (result.success) {
        accountId = result.accountId ?? 0;
        username = result.username ?? "";
      }
    });
  }

  void testConnection() async {
    try {
      final url = Uri.parse("http://192.168.1.7:8000/test-db");
      final response = await http.get(url);
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
    } catch (e) {
      print("ERROR: $e");
    }
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
    final resolvedMessage = message.isEmpty
        ? S.of(context).InvalidPassOrUser
        : message;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        final width = MediaQuery.of(dialogCtx).size.width;
        final maxWidth = width > 420 ? 420.0 : width * 0.92;

        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
          actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: const Color(0xffFEE2E2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Color(0xffDC2626),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  S.of(context).LoginFailed,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xff111827),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              child: Text(
                resolvedMessage,
                style: const TextStyle(color: Color(0xff374151), height: 1.4),
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2567E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController usernameController = TextEditingController(
      text: username,
    );

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(S.of(context).ForgetPassword),
          content: TextField(
            controller: usernameController,
            decoration: InputDecoration(
              hintText: S.of(context).EnterYourUserName,
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(S.of(context).Cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);

                try {
                  await requestPasswordReset(usernameController.text);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Reset Password Email Sent")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Something Went Wrong")),
                  );
                }
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }

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
                  icon: const Icon(Icons.arrow_back, color: Color(0xff0F172A)),
                  onPressed: () {
                    final rootNavigator = Navigator.of(
                      context,
                      rootNavigator: true,
                    );
                    rootNavigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => askForLogin(myLocale: MyLocale),
                      ),
                    );
                  },
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
                        S.of(context).LoginToYourAccount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        S.of(context).EnterYourUserName,
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
                        blurRadius: 25,
                        offset: Offset(0, 12),
                        color: Color(0x15000000),
                      ),
                    ],
                  ),
                  child: Form(
                    key: Validation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          S.of(context).UserName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person_outline),
                            hintText: S.of(context).EnterYourUserName,
                            filled: true,
                            fillColor: const Color(0xffF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xff2567E8),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => username = value!.trim(),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          S.of(context).Password,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: S.of(context).EnterYourPassword,
                            filled: true,
                            fillColor: const Color(0xffF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(
                                color: Color(0xff2567E8),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => password = value!.trim(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _showForgotPasswordDialog,
                            child: Text(
                              S.of(context).ForgetPassword,
                              style: const TextStyle(
                                color: Color(0xff2567E8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2567E8),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _isSubmitting
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  if (Validation.currentState!.validate()) {
                                    Validation.currentState!.save();
                                    setState(() {
                                      _isSubmitting = true;
                                    });

                                    final result = await loginUser(
                                      username,
                                      password,
                                    );

                                    if (!mounted) return;
                                    setState(() {
                                      _isSubmitting = false;
                                      _message = result.message;
                                    });

                                    if (result.success) {
                                      setUsername(
                                        result.username!,
                                        result.userEmail!,
                                        result.accountId!,
                                        result.subscription?.status ?? "none",
                                      );
                                      await persistUserSession(
                                        username: result.username!,
                                        userEmail: result.userEmail!,
                                        accountValue: result.accountId!,
                                        subscribeStatus:
                                            result.subscription?.status ??
                                            "none",
                                      );

                                      final acc = result.accountId ?? 1;

                                      Widget nextPage;
                                      if (acc == 1) {
                                        nextPage = ChangeLocalee(
                                          myLocaly: MyLocale,
                                        );
                                      } else {
                                        // account_id 2,3,4 → office / agent UI
                                        nextPage = ChangeOfficeLocale(
                                          myLocaly: MyLocale,
                                        );
                                      }

                                      final route = PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => nextPage,
                                        transitionsBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                              child,
                                            ) {
                                              return SlideTransition(
                                                position: animation.drive(
                                                  Tween(
                                                    begin: const Offset(
                                                      1.0,
                                                      0.0,
                                                    ),
                                                    end: Offset.zero,
                                                  ).chain(
                                                    CurveTween(
                                                      curve:
                                                          Curves.easeInOutCubic,
                                                    ),
                                                  ),
                                                ),
                                                child: child,
                                              );
                                            },
                                        transitionDuration: const Duration(
                                          milliseconds: 300,
                                        ),
                                      );

                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pushAndRemoveUntil(
                                        route,
                                        (route) => false,
                                      );
                                    } else {
                                      await _showErrorDialog(result.message);
                                    }
                                  }
                                },
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  S.of(context).LoginIn,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).DontHaveAccount,
                              style: const TextStyle(
                                color: Color(0xff6B7280),
                                fontSize: 13,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SignUp(myLocale: MyLocale),
                                  ),
                                );
                              },
                              child: Text(
                                S.of(context).SignUp,
                                style: const TextStyle(
                                  color: Color(0xff2567E8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_message.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff9CA3AF),
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
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
