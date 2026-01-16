import 'dart:math';

import 'package:aqarat_flutter_project/backend/login.dart'
    show SubscriptionInfo;
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class SubscriptionStatePage extends StatelessWidget {
  final String status;
  final DateTime paidAt;
  final DateTime expiresAt;
  final Locale myLocale;
  final int cycleDays;

  SubscriptionStatePage({
    super.key,
    required this.status,
    required this.paidAt,
    required this.expiresAt,
    this.cycleDays = 30,
    required this.myLocale,
  });

  factory SubscriptionStatePage.fromSubscriptionInfo(
    SubscriptionInfo info, {
    int cycleDays = 30,
  }) {
    final DateTime expiry = info.endDate != null
        ? DateTime.tryParse(info.endDate!) ?? DateTime.now()
        : DateTime.now();
    final DateTime paymentMoment = expiry.subtract(Duration(days: cycleDays));
    return SubscriptionStatePage(
      status: info.status,
      paidAt: paymentMoment,
      expiresAt: expiry,
      cycleDays: cycleDays, myLocale: null!,
      
    );
  }

  String get _statusLabel => status.isEmpty ? 'Unknown' : status;

  int get _daysRemaining {
    final remaining = expiresAt.difference(DateTime.now()).inDays;
    return max(0, remaining);
  }

  int get _daysElapsed {
    final elapsed = DateTime.now().difference(paidAt).inDays;
    return max(0, elapsed);
  }

  double get _progress {
    final total = max(1, cycleDays);
    return (_daysElapsed / total).clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('EEE, d MMM yyyy • hh:mm a');

    return MaterialApp(
      locale: myLocale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).PlansAndSubscription,
            style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1D4ED8), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SubscriptionStatusCard(
                    status: _statusLabel,
                    daysLeft: _daysRemaining,
                    progress: _progress,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  _InfoTile(
                    icon: Icons.calendar_today_rounded,
                    title: S.of(context).LastPayment,
                    value: formatter.format(paidAt),
                    theme: theme,
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: Icons.schedule_rounded,
                    title: S.of(context).ExpiresOn,
                    value: formatter.format(expiresAt),
                    theme: theme,
                  ),
                  const SizedBox(height: 12),
                  _InfoTile(
                    icon: Icons.timelapse_rounded,
                    title: S.of(context).CycleLength,
                    value: "$cycleDays " + S.of(context).Day,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  _TimelineCard(
                    paidAt: paidAt,
                    expiresAt: expiresAt,
                    remainingDays: _daysRemaining,
                    theme: theme,
                  ),
                  const SizedBox(height: 24),
                  _ActionCard(onManage: () => Navigator.of(context).pop()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionStatusCard extends StatelessWidget {
  final String status;
  final int daysLeft;
  final double progress;
  final ThemeData theme;

  const _SubscriptionStatusCard({
    required this.status,
    required this.daysLeft,
    required this.progress,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase().contains('Active');
    final gradientColors = isActive
        ? [const Color(0xFF22C55E), const Color(0xFF16A34A)]
        : [const Color(0xFFF97316), const Color(0xFFDC2626)];

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 90,
            width: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  daysLeft > 0
                      ? '$daysLeft days remaining'
                      : 'Renew to keep access',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    daysLeft > 0 ? S.of(context).onTrack : S.of(context).Expired,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final ThemeData theme;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF1D4ED8)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final DateTime paidAt;
  final DateTime expiresAt;
  final int remainingDays;
  final ThemeData theme;

  const _TimelineCard({
    required this.paidAt,
    required this.expiresAt,
    required this.remainingDays,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('d MMM, yyyy');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).TimeLine,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).Paid,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatter.format(paidAt),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      S.of(context).ExpiresOn,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatter.format(expiresAt),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.hourglass_bottom_rounded,
                  color: Color(0xFF1E40AF),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    remainingDays > 0
                        ? '$remainingDays ' + S.of(context).DaysLeft
                        : S.of(context).SubscriptionExpired,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final VoidCallback onManage;

  const _ActionCard({required this.onManage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            S.of(context).NeedToMakeChanges,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).ManageYourSubscription,
            style: TextStyle(color: Color(0xFF475569)),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: onManage,
              child: Text(
                S.of(context).ManageSubscription,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
