import 'package:aqarat_flutter_project/askForLogin.dart';
import 'package:aqarat_flutter_project/backend/register.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:aqarat_flutter_project/login.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:aqarat_flutter_project/UserHomePage.dart';

class SignUp extends StatefulWidget {
  final Locale myLocale;
  const SignUp({super.key, required this.myLocale});
  @override
  State<SignUp> createState() => _SignUp(MyLocale: myLocale);
}

class _SignUp extends State<SignUp> {
  final Locale MyLocale;
  _SignUp({required this.MyLocale});
  final GlobalKey<FormState> Validation = GlobalKey();

  late String email;
  late String password;
  late String firstName;
  late String lastName;
  late String phone;
  late String username;
  bool _isLoading = false;
  String? usernameError;
  String? emailError;
  String? phoneError;

  Future<void> _showFeedbackDialog(String title, String message) async {
    if (!mounted) return;
    final isError = title == S.of(context).LoginFailed;
    final iconBg = isError ? const Color(0xffFEE2E2) : const Color(0xffDCFCE7);
    final iconColor = isError
        ? const Color(0xffDC2626)
        : const Color(0xff16A34A);
    final iconData = isError ? Icons.error_outline : Icons.check_circle_outline;

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
                  color: iconBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(iconData, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
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
                message,
                style: const TextStyle(color: Color(0xff374151), height: 1.4),
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isError
                      ? const Color(0xffDC2626)
                      : const Color(0xff2567E8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text(
                  'OK',
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => askForLogin(myLocale: MyLocale),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Color(0xff0F172A)),
                ),
                const SizedBox(height: 12),
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
                        S.of(context).SignUp,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
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
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 25,
                        color: Color(0x15000000),
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Form(
                    key: Validation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildField(
                          label: S.of(context).FirstName,
                          hint: S.of(context).EnterFirstName,
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => firstName = value!.trim(),
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          label: S.of(context).SecondName,
                          hint: S.of(context).EnterSecondName,
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => lastName = value!.trim(),
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          label: S.of(context).UserName,
                          hint: S.of(context).EnterYourUserName,
                          icon: Icons.person,
                          errorText: usernameError, // NEW
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => username = value!.trim(),
                        ),

                        const SizedBox(height: 14),
                        _buildField(
                          label: S.of(context).Email,
                          hint: S.of(context).EnterYourEmail,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          errorText: emailError, // NEW
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => email = value!.trim(),
                        ),

                        const SizedBox(height: 14),
                        _buildField(
                          label: S.of(context).PhoneNumber,
                          hint: S.of(context).EnterPhoneNumber,
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          errorText: phoneError, // NEW
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => phone = value!.trim(),
                        ),

                        const SizedBox(height: 14),
                        _buildField(
                          label: S.of(context).Password,
                          hint: S.of(context).EnterYourPassword,
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => password = value!.trim(),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2567E8),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (Validation.currentState!.validate()) {
                                    Validation.currentState!.save();
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    final result = await registerUser(
                                      username: username,
                                      password: password,
                                      firstName: firstName,
                                      lastName: lastName,
                                      email: email,
                                      phone: phone,
                                    );

                                    if (!mounted) return;
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    if (result.success) {
                                      setUsername(username, email, 1, "none");
                                      await persistUserSession(
                                        username: username,
                                        userEmail: email,
                                        accountValue: 1,
                                        subscribeStatus: "none",
                                      );

                                      setState(() {
                                        usernameError = null;
                                        emailError = null;
                                        phoneError = null;
                                      });

                                      await _showFeedbackDialog(
                                        S.of(context).SignUp,
                                        S.of(context).SignupSuccessful,
                                      );

                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                              ) => ChangeLocalee(
                                                myLocaly: MyLocale,
                                              ),
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
                                                        curve: Curves
                                                            .easeInOutCubic,
                                                      ),
                                                    ),
                                                  ),
                                                  child: child,
                                                );
                                              },
                                          transitionDuration: const Duration(
                                            milliseconds: 300,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // 🔥 HERE is where backend field errors belong
                                      setState(() {
                                        usernameError =
                                            result.field == "username"
                                            ? result.message
                                            : null;
                                        emailError = result.field == "email"
                                            ? result.message
                                            : null;
                                        phoneError = result.field == "phone"
                                            ? result.message
                                            : null;
                                      });

                                      await _showFeedbackDialog(
                                        S.of(context).LoginFailed,
                                        result.message,
                                      );
                                    }
                                  }
                                },
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  S.of(context).SignUp,
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
                              S.of(context).HaveAccount,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xff6B7280),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        loginPage(myLocale: MyLocale),
                                  ),
                                );
                              },
                              child: Text(
                                S.of(context).LoginIn,
                                style: const TextStyle(
                                  color: Color(0xff2567E8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
    String? errorText, // NEW!!
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff0F172A),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            filled: true,
            fillColor: const Color(0xffF9FAFB),

            errorText: errorText, // ← SHOW BACKEND ERROR HERE

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xff2567E8)),
            ),
          ),
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }
}
