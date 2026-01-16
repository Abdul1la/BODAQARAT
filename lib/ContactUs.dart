import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key, required this.myLocale});

  final Locale myLocale;

  final Uri _phoneUri = Uri(scheme: 'tel', path: '+9647509434455');
  final Uri _smsUri = Uri(scheme: 'sms', path: '+9647509434455');
  final Uri _emailUri = Uri(
    scheme: 'mailto',
    path: 'support@bodrealestate.com',
    query: 'subject=App%20Support',
  );
  final Uri _locationUri =
      Uri.parse('https://maps.app.goo.gl/nrUXxQ16Za625haN6');

  Future<void> _launchUri(
    BuildContext context,
    Uri uri, {
    bool isMapLink = false,
  }) async {
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isMapLink
                ? S.of(context).CouldntOpenMapLink
                : S.of(context).CouldntOpenWebsite,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(S.of(context).ContactUs),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff2563EB),
                      Theme.of(context).primaryColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.support_agent_rounded,
                        size: 48,
                        color: Color(0xff2563EB),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      S.of(context).ContactUs,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        S.of(context).YouCanContact,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    child: Column(
                      children: [
                        _buildContactTile(
                          context: context,
                          icon: Icons.sms_rounded,
                          title: S.of(context).Message,
                          subtitle:
                              S.of(context).YouCanContact,
                          onTap: () => _launchUri(context, _smsUri),
                        ),
                        const Divider(height: 0),
                        _buildContactTile(
                          context: context,
                          icon: Icons.phone_rounded,
                          title: S.of(context).PhoneNumber,
                          subtitle: '+964 750 123 4567',
                          onTap: () => _launchUri(context, _phoneUri),
                        ),
                        const Divider(height: 0),
                        _buildContactTile(
                          context: context,
                          icon: Icons.mail_outline_rounded,
                          title: S.of(context).Email,
                          subtitle: 'bodaqarat@gmail.com',
                          onTap: () => _launchUri(context, _emailUri),
                        ),
                        const Divider(height: 0),
                        _buildContactTile(
                          context: context,
                          icon: Icons.location_on_outlined,
                          title: S.of(context).Location,
                          subtitle: S.of(context).ViewlocationOnMap,
                          onTap: () => _launchUri(
                            context,
                            _locationUri,
                            isMapLink: true,
                          ),
                        ),
                      ],
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

  Widget _buildContactTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final color = Theme.of(context).primaryColor;
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
              size: 18,
            )
          : null,
    );
  }
}
