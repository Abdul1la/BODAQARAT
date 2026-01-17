import 'package:aqarat_flutter_project/EditProfileInfoForOffice.dart';
import 'package:aqarat_flutter_project/backend/get_user.dart';
import 'package:aqarat_flutter_project/backend/userinfo.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:aqarat_flutter_project/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class OfficeAccountInfo extends StatefulWidget {
  final Locale myLocale;
  final String username;
  final String? city;
  final String? district;
  final String? dateOfBirth;
  final String? data;
  const OfficeAccountInfo({
    super.key,
    required this.myLocale,
    required this.username,
    this.city,
    this.district,
    this.dateOfBirth,
    this.data,
  });

  @override
  State<OfficeAccountInfo> createState() => _OfficeAccountInfoState();
}

class _OfficeAccountInfoState extends State<OfficeAccountInfo> {
  User? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      final fetched = await fetchUser(widget.username);
      if (!mounted) return;
      setState(() {
        userInfo = fetched;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
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
        backgroundColor: const Color(0xffF4F4F4),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (userInfo == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              S.of(context).UserNotFound,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadUserInfo,
              child: Text(S.of(context).Retry),
            ),
          ],
        ),
      );
    }

    final infoItems = [
      _InfoItem(label: S.of(context).UserName, value: userInfo!.username),
      _InfoItem(label: S.of(context).Email, value: userInfo!.email),
      _InfoItem(label: S.of(context).PhoneNumber, value: userInfo!.phoneNum),
      _InfoItem(label: S.of(context).City, value: userInfo!.city ?? "-"),
      _InfoItem(label: S.of(context).District, value: userInfo!.district ?? "-"),
      _InfoItem(
        label: S.of(context).DateOfBirth,
        value: widget.dateOfBirth ?? "-",
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffF7F8FD), Color(0xffFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              children: [
                _buildProfileCard(context),
                const SizedBox(height: 22),
                _buildInfoCard(context, infoItems),
                const SizedBox(height: 24),
                _buildEditButton(context),
                const SizedBox(height: 16),
                _buildDeleteButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final info = userInfo!;
    final profilePic = info.profilePic ?? '';
    final hasImage = profilePic.isNotEmpty;
    final profilePicUrl = hasImage
        ? "$profilePic?v=${DateTime.now().millisecondsSinceEpoch}"
        : null;
    final accent = Colors.white.withOpacity(0.18);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xff1D4ED8), Color(0xff2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 4,
              ),
            ),
            child: ClipOval(
              child: hasImage
                  ? Image.network(
                      profilePicUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${info.firstName} ${info.lastName}".trim(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            info.bio.isNotEmpty ? info.bio : info.email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xffE0E7FF),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildChip(Icons.phone_outlined, info.phoneNum),
              _buildChip(
                Icons.location_on_outlined,
                [
                  if ((info.city ?? '').isNotEmpty) info.city,
                  if ((info.district ?? '').isNotEmpty) info.district,
                ].whereType<String>().join(" • "),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<_InfoItem> infoItems) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).OfficeInformation,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff111827),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            infoItems.length,
            (index) => _InfoTile(
              item: infoItems[index],
              isLast: index == infoItems.length - 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff2567E8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 6,
          shadowColor: const Color(0xff2567E8).withOpacity(0.3),
        ),
        onPressed: () async {
          final shouldRefresh = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditProfileInfoForOffice(
                myLocale: widget.myLocale,
                data: widget.data,
                username: widget.username,
              ),
            ),
          );
          if (shouldRefresh == true) {
            await _loadUserInfo();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.edit_outlined, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              S.of(context).EditInformation,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xffDC2626),
          side: const BorderSide(color: Color(0xffDC2626), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () => _showDeleteConfirmation(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_outline, color: Color(0xffDC2626)),
            const SizedBox(width: 10),
            Text(
              S.of(context).DeleteAccount,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xffDC2626),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffDC2626).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xffDC2626),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                S.of(context).DeleteAccountTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xffDC2626),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).DeleteAccountConfirmation,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff111827),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).DeleteAccountWarning,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWarningItem(S.of(context).DeleteAccountWarningItem1),
                  _buildWarningItem(S.of(context).DeleteAccountWarningItem2),
                  _buildWarningItem(S.of(context).DeleteAccountWarningItem3),
                  _buildWarningItem(S.of(context).DeleteAccountWarningItem4),
                  _buildWarningItem(S.of(context).DeleteAccountWarningItem5),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xffDC2626).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xffDC2626),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      S.of(context).DeleteAccountInfo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xffDC2626),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff6B7280),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffDC2626),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              S.of(context).YesDeleteAccount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _deleteAccount(context);
    }
  }

  Widget _buildWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(
            Icons.remove,
            size: 16,
            color: Color(0xffDC2626),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xff6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await deleteAccount(widget.username);
      
      if (!mounted) return;
      
      Navigator.of(context).pop(); // Close loading dialog
      
      if (result["success"] == true) {
        // Clear user session
        await clearUserSession();
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).AccountDeletedSuccessfully),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to home/login screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ChangeLocale(myLocaly: widget.myLocale),
          ),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result["message"] ?? S.of(context).FailedToDeleteAccount),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildChip(IconData icon, String? text) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});
}

class _InfoTile extends StatelessWidget {
  final _InfoItem item;
  final bool isLast;
  const _InfoTile({super.key, required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              item.label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff6B7280),
                fontWeight: FontWeight.w600,
              ),
              softWrap: true,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            flex: 3,
            child: Text(
              item.value.isEmpty ? "-" : item.value,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xff111827),
                height: 1.4,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
