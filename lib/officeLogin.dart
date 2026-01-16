import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:aqarat_flutter_project/SignUpUser.dart';
import 'package:aqarat_flutter_project/askForLogin.dart';

class OfficeLogin extends StatefulWidget {
  final Locale myLocale;
  const OfficeLogin({super.key, required this.myLocale});
  @override
  State<OfficeLogin> createState() => _officeLogin(MyLocale: myLocale);
}

class _officeLogin extends State<OfficeLogin> {
  final Locale MyLocale;
  _officeLogin({required this.MyLocale});
  final GlobalKey<FormState> Validation = GlobalKey();

  String? email;
  String? password;
  bool _isSubmitting = false;

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xffDC2626)),
            const SizedBox(width: 8),
            Text(
              S.of(context).LoginFailed,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Color(0xff4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
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
                        S.of(context).LoginToYourAccount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        S.of(context).EnterYourEmail,
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
                        Text(
                          S.of(context).Email,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            hintText: S.of(context).EnterYourEmail,
                            filled: true,
                            fillColor: const Color(0xffF9FAFB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: const BorderSide(color: Color(0xff2567E8)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => email = value?.trim(),
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
                        const SizedBox(height: 6),
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
                              borderSide: const BorderSide(color: Color(0xff2567E8)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).FillthisFieldPlease;
                            }
                            return null;
                          },
                          onSaved: (value) => password = value?.trim(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              S.of(context).ForgetPassword,
                              style: const TextStyle(color: Color(0xff2567E8)),
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
                                  if (Validation.currentState!.validate()) {
                                    Validation.currentState!.save();
                                    setState(() {
                                      _isSubmitting = true;
                                    });

                                    await Future.delayed(const Duration(milliseconds: 600));
                                    if (!mounted) return;
                                    setState(() {
                                      _isSubmitting = false;
                                    });

                                    await _showErrorDialog(
                                      S.of(context).LoginFailed,
                                    );
                                  }
                                },
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  S.of(context).LoginIn,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
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
                                fontSize: 13,
                                color: Color(0xff6B7280),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(myLocale: MyLocale),
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
