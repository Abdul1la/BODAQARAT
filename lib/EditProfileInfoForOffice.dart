import 'dart:io';
import 'package:aqarat_flutter_project/backend/get_user.dart';
import 'package:aqarat_flutter_project/backend/userinfo.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileInfoForOffice extends StatefulWidget {
  final Locale myLocale;
  final String username;
  final String? data;
  const EditProfileInfoForOffice({
    super.key,
    required this.myLocale,
    required this.username,
    required this.data,
  });

  @override
  State<EditProfileInfoForOffice> createState() =>
      _EditProfileInfoForOfficeState();
}

class _EditProfileInfoForOfficeState extends State<EditProfileInfoForOffice> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // office display name that should be stored to data base ------------
  final TextEditingController _nameController = TextEditingController();
  // office email address to data base ------------------
  final TextEditingController _emailController = TextEditingController();
  // primary phone/contact number -------------------------
  final TextEditingController _phoneController = TextEditingController();
  // city/location of the office ------------------------
  final TextEditingController _cityController = TextEditingController();
  // district/address line for the office ------------------------
  final TextEditingController _districtController = TextEditingController();
  // date of birth/registration to store --------------------------
  final TextEditingController _dobController = TextEditingController();

  User? userInfo;
  bool isLoading = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final fetched = await fetchUser(widget.username);
      if (!mounted) return;
      setState(() {
        userInfo = fetched;
        isLoading = false;
      });
      _fillControllers();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void _fillControllers() {
    if (userInfo == null) return;
    _nameController.text = "${userInfo!.firstName} ${userInfo!.lastName}";
    _emailController.text = userInfo!.email;
    _phoneController.text = userInfo!.phoneNum;
    _cityController.text = userInfo!.city ?? "None";
    _districtController.text = userInfo!.district ?? "Erbil";
    _dobController.text = "18/03/2024";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _dobController.dispose();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 4),
              Text(
                S.of(context).EditInformation,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffB3473A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffE5D4C5),
                    ),
                    child: ClipOval(child: _buildProfilePreview()),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField(S.of(context).Name + "*", _nameController),
                  const SizedBox(height: 18),
                  _buildTextField(S.of(context).Email + "*", _emailController),
                  const SizedBox(height: 18),
                  _buildTextField(
                    S.of(context).PhoneNumber + "*",
                    _phoneController,
                    prefix: _phonePrefix(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xffE5E5E5),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(S.of(context).Cancel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xff2567E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _saveChanges(
                    userInfo!.username,
                    _nameController.text.split(
                      " ",
                    )[0], // First name placeholder
                    _nameController.text.split(" ").length > 1
                        ? _nameController.text.split(" ")[1]
                        : "", // Last name placeholder
                    _emailController.text,
                    _phoneController.text,
                    profileImage: _selectedImage,
                  ),
                  child: Text(
                    S.of(context).SaveChanges,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    Widget? prefix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF8F8F8),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 12, right: 6),
                    child: prefix,
                  )
                : null,
            prefixIconConstraints: prefix != null
                ? const BoxConstraints(minWidth: 0)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _phonePrefix() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("+964", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF8F8F8),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(value), const Icon(Icons.keyboard_arrow_down)],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF8F8F8),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            suffixIcon: const Icon(Icons.calendar_today_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePreview() {
  // ✅ أعطِ الأولوية للصورة المحددة محلياً
  if (_selectedImage != null) {
    return Image.file(_selectedImage!, fit: BoxFit.cover);
  }

  // ✅ إذا لم توجد صورة محلية، اعرض من الشبكة
  if (userInfo != null && (userInfo!.profilePic ?? "").isNotEmpty) {
    // ✅ استخدم UniqueKey لفرض إعادة بناء الـ widget
    return Image.network(
      userInfo!.profilePic!,
      key: ValueKey(userInfo!.profilePic! + DateTime.now().toString()),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.person, size: 60, color: Colors.white),
    );
  }

  return const Icon(Icons.person, size: 60, color: Colors.white);
}
  Future<void> _pickProfileImage() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1024,
    imageQuality: 85,
  );

  if (picked == null) {
    print("❌ No image picked");
    return;
  }

  print("✅ Picked image path: ${picked.path}");
  print("📦 File exists: ${File(picked.path).existsSync()}");
  print("📏 File size: ${await File(picked.path).length()} bytes"); // ✅ أضف هذا

  setState(() {
    _selectedImage = File(picked.path);
  });
  
  print("🔄 State updated with selected image"); // ✅ أضف هذا
}
  Future<void> _saveChanges(
  String username,
  String firstName,
  String lastName,
  String email,
  String phone, {
  File? profileImage,
}) async {
  if (!_formKey.currentState!.validate()) return;

  try {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Uploading..."))
    );

    final response = await updateUserRequest(
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      bio: "",
      profileImage: profileImage,
    );

    if (response["status"] == "success") {
      // ✅ أعد تحميل بيانات المستخدم بعد النجاح
      await _loadUser();
      
      // ✅ امسح الصورة المحددة محلياً
      setState(() {
        _selectedImage = null;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).ChangesSaved))
      );
      
      // أعطِ وقتاً صغيراً للـ UI ليتحدث
      await Future.delayed(const Duration(milliseconds: 500));
      
      Navigator.of(context).pop(true);
    } else {
      throw Exception(response["message"] ?? "Upload failed");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Upload failed: $e"))
    );
  }
}

}
