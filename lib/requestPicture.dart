import 'dart:io';

import 'package:aqarat_flutter_project/backend/email.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map.dart';

class RequestPicturePage extends StatefulWidget {
  final Locale myLocale;
  const RequestPicturePage({super.key, required this.myLocale});

  @override
  State<RequestPicturePage> createState() =>
      _RequestPicturePageState(MyLocale: myLocale);
}

class _RequestPicturePageState extends State<RequestPicturePage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _imagesSummaryController =
      TextEditingController();
  final TextEditingController _manualAddressController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];
  String username = usernameGlobal;
  LatLng? _selectedLatLng;
  String? _locationMapUrl;
  final Locale MyLocale;
  _RequestPicturePageState({required this.MyLocale});

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );
    if (picked != null) {
      setState(() {
        _dateController.text = '${picked.year}-${picked.month}-${picked.day}';
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isEmpty) {
      return;
    }
    setState(() {
      _selectedImages.addAll(images);
      _imagesSummaryController.text =
          '${_selectedImages.length} image(s) selected';
    });
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.of(context).push<SelectedLocation>(
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(initialLocation: _selectedLatLng),
      ),
    );
    if (result == null) {
      return;
    }
    setState(() {
      _selectedLatLng = result.latLng;
      _locationMapUrl = result.mapUrl;
      _locationController.text = result.displayName;
    });
  }

  Future<void> _openMapLink() async {
    if (_locationMapUrl == null) {
      return;
    }
    final uri = Uri.parse(_locationMapUrl!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map link')),
        );
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _imagesSummaryController.dispose();
    _manualAddressController.dispose();
    super.dispose();
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
        backgroundColor: const Color(0xffF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: const Color(0xff995858),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).RequestPictureSession,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff995858),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: Image.asset(
                  'images/bodFinal.png',
                  height: 220,
                  width: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  S.of(context).LetOurTeamCapture,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).RequestForm,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff111827),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FormInput(
                          controller: _dateController,
                          hintText: S.of(context).PrefferedDate,
                          icon: Icons.calendar_today_rounded,
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: 12),
                        _FormInput(
                          controller: _timeController,
                          hintText: S.of(context).PrefferedTime,
                          icon: Icons.access_time_rounded,
                          onTap: _pickTime,
                        ),
                        const SizedBox(height: 12),
                        _FormInput(
                          controller: _imagesSummaryController,
                          hintText: S.of(context).UploadPropertyImage,
                          icon: Icons.file_upload_outlined,
                          onTap: _pickImages,
                          readOnly: true,
                        ),
                        if (_selectedImages.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedImages.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    File(_selectedImages[index].path),
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),
                        _FormInput(
                          controller: _locationController,
                          hintText: S.of(context).SelectAddressOnMap,
                          icon: Icons.location_on_rounded,
                          onTap: _openLocationPicker,
                          readOnly: true,
                        ),
                        const SizedBox(height: 8),

                        if (_locationMapUrl != null) ...[
                          TextButton.icon(
                            onPressed: _openMapLink,
                            icon: const Icon(Icons.link),
                            label: Text(S.of(context).OpenSelectedLocation),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xff1E3A8A),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        _FormInput(
                          controller: _manualAddressController,
                          hintText: S.of(context).ManualAddressSet,
                          icon: Icons.edit_location_alt_outlined,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle form submission
                              sendEmailRequest(
                                username:
                                    username, // username of logged-in user
                                userEmail:
                                    userEmailGlobal, // email of logged-in user
                                preferredDate: _dateController.text
                                    .trim(), // date chosen
                                preferredTime: _timeController.text
                                    .trim(), // time chosen
                                position: _locationController.text
                                    .trim(), // selected address
                                note: _manualAddressController.text
                                    .trim(), // note or manual entry
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xff1D4ED8),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              S.of(context).SendRequest,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
}

class _FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final VoidCallback? onTap;
  final bool readOnly;

  const _FormInput({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly || onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xffF9FAFB),
        suffixIcon: Icon(icon, color: const Color(0xff9CA3AF)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xffE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xffE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xff2563EB)),
        ),
      ),
    );
  }
}
