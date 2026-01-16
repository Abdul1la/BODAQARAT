import 'package:aqarat_flutter_project/app_theme.dart';
import 'package:aqarat_flutter_project/backend/emailRequest.dart';
import 'package:aqarat_flutter_project/flutter_notification.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class itemDetails extends StatefulWidget {
  final Locale myLocale;
  final String username;
  final int postID;
  final String profilePic;
  final String location;
  final String price;
  final int area;
  final int bedroom;
  final int bathroom;
  final int roomNum;
  final String discription;
  final String facade;
  final String condetion;
  final int floorNum;
  final String? phoneNum;
  final String city;
  final String address;
  final String state;
  final bool? available;
  final String image1;
  final String? image2;
  final String? image3;
  final String? image4;

  const itemDetails({
    super.key,
    required this.username,
    required this.profilePic,
    required this.location,
    required this.price,
    required this.area,
    required this.bedroom,
    required this.bathroom,
    required this.roomNum,
    required this.discription,
    required this.facade,
    required this.condetion,
    required this.floorNum,
    this.phoneNum,
    required this.postID,
    required this.city,
    required this.address,
    required this.state,
    required this.available,
    required this.image1,
    this.image2,
    this.image3,
    this.image4,
    required this.myLocale,
  });

  @override
  State<itemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<itemDetails> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _formatPrice(dynamic rawValue) {
    if (rawValue == null) return "--";
    final trimmed = rawValue.toString().trim();
    if (trimmed.isEmpty || trimmed == "--") return "--";
    return trimmed.startsWith("\$") ? trimmed : "\$$trimmed";
  }
  String currentUsername =
      usernameGlobal; // Placeholder for current user's username
  late final List<String> images = [
    widget.image1,
    if (widget.image2 != null) widget.image2!,
    if (widget.image3 != null) widget.image3!,
    if (widget.image4 != null) widget.image4!,
  ];

  Widget _buildOfficeAvatar() {
    final placeholder = CircleAvatar(
      radius: 32,
      backgroundColor: const Color(0xffE5E7EB),
      child: const Icon(Icons.business, color: Color(0xff2567E8), size: 28),
    );

    if (widget.profilePic.isEmpty) {
      return placeholder;
    }

    return SizedBox(
      width: 64,
      height: 64,
      child: ClipOval(
        child: Image.network(
          widget.profilePic,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }

  void _showRequestSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.assignment_turned_in,
                    color: Color(0xff2567E8),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      S.of(context).AreYouSureToContinue,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).AreYouSureForRequesting,
                style: const TextStyle(fontSize: 15, color: Color(0xff4B5563)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2567E8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final service = ProductRequestService();
                    // Notify immediately so the user gets instant feedback.
                    await LocalNotificationService.notifyRequestConfirmed(
                      context,
                      widget.username,
                    );
                    final result = await service.requestProduct(
                      buyerUsername:
                          currentUsername, // Replace with actual buyer username
                      postId: widget.postID,
                    );

                    Navigator.of(sheetCtx).pop();
                    final messenger = ScaffoldMessenger.of(context);
                    if (result['success'] == true) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            "${S.of(context).Confirm} - ${widget.username}",
                          ),
                        ),
                      );
                    } else {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            result['message']?.toString() ??
                                "Something went wrong",
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text(
                    S.of(context).SendRequest,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 4),
              color: Color(0x14000000),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xff2567E8)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 13, color: Color(0xff6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xff6B7280), fontSize: 15),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff111827),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String? _normalizeNumber(String? raw, {bool allowPlus = false}) {
    if (raw == null) return null;
    final pattern = allowPlus ? RegExp(r'[^\d+]') : RegExp(r'\D');
    var cleaned = raw.replaceAll(pattern, '');
    if (allowPlus && cleaned.isNotEmpty) {
      cleaned = '${cleaned.replaceAll('+', '')}';
    }
    return cleaned.isEmpty ? null : cleaned;
  }

  void _showContactSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _callNumber(String? rawNumber) async {
    final number = _normalizeNumber(rawNumber, allowPlus: true);
    if (number == null) {
      _showContactSnack("Phone number unavailable");
      return;
    }
    final telUri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(telUri)) {
      _showContactSnack("Could not open dialer");
    }
  }

  Future<void> _openWhatsApp(String? rawNumber) async {
    final number = _normalizeNumber(rawNumber);
    if (number == null) {
      _showContactSnack("Phone number unavailable");
      return;
    }
    final waUri = Uri.https('wa.me', '/$number');
    if (!await launchUrl(waUri, mode: LaunchMode.externalApplication)) {
      _showContactSnack("Could not open WhatsApp");
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      theme: AppTheme.theme,
      home: Scaffold(
        backgroundColor: const Color(0xffEEF2FF),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffEEF2FF),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xff111827),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            S.of(context).Discription,
            style: const TextStyle(color: Color(0xff111827)),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        offset: Offset(0, 8),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildOfficeAvatar(),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              widget.username,
                              style: const TextStyle(
                                color: Color(0xff0F172A),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xffF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xff2567E8),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${widget.city} / ${widget.address}",
                                      style: const TextStyle(
                                        color: Color(0xff475569),
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff2567E8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).Price,
                                  style: const TextStyle(
                                    color: Color(0xffDBEAFE),
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  _formatPrice(widget.price),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        offset: Offset(0, 8),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1.25,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            itemBuilder: (_, index) {
                              return Image.network(
                                images[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 70,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, index) {
                            final isActive = _currentPage == index;
                            return GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isActive
                                        ? const Color(0xff2567E8)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    images[index],
                                    width: 90,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 16 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: _currentPage == index
                                  ? const Color(0xff2567E8)
                                  : const Color(0xffCBD5F5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        offset: Offset(0, 8),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildStatCard(
                            icon: Icons.bed_outlined,
                            label: S.of(context).Bedroom,
                            value: widget.bedroom.toString(),
                          ),
                          _buildStatCard(
                            icon: Icons.bathtub_outlined,
                            label: S.of(context).Bathroom,
                            value: widget.bathroom.toString(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _buildStatCard(
                            icon: Icons.square_foot,
                            label: S.of(context).Area,
                            value: "${widget.area} m?",
                          ),
                          _buildStatCard(
                            icon: Icons.meeting_room_outlined,
                            label: S.of(context).RoomNumber,
                            value: widget.roomNum.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        offset: Offset(0, 8),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(S.of(context).Interface, widget.facade),
                      _buildInfoRow(S.of(context).Condition, widget.condetion),
                      _buildInfoRow(
                        S.of(context).Floors,
                        widget.floorNum.toString(),
                      ),
                      _buildInfoRow(
                        S.of(context).TowerAddress,
                        (widget.state != "Apartment") ? "N/A" : "Tower A",
                      ),
                      _buildInfoRow(
                        S.of(context).InWhichFloor,
                        (widget.state != "Apartment") ? "N/A" : "3rd Floor",
                      ),
                      _buildInfoRow(
                        S.of(context).OwnerPhoneNumber,
                        widget.phoneNum ?? "N/A",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        offset: Offset(0, 8),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).Discription,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.discription,
                        style: const TextStyle(
                          color: Color(0xff6B7280),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 15,
                        offset: Offset(0, 8),
                        color: Color(0x14000000),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).OwnerPhoneNumber,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.phoneNum ?? "N/A",
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xff2567E8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff111827),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () => _callNumber(widget.phoneNum),
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              label: Text(
                                S.of(context).CallNow,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff22C55E),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () => _openWhatsApp(widget.phoneNum),
                              icon: const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                              ),
                              label: Text(
                                S.of(context).WatsApp,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2567E8),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _showRequestSheet,
                    // request Button Here ---------------------------------------
                    child: Text(
                      S.of(context).RequestThis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
