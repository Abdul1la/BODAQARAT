import 'package:aqarat_flutter_project/backend/payment.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/global.dart' as global;
import 'package:aqarat_flutter_project/flutter_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

class PaymentPage extends StatefulWidget {
  final Locale MyLocale;
  final int? initialAmount;
  final int targetAccountValue;

  const PaymentPage({
    Key? key,
    required this.MyLocale,
    this.initialAmount,
    required this.targetAccountValue,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState(MYLocale: MyLocale);
}

enum _PaymentResolution { success, failed, pending }

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final TextEditingController _amountController;
  final TextEditingController _descriptionController = TextEditingController(
    text: "BOD AQARAT",
  );
  final Locale MYLocale;
  _PaymentPageState({required this.MYLocale});

  bool _isLoading = false;
  String _statusMessage = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String? _currentPaymentId;
  bool _waitingForConfirmation = false;
  bool _checkingStatus = false;
  String get _planLabel => 'Plan ${widget.targetAccountValue}';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 👇 initialize controller with passed amount or default value
    _amountController = TextEditingController(
      text: (widget.initialAmount ?? 10000).toString(),
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _amountController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  @override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed &&
      _waitingForConfirmation &&
      _currentPaymentId != null &&
      !_checkingStatus) {
    // ⏱️ انتظر 2 ثانية قبل الفحص (لإعطاء الخادم وقتاً)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _waitingForConfirmation) {
        _checkPaymentStatus();
      }
    });
  }
}

  Future<void> _initiatePayment() async {
    if (_amountController.text.isEmpty) {
      _showSnackBar(S.of(context).TheAmount, isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = S.of(context).PreparingPayment;
    });

    try {
      final response = await http.post(
        Uri.parse('https://bodaqarat.com/flutter_fib_api/create_payment.php'),
        body: {
          'amount': _amountController.text,
          'description': _descriptionController.text,
        },
      );

      print('🌍 Server Response (${response.statusCode}): ${response.body}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['paymentId'] != null) {
        setState(() {
          _statusMessage = S.of(context).PaymentSuccessfull;
          _currentPaymentId = data['paymentId'].toString();
          _waitingForConfirmation = true;
        });
        await _handlePaymentRedirect(data);
        _showSnackBar(
          S.of(context).CompleteThePaymentInFibApp,
        );
      } else if (data['error'] != null) {
        _showSnackBar('Error: ${data['error']}', isError: true);
      } else {
        _showSnackBar('Unexpected server response', isError: true);
      }
    } catch (e) {
      _showSnackBar('Connection error: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePaymentRedirect(Map<String, dynamic> data) async {
    print('===== 🔗 Available Payment Links =====');
    print('personalAppLink: ${data['personalAppLink']}');
    print('businessAppLink: ${data['businessAppLink']}');
    print('corporateAppLink: ${data['corporateAppLink']}');
    print('=====================================');

    String? link = data['personalAppLink'];
    String? readableCode = data['readableCode'];

    if (link == null) {
      _showSnackBar('No valid payment link found', isError: true);
      return;
    }

    List<String> deepLinkSchemes = [
      'fibpersonal://onlinePayment?identifier=$readableCode&redirectUri=${Uri.encodeComponent(link)}',
      'fib://onlinePayment?identifier=$readableCode',
      'fibpay://onlinePayment?identifier=$readableCode',
    ];

    bool appOpened = false;

    for (String deepLink in deepLinkSchemes) {
      print('🚀 Trying deep link: $deepLink');
      appOpened = await _tryOpenFIBApp(deepLink);
      if (appOpened) {
        print('✅ Successfully opened FIB app');
        return;
      }
    }

    print('🌐 Opening web payment link in external browser: $link');
    await _openInExternalBrowser(link);
  }

  Future<void> _checkPaymentStatus() async {
  if (_currentPaymentId == null) return;

  setState(() {
    _checkingStatus = true;
    _statusMessage = S.of(context).CheckPaymentStatus;
  });

  try {
    final uri = Uri.parse(
      'https://bodaqarat.com/flutter_fib_api/check_status.php?paymentId=$_currentPaymentId',
    );
    final response = await http.get(uri);

    print('📥 Status Check Response (${response.statusCode}): ${response.body}');

    if (response.statusCode != 200) {
      _showSnackBar(
        'فشل التحقق من الدفع (${response.statusCode}). حاول مرة أخرى.',
        isError: true,
      );
      return;
    }

    final Map<String, dynamic> payload = jsonDecode(response.body);
    final _PaymentResolution resolution = _resolvePaymentResolution(payload);

    if (resolution == _PaymentResolution.success) {
      print('✅ Payment confirmed as SUCCESS');
      await _finalizeSuccessfulPayment();
      
    } else if (resolution == _PaymentResolution.failed) {
      print('❌ Payment confirmed as FAILED');
      setState(() {
        _waitingForConfirmation = false;
        _currentPaymentId = null;
      });
      await LocalNotificationService.notifyPaymentStatus(
        context,
        success: false,
        planName: _planLabel,
      );
      _showSnackBar(
        S.of(context).PaymentFailed,
        isError: true,
      );
      
    } else {
      // 🔴 PENDING - لا تفعل شيئاً، اطلب من المستخدم الانتظار
      print('⏳ Payment still PENDING');
      _showSnackBar(
        S.of(context).PaymentStillProcessing,
      );
    }
  } catch (e) {
    print('❌ Error checking payment: $e');
    _showSnackBar('فشل التحقق من الدفع: $e', isError: true);
  } finally {
    setState(() {
      _checkingStatus = false;
    });
  }
}
  static const Set<String> _statusKeyHints = {
    'success',
    'issuccess',
    'completed',
    'iscompleted',
    'issucceeded',
    'status',
    'paymentstatus',
    'transactionstatus',
    'state',
    'statuscode',
    'code',
    'currentstatus',
    'resultcode',
  };

  static const List<String> _successTokens = [
    'SUCCESS',
    'SUCCEEDED',
    'APPROVED',
    'APPROVE',
    'COMPLETED',
    'CONFIRMED',
    'PAID',
    'DONE',
    'FINISHED',
    'VERIFIED',
  ];

  static const List<String> _failureTokens = [
    'FAILED',
    'REJECT',
    'DECLINED',
    'CANCEL',
    'ERROR',
    'EXPIRED',
  ];

  _PaymentResolution _resolvePaymentResolution(Map<String, dynamic> payload) {
  print('🔍 Full API Response: $payload'); // للتشخيص
  
  // 1️⃣ ابحث عن حقل الحالة الأساسي
  final status = payload['status']?.toString().toUpperCase() ?? '';
  final paymentStatus = payload['paymentStatus']?.toString().toUpperCase() ?? '';
  final transactionStatus = payload['transactionStatus']?.toString().toUpperCase() ?? '';
  
  // 2️⃣ تحقق من الحالات الصريحة فقط
  if (status == 'COMPLETED' || 
      status == 'SUCCESS' || 
      paymentStatus == 'COMPLETED' ||
      transactionStatus == 'SUCCESS') {
    return _PaymentResolution.success;
  }
  
  if (status == 'FAILED' || 
      status == 'REJECTED' || 
      status == 'CANCELLED' ||
      paymentStatus == 'FAILED') {
    return _PaymentResolution.failed;
  }
  
  // 3️⃣ أي شيء آخر = لا يزال معلقاً
  return _PaymentResolution.pending;
}

  _PaymentResolution? _walkPaymentNodes(dynamic node, [String parentKey = '']) {
    if (node is Map<String, dynamic>) {
      for (final entry in node.entries) {
        final normalizedKey = entry.key.toLowerCase();
        final value = entry.value;
        final res = _evaluatePaymentValue(normalizedKey, value);
        if (res != null && res != _PaymentResolution.pending) {
          return res;
        }
        final nested = _walkPaymentNodes(value, normalizedKey);
        if (nested != null && nested != _PaymentResolution.pending) {
          return nested;
        }
      }
    } else if (node is List) {
      for (final value in node) {
        final nested = _walkPaymentNodes(value, parentKey);
        if (nested != null && nested != _PaymentResolution.pending) {
          return nested;
        }
      }
    }
    return null;
  }

  _PaymentResolution? _evaluatePaymentValue(String key, dynamic value) {
    if (value is bool && _looksLikeStatusKey(key)) {
  return value ? _PaymentResolution.success : _PaymentResolution.failed;
}
    if (value is num && _statusKeyHints.contains(key)) {
      if (value == 1 || value == 200) return _PaymentResolution.success;
      if (value == 0) return _PaymentResolution.pending;
      if (value < 0) return _PaymentResolution.failed;
    }
    if (value is String) {
      final normalized = value.trim().toUpperCase();
      if (normalized.isEmpty) return null;
      if (_looksLikeStatusKey(key) || _looksLikeStatusValue(normalized)) {
        if (_successTokens.any(normalized.contains)) {
          return _PaymentResolution.success;
        }
        if (_failureTokens.any(normalized.contains)) {
          return _PaymentResolution.failed;
        }
      }
    }
    return null;
  }

  bool _looksLikeStatusKey(String key) {
    return _statusKeyHints.any((hint) => key.contains(hint));
  }

  bool _looksLikeStatusValue(String normalizedValue) {
    return _successTokens.any(normalizedValue.contains) ||
        _failureTokens.any(normalizedValue.contains) ||
        normalizedValue.contains('PENDING') ||
        normalizedValue.contains('PROCESS');
  }

  Future<void> _finalizeSuccessfulPayment() async {
    setState(() {
      _waitingForConfirmation = false;
      _currentPaymentId = null;
    });
    // 1️⃣ Update backend first
    final upgradeResult = await upgradeSubscription(
      global.usernameGlobal,
      widget.targetAccountValue,
    );
    // store the value to data base --------------------------------------------

    await global.persistUserSession(
      username: global.usernameGlobal,
      userEmail: global.userEmailGlobal,
      accountValue: widget.targetAccountValue,
      subscribeStatus: global.SubscribeStatus,
    );

    if (!mounted) return;
    if (!upgradeResult.success) {
      _showSnackBar(
        'Payment verified, but updating your subscription failed: ${upgradeResult.message}',
        isError: true,
      );
      return;
    }

    // 2️⃣ Update local app state AFTER backend success
    setState(() {
      global.AccountValue = widget.targetAccountValue;
      global.SubscribeStatus = "active"; // ✅ lowercase, consistent
    });

    // 3️⃣ Persist session
    await global.persistUserSession(
      username: global.usernameGlobal,
      userEmail: global.userEmailGlobal,
      accountValue: widget.targetAccountValue,
      subscribeStatus: global.SubscribeStatus,
    );
    await LocalNotificationService.notifyPaymentStatus(
      context,
      success: true,
      planName: _planLabel,
    );
    _showSnackBar(S.of(context).PaymentVefified);
  }

  Future<bool> _tryOpenFIBApp(String deepLink) async {
    try {
      final Uri uri = Uri.parse(deepLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return true;
      } else {
        print('⚠️ Cannot open deep link: $deepLink');
        return false;
      }
    } catch (e) {
      print('❌ Cannot open deep link: $deepLink');
      return false;
    }
  }

  Future<void> _openInExternalBrowser(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        print(S.of(context).SuccessfullyOpenedBrowser);
      } else {
        print('❌ Failed to open browser');
        _showSnackBar('Could not open payment page', isError: true);
      }
    } catch (e) {
      print('❌ Error opening browser: $e');
      _showSnackBar('Error: $e', isError: true);
    }
  }

  void _openPaymentInWebView(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWebView(url: url, myLocale: MYLocale),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          S.of(context).Payment,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildPaymentCard(),
                  const SizedBox(height: 20),
                  _buildPaymentButton(),
                  if (_waitingForConfirmation) ...[
                    const SizedBox(height: 12),
                    _buildConfirmationCard(),
                  ],
                  const SizedBox(height: 12),
                  _buildTrustRow(),
                  if (_isLoading) ...[
                    const SizedBox(height: 24),
                    _buildLoadingIndicator(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.lock_rounded, color: Colors.white, size: 34),
        ),
        const SizedBox(height: 16),
        Text(
          S.of(context).SequrePayment,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          S.of(context).PaySavelyWithFIB,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85)),
        ),
      ],
    );
  }

  Widget _buildPaymentCard() {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.blue.shade100, width: 1.2),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _amountController,
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: S.of(context).Amount,
                  prefixIcon: const Icon(Icons.payments_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: baseBorder,
                  enabledBorder: baseBorder,
                  focusedBorder: baseBorder.copyWith(
                    borderSide: BorderSide(
                      color: Colors.blue.shade400,
                      width: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: S.of(context).Discription,
                  prefixIcon: const Icon(Icons.description_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: baseBorder,
                  enabledBorder: baseBorder,
                  focusedBorder: baseBorder.copyWith(
                    borderSide: BorderSide(
                      color: Colors.blue.shade400,
                      width: 1.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading || _waitingForConfirmation
            ? null
            : _initiatePayment,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue.shade700,
          elevation: 3,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(Icons.lock_outline_rounded, color: Colors.white),
        label: Text(
          S.of(context).ProceedToPay,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).ReturnAfterPayment,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(S.of(context).TapAfterCompleteingPayment),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _checkingStatus ? null : _checkPaymentStatus,
              child: Text(
                _checkingStatus
                    ? S.of(context).Checking
                    : S.of(context).CheckPaymentStatus,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.6),
            ),
            const SizedBox(width: 12),
            Text(
              _statusMessage,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user_rounded,
          color: Colors.white.withOpacity(0.9),
          size: 18,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 250,
          child: Text(
            S.of(context).SecuredBy256_bitEncryption,
            style: TextStyle(color: Colors.white.withOpacity(0.9)),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}

class PaymentWebView extends StatefulWidget {
  final String url;
  final Locale myLocale;

  const PaymentWebView({Key? key, required this.url, required this.myLocale})
    : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            if (request.url.contains(
              'https://bodaqarat.com/flutter_fib_api/success.php',
            )) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).PaymentSuccess),
                  backgroundColor: Colors.green,
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: widget.myLocale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).FIBPayment),
          backgroundColor: Colors.blue.shade700,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
