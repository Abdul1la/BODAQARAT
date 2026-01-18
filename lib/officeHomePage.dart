import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:aqarat_flutter_project/AboutUs.dart';
import 'package:aqarat_flutter_project/ContactUs.dart';
import 'package:aqarat_flutter_project/PrivacyPolicy.dart';
import 'package:aqarat_flutter_project/app_theme.dart';
import 'package:aqarat_flutter_project/backend/bookmark.dart';
import 'package:aqarat_flutter_project/backend/get_post.dart';
import 'package:aqarat_flutter_project/backend/postadd.dart';
import 'package:aqarat_flutter_project/backend/purches.dart';
import 'package:aqarat_flutter_project/backend/reklam.dart';
import 'package:aqarat_flutter_project/backend/search.dart';
import 'package:aqarat_flutter_project/subscriptionState.dart';
import 'package:aqarat_flutter_project/warningLogOutPage.dart';
import 'package:flutter/material.dart';
import 'package:aqarat_flutter_project/postsDetail.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:aqarat_flutter_project/search_page.dart';
import 'package:aqarat_flutter_project/login.dart';
import 'package:aqarat_flutter_project/SignUpUser.dart';
import 'package:aqarat_flutter_project/askForLogin.dart';
import 'package:aqarat_flutter_project/Office_Profile.dart';
import 'package:aqarat_flutter_project/EditProfile.dart';
import 'package:aqarat_flutter_project/subscription_pageOne.dart';
import 'package:aqarat_flutter_project/Plans.dart';
import 'package:aqarat_flutter_project/map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:aqarat_flutter_project/requestPicture.dart';
import 'package:aqarat_flutter_project/OfficialProfileSetting.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:aqarat_flutter_project/navigation.dart';
import 'package:aqarat_flutter_project/theme_settings_page.dart';
import 'package:aqarat_flutter_project/flutter_notification.dart';

class ChangeOfficeLocale extends StatefulWidget {
  final Locale myLocaly;
  const ChangeOfficeLocale({super.key, required this.myLocaly});

  @override
  State<ChangeOfficeLocale> createState() =>
      ChangeLocaleState(MyLocaly: myLocaly);
}

class ChangeLocaleState extends State<ChangeOfficeLocale> {
  Locale MyLocaly;
  ChangeLocaleState({required this.MyLocaly});

  void changeLocale(String language) {
    setState(() {
      MyLocaly = Locale(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: MyLocaly,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: AppTheme.theme,
      home: MyApp(onChangeLocale: changeLocale, locale: MyLocaly),
    );
  }
}

class MyApp extends StatefulWidget {
  final Locale locale;
  final Function(String) onChangeLocale;

  const MyApp({super.key, required this.onChangeLocale, required this.locale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List categoriesList = [
    {
      "profileImage": "images/isolate logo one.webp",
      "title": "office one",
      "price": "1000 USD",
      "Aqar Title": "apartment",
      "Aqar Location": "Tanahi,NawroCity",
    },
    {
      "profileImage": "images/isolate logo two.webp",
      "title": "office two",
      "price": "1000 USD",
      "Aqar Title": "apartment",
      "Aqar Location": "Tanahi,NawroCity",
    },
    {
      "profileImage": "images/isolate logo three.webp",
      "title": "office three",
      "price": "1000 USD",
      "Aqar Title": "apartment",
      "Aqar Location": "Tanahi,NawroCity",
    },
    {
      "profileImage": "images/isolate logo four.webp",
      "title": "office four",
      "price": "1000 USD",
      "Aqar Title": "apartment",
      "Aqar Location": "Tanahi,NawroCity",
    },
    {
      "profileImage": "images/isolate logo five.webp",
      "title": "office five",
      "price": "1000 USD",
      "Aqar Title": "apartment",
      "Aqar Location": "Tanahi,NawroCity",
    },
  ];

  final List itemsSale = [
    {
      "image": "https://picsum.photos/id/1018/600/400",
      "title": "Office One",
      "subtitle": "Portable Computer for Hard Work",
      "price": "1099 USD",
    },
    {
      "image": "https://picsum.photos/id/1015/600/400",
      "title": "IPhone",
      "subtitle": "for people who dont know any thing about tech",
      "price": "1199 USD",
    },
    {
      "image": "https://picsum.photos/id/1016/600/400",
      "title": "Galaxy Z-Fold",
      "subtitle": "for people who dont want their money",
      "price": "1299 USD",
    },
    {
      "image": "https://picsum.photos/id/1019/600/400",
      "title": "EV Bike",
      "subtitle": "for Lazy People",
      "price": "1499 USD",
    },
  ];
  // --- Add Post form controllers/state ---
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _postImages = [];
  // DB: Available property types that will be persisted with the post.
  // (DB) property type options returned from backend lookups.
  final List<String> _propertyTypes = ['House', 'Apartment', 'Farm'];
  // (DB) selected property type that must be saved with the post.
  String _selectedPropertyType = 'House';

  // (DB) city list (should come from backend in final version).
  List<City> _cities = [];
  // (DB) selected city id/name to store.
  String _selectedCity = 'Duhok';
  // (DB) selected area/district for the listing.
  String? _selectedArea;
  // (DB) human readable address label coming from the map picker.
  final TextEditingController _locationController = TextEditingController();
  // (DB) final lat/lng used for geolocation searches.
  LatLng? _selectedLatLng;
  // (DB) shareable map URL for the listing.
  String? _locationMapUrl;
  // (DB) apartment tower/building name if applicable.
  final TextEditingController _buildingNameController = TextEditingController();
  // (DB) asking price value.
  final TextEditingController _priceController = TextEditingController();
  // (DB) bedroom count.
  final TextEditingController _bedroomController = TextEditingController();
  // (DB) bathroom count.
  final TextEditingController _bathroomController = TextEditingController();
  // (DB) total area (m2) for this property.
  final TextEditingController _areaController = TextEditingController();
  // (DB) floor/floors number.
  final TextEditingController _floorController = TextEditingController();
  // (DB) long description/content.
  final TextEditingController _descriptionController = TextEditingController();
  // Check if Apartment from data base  value ------------------------------------
  bool get _isApartment => _selectedPropertyType == 'Apartment';

  String get _floorLabel =>
      _isApartment ? S.of(context).AparmtmentFloorNumber : S.of(context).Floors;
  // its just hint !!
  String get _floorHint => _isApartment ? '5' : '2';

  List<bool> isAvilable = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  List<PostsInDB> futurePosts = [];
  List<Purches> futurePurches = [];
  List<int> bookmarkedPostIds = [];
  List<String> adImages = [];
  // Take the user name from data base ------------------------------
  String currentUsername = usernameGlobal; // Example username
  bool isLoading = true;
  bool isRefreshing = false;
  double _pullProgress = 0.0;
  bool _isPublishing = false;
  bool _isUploadingDialogVisible = false;

  static const String _loadingOverlayImage = 'images/bodFinal.png';
  static const String _refreshCardImage = 'images/bodFinal.png';

  String _formatPrice(dynamic rawValue) {
    if (rawValue == null) return "--";
    final trimmed = rawValue.toString().trim();
    if (trimmed.isEmpty || trimmed == "--") return "--";
    return trimmed.startsWith("\$") ? trimmed : "\$$trimmed";
  }

  Future<void> fetchPostsData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedPosts = await fetchAllPosts(
        widget.locale.languageCode,
        currentUsername,
      );
      setState(() {
        futurePosts = fetchedPosts;
      });
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadLocations() async {
    try {
      List<City> cities = await fetchLocations(
        lang: widget.locale.languageCode.toLowerCase(),
      );
      setState(() {
        _cities = cities;

        if (cities.isNotEmpty) {
          _selectedCity = cities.first.cityName;
          _selectedArea = cities.first.addresses.isNotEmpty
              ? cities.first.addresses.first.addressName
              : null;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).FailedToLoadLocation + '$e')),
      );
    }
  }

  List<Address> get _selectedCityAddresses {
    if (_cities.isEmpty) return [];
    final city = _cities.firstWhere(
      (c) => c.cityName == _selectedCity,
      orElse: () => City(cityId: 0, cityName: '', addresses: []),
    );
    return city.addresses;
  }

  List<String> get _availableAreas =>
      _selectedCityAddresses.map((a) => a.addressName).toList();

  List<StateType> _propertyTypesFromDB = [];
  StateType _selectedPropertyTypeDB = StateType(typeId: 0, typeName: '');

  Future<void> _loadPropertyTypes() async {
    try {
      final types = await fetchStateTypes(widget.locale.languageCode);

      setState(() {
        _propertyTypesFromDB = types;
        if (types.isNotEmpty) {
          _selectedPropertyTypeDB = types.first;
        }
      });
    } catch (e) {
      print("Error loading property types: $e");
    }
  }

  List<PostsInDB> get uniqueUsers {
    final seen = <String>{};
    return futurePosts.where((post) {
      if (seen.contains(post.username)) {
        return false;
      }
      seen.add(post.username);
      return true;
    }).toList();
  }

  Widget _buildProfileImage(String? profilePic, {double size = 64}) {
    if (profilePic != null && profilePic.isNotEmpty) {
      return Image.network(
        profilePic,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderAvatar(size);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }
    return _buildPlaceholderAvatar(size);
  }

  Widget _buildPlaceholderAvatar(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(Icons.person, size: size * 0.5, color: Colors.grey[600]),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
    bool showExplore = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 56, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.grey[600],
              ),
            ),
            if (showExplore) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedNavigation = 0; // Go to Home
                  });
                },
                icon: const Icon(Icons.explore_outlined),
                label: Text(S.of(context).SearchInListing),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1E3A8A),
                  side: const BorderSide(color: Color(0xFF1E3A8A)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> fetchPurchesData(String username) async {
    try {
      final fetPosts = await fetchPurches(username);
      setState(() {
        futurePurches = fetPosts;
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  Future<void> fetchBookmarkss() async {
    try {
      final bookmarks = await fetchBookmarks(currentUsername);
      setState(() {
        bookmarkedPostIds = bookmarks;
      });
      print(S.of(context).BookMarkLoaded);
    } catch (e) {
      print(S.of(context).ErrorLoadingBook);
    }
  }

  // Handles multi-image selection for the gallery grid
  Future<void> _pickImages() async {
    try {
      final images = await _imagePicker.pickMultiImage();
      if (!mounted || images.isEmpty) {
        return;
      }
      setState(() {
        _postImages.addAll(images);
      });
    } catch (e) {
      debugPrint('Failed to pick images: $e');
    }
  }

  void _removeImage(int index) {
    if (index < 0 || index >= _postImages.length) {
      return;
    }
    setState(() {
      _postImages.removeAt(index);
    });
  }

  // Pushes the map picker screen and stores the returned geo-data
  Future<void> _openLocationPicker() async {
    final selected = await Navigator.of(context).push<SelectedLocation>(
      MaterialPageRoute(
        builder: (_) => LocationPickerPage(initialLocation: _selectedLatLng),
      ),
    );
    if (selected == null) {
      return;
    }
    setState(() {
      _selectedLatLng = selected.latLng;
      // save the location link to the data base --------------------------------------------------------------
      _locationMapUrl = selected.mapUrl;
      _locationController.text = selected.displayName;
    });
  }

  // Launches the saved map URL (when available)
  Future<void> _openLocationLink() async {
    if (_locationMapUrl == null) {
      return;
    }
    final uri = Uri.parse(_locationMapUrl!);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).CouldntOpenMapLink)),
        );
      }
    }
  }

  Future<void> toggleBookmark(int postId) async {
    try {
      if (bookmarkedPostIds.contains(postId)) {
        // Remove bookmark
        await removeBookmark(currentUsername, postId);
        setState(() {
          bookmarkedPostIds.remove(postId);
        });
        print(S.of(context).BookMarkRemoved);
      } else {
        // Add bookmark
        await addBookmark(currentUsername, postId);
        setState(() {
          bookmarkedPostIds.add(postId);
        });
        print(S.of(context).BookMarkAdded);
      }
    } catch (e) {
      print("❌ Error toggling bookmark: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedArea = _selectedCityAddresses.isNotEmpty
        ? _selectedCityAddresses.first.addressName
        : null;
    fetchPostsData(); // Fetch posts data from the backend
    fetchBookmarkss(); // Fetch bookmarks data for a specific user
    fetechads();
    _loadLocations();
    _loadPropertyTypes();
    // Start the timer for automatic page scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (futurePosts.isNotEmpty) {
          if (_currentPage < futurePosts.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant MyApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the locale changed, refetch posts
    if (oldWidget.locale != widget.locale) {
      fetchPostsData();
    }
  }

  Map<String, dynamic> _collectPostFormData() {
    int getIdCity() {
      return _cities.firstWhere((c) => c.cityName == _selectedCity).cityId;
    }

    int getIdAddress() {
      return _selectedCityAddresses
          .firstWhere((a) => a.addressName == _selectedArea)
          .addressId;
    }

    return {
      "username": currentUsername,
      "content": _descriptionController.text.trim(),
      "prize": _priceController.text.trim(),
      "location": _locationController.text.trim(),
      "area": int.tryParse(_areaController.text.trim()) ?? 0,

      // Fixed: correct key is condation
      "facade": "N/A",
      "condation": "New",

      "floor_num": int.tryParse(_floorController.text.trim()) ?? 0,
      "room_num": int.tryParse(_bedroomController.text.trim()) ?? 0,
      "bathroom_num": int.tryParse(_bathroomController.text.trim()) ?? 0,

      "city": getIdCity(),
      "address_name": getIdAddress(),

      // correct key for state
      "state": _selectedPropertyTypeDB.typeId,

      "map_url": _locationMapUrl ?? "",
      "latitude": _selectedLatLng?.latitude.toString() ?? "",
      "longitude": _selectedLatLng?.longitude.toString() ?? "",
    };
  }

  String? _validatePostForm() {
    if (_selectedArea == null || _selectedArea!.isEmpty) {
      return S.of(context).PleaseSelectAreaDistrict;
    }
    if (_locationController.text.trim().isEmpty) {
      return S.of(context).PleaseSelectProperty;
    }
    if (_priceController.text.trim().isEmpty) {
      return S.of(context).EnterBedroom;
    }
    if (_bedroomController.text.trim().isEmpty) {
      return S.of(context).EnterBathroom;
    }
    if (_bathroomController.text.trim().isEmpty) {
      return S.of(context).EnterBathroom;
    }
    if (_areaController.text.trim().isEmpty) {
      return S.of(context).EnterArea;
    }
    if (_floorController.text.trim().isEmpty) {
      return S.of(context).EnterInformatioin;
    }
    if (_descriptionController.text.trim().isEmpty) {
      return S.of(context).AddDiscription;
    }
    if (_postImages.isEmpty) {
      return S.of(context).PleaseUploadPropertyImages;
    }
    return null;
  }

  void _resetPostForm() {
    _selectedCity = _cities.first.cityName;
    final areas = _selectedCityAddresses;
    _selectedArea = areas.isNotEmpty ? areas.first.addressName : null;
    _selectedPropertyType = _propertyTypes.first;
    _locationController.clear();
    _buildingNameController.clear();
    _priceController.clear();
    _bedroomController.clear();
    _bathroomController.clear();
    _areaController.clear();
    _floorController.clear();
    _descriptionController.clear();
    _postImages.clear();
    _selectedLatLng = null;
    _locationMapUrl = null;
  }

  void _showUploadingDialog() {
    if (!mounted || _isUploadingDialogVisible) return;
    _isUploadingDialogVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF2FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const SizedBox(
                    height: 42,
                    width: 42,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xff1D4ED8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  S.of(context).PublishProperty,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff111827),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).Loading,
                  style: const TextStyle(
                    color: Color(0xff6B7280),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) => _isUploadingDialogVisible = false);
  }

  void _hideUploadingDialog() {
    if (!_isUploadingDialogVisible || !mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isUploadingDialogVisible = false;
  }

  Future<void> _showUploadResultDialog() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.fromLTRB(32, 28, 32, 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffECFDF5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xff10B981),
                  size: 40,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                S.of(context).PublishProperty,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff111827),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                S.of(context).ChangesSaved,
                style: const TextStyle(color: Color(0xff6B7280), fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1D4ED8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _publishProperty() async {
    final validationMessage = _validatePostForm();
    if (validationMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationMessage)));
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => _isPublishing = true);
    _showUploadingDialog();

    try {
      final payload = _collectPostFormData();

      final result = await PostsAPI.uploadProperty(
        username: payload["username"],
        content: payload["content"],
        prize: payload["prize"],
        location: payload["location"],
        area: payload["area"],
        facade: payload["facade"],
        condation: payload["condation"],
        floorNum: payload["floor_num"],
        roomNum: payload["room_num"],
        bathroomNum: payload["bathroom_num"],
        cityId: payload["city"],
        addressId: payload["address_name"],
        stateId: payload["state"],
        imagePaths: _postImages.map((x) => x.path).toList(),
      );

      print("UPLOAD RESPONSE => $result");

      if (result["success"] == true) {
        await fetchPostsData();
        setState(_resetPostForm);

        if (mounted) {
          _hideUploadingDialog();
          await _showUploadResultDialog();
        }
      } else {
        throw Exception(result);
      }
    } catch (e) {
      if (mounted) {
        _hideUploadingDialog();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        _hideUploadingDialog();
        setState(() => _isPublishing = false);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationController.dispose();
    _buildingNameController.dispose();
    _priceController.dispose();
    _bedroomController.dispose();
    _bathroomController.dispose();
    _areaController.dispose();
    _floorController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  int _selectedNavigation = 0;

  // Function called when pull-to-refresh is triggered
  Future<void> refreshData() async {
    HapticFeedback.lightImpact();
    setState(() {
      isRefreshing = true;
      _pullProgress = 1.0;
    });

    try {
      final fetchedPosts = await fetchAllPosts(
        widget.locale.languageCode,
        currentUsername,
      );
      if (mounted) {
        setState(() {
          futurePosts = fetchedPosts;
        });
      }
      await fetchBookmarkss();
      await fetechads();
    } catch (e) {
      print(S.of(context).ErrorRefreshingPost + "$e");
    } finally {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          isRefreshing = false;
          _pullProgress = 0.0;
        });
      }
    }
  }

  Future<void> fetechads() async {
    try {
      final ads = await fetchAds();
      setState(() {
        adImages = ads;
      });
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (_selectedNavigation != 0) {
      return false;
    }
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }

    final double offset = notification.metrics.pixels;
    if (!isRefreshing && offset < 0) {
      final double newProgress = (offset.abs() / 140).clamp(0.0, 1.0);
      if ((newProgress - _pullProgress).abs() > 0.01) {
        setState(() {
          _pullProgress = newProgress;
          refreshData();
        });
      }
    } else if (!isRefreshing && offset >= 0 && _pullProgress != 0.0) {
      setState(() {
        _pullProgress = 0.0;
        refreshData();
      });
    }

    return false;
  }

  Widget _buildRefreshBanner(BuildContext context) {
    const double minHeight = 150;
    const double maxHeight = 190;
    final bool showBanner = isRefreshing || _pullProgress > 0.05;
    final double progressValue = _pullProgress.clamp(0.0, 1.0);
    final double targetHeightValue = isRefreshing ? 1.0 : progressValue;
    final double cardHeight =
        (ui.lerpDouble(minHeight, maxHeight, targetHeightValue) ?? minHeight)
            .clamp(minHeight, maxHeight);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 20,
      right: 20,
      child: IgnorePointer(
        ignoring: true,
        child: AnimatedOpacity(
          opacity: showBanner ? 1 : 0,
          duration: const Duration(milliseconds: 220),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            height: cardHeight,
            constraints: const BoxConstraints(
              minHeight: minHeight,
              maxHeight: maxHeight,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff1E3A8A),
                  Color(0xff312E81),
                  Color(0xff3B82F6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff1E3A8A).withOpacity(0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    _refreshCardImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isRefreshing
                            ? S.of(context).RefreshingYourofficefeed
                            : S.of(context).PullToRefresh,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isRefreshing
                            ? S.of(context).FetchingTheLatest
                            : S.of(context).Fetching_The_Last_Update_To_You,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: isRefreshing ? null : progressValue,
                          minHeight: 6,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1E3A8A),
                  Color(0xff0F172A),
                  Color(0xff2563EB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(color: Colors.white.withOpacity(0.12)),
            ),
          ),
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff1E3A8A).withOpacity(0.28),
                    blurRadius: 34,
                    offset: const Offset(0, 20),
                  ),
                ],
                border: Border.all(
                  color: const Color(0xff1E3A8A).withOpacity(0.12),
                  width: 1.3,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AspectRatio(
                      aspectRatio: 1.6,
                      child: Image.asset(
                        _loadingOverlayImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xffE0E7FF),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.apartment_rounded,
                            color: Color(0xff1E3A8A),
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    S.of(context).PreparingYourOfficeDashboard,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff1E3A8A),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).CuratingTheLatestOpportunitiesForYourCompany,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xff1E3A8A).withOpacity(0.72),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 26),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: const LinearProgressIndicator(
                      minHeight: 8,
                      backgroundColor: Color(0xffDBEAFE),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xff1E3A8A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(PostsInDB post) {
    final bool isAvailable = post.is_available;
    final availabilityLabel = isAvailable
        ? S.of(context).Avilable
        : S.of(context).NotAvilable;
    final Color availabilityColor = isAvailable
        ? const Color(0xff059669)
        : const Color(0xffDC2626);
    final String priceText = _formatPrice(post.prize);
    final String locationText = [
      post.city ?? '',
      post.address ?? '',
    ].where((value) => value.trim().isNotEmpty).join(', ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xffF8FAFF), Color(0xffEEF2FF), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xffE0E7FF)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1E3A8A).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xffE0E7FF),
                  backgroundImage: post.profile_pic != null
                      ? NetworkImage(post.profile_pic!)
                      : null,
                  child: post.profile_pic == null
                      ? const Icon(Icons.person, color: Color(0xff4338CA))
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff111827),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      if (locationText.isNotEmpty)
                        Text(
                          locationText,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: S.of(context).BookMark,
                  icon: const Icon(
                    Icons.bookmark_rounded,
                    color: Color(0xffF59E0B),
                  ),
                  onPressed: () {
                    if (post.post_id != null) {
                      toggleBookmark(post.post_id!);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post.media_path1,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xffE0E7FF),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.home_work_outlined,
                      color: Color(0xff6366F1),
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.type_name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0F172A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        priceText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1E3A8A),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: availabilityColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    availabilityLabel,
                    style: TextStyle(
                      color: availabilityColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xff475569),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    locationText.isEmpty
                        ? S.of(context).Location
                        : locationText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xff475569),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if ((post.content ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  post.content!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff4B5563),
                    height: 1.4,
                  ),
                ),
              ),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildBookmarkInfoChip(
                  Icons.bed_outlined,
                  '${post.room_num ?? '--'}',
                ),
                _buildBookmarkInfoChip(
                  Icons.bathtub_outlined,
                  '${post.bathroom_num ?? '--'}',
                ),
                _buildBookmarkInfoChip(
                  Icons.square_foot_outlined,
                  post.area != null ? '${post.area} m²' : '--',
                ),
                if ((post.phone_num ?? '').isNotEmpty)
                  _buildBookmarkInfoChip(Icons.phone_outlined, post.phone_num!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkInfoChip(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffEEF2FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xff4338CA)),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff312E81),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _navigationList() {
    final bookmarkedPosts = futurePosts
        .where(
          (post) =>
              post.post_id != null && bookmarkedPostIds.contains(post.post_id),
        )
        .toList();
    return [
      // Home Page
      RefreshIndicator(
        onRefresh: refreshData,
        color: const Color(0xff1E3A8A),
        backgroundColor: Colors.white,
        strokeWidth: 3,
        edgeOffset: 10,
        displacement: 64,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            // ---- Search bar + language switcher ----
            Row(
              children: [
                Expanded(
                  child: Hero(
                    tag: "search_bar",
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SearchPage(myLocale: widget.locale),
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
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).chain(
                                          CurveTween(
                                            curve: Curves.easeInOutCubic,
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
                        },
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.grey[50]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.8),
                                blurRadius: 20,
                                offset: const Offset(-4, -4),
                              ),
                            ],
                            border: Border.all(
                              color: const Color(0xff1E3A8A).withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xff1E3A8A,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  color: Color(0xff1E3A8A),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                S.of(context).Search,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // language switcher
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff1E3A8A), Color(0xff3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff1E3A8A).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.language,
                      size: 24,
                      color: Colors.white,
                    ),
                    onSelected: (String value) {
                      // Delay the locale change to allow menu to close properly
                      Future.delayed(const Duration(milliseconds: 100), () {
                        widget.onChangeLocale(value);
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    offset: const Offset(0, 8),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'en',
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Color(0xff1E3A8A),
                                ),
                                const SizedBox(width: 10),
                                Text(S.of(context).En),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'ar',
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Color(0xff1E3A8A),
                                ),
                                const SizedBox(width: 10),
                                Text(S.of(context).Ar),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'ps',
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Color(0xff1E3A8A),
                                ),
                                const SizedBox(width: 10),
                                Text(S.of(context).Bd),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'ur',
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.flag,
                                  color: Color(0xff1E3A8A),
                                ),
                                const SizedBox(width: 10),
                                Text(S.of(context).So),
                              ],
                            ),
                          ),
                        ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ---- Categories Section ----
            Container(
              height: 140,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    const Color(0xffF7F7FD),
                    Colors.white.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 20,
                    offset: const Offset(-6, -6),
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: const Color(0xff1E3A8A).withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                // take length from the list you take from data base
                itemCount: uniqueUsers.length,
                physics: const BouncingScrollPhysics(),
                // list from data base
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: "category_avatar_$index",
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // for later to set to the profile
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => officeProfile(
                                          myLocale: widget.locale,
                                          data: uniqueUsers[index],
                                          username: uniqueUsers[index].username,
                                        ),
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return ScaleTransition(
                                            scale: animation.drive(
                                              Tween(begin: 0.8, end: 1.0).chain(
                                                CurveTween(
                                                  curve: Curves.easeOutBack,
                                                ),
                                              ),
                                            ),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                    transitionDuration: const Duration(
                                      milliseconds: 300,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(25),
                              splashColor: const Color(
                                0xff1E3A8A,
                              ).withOpacity(0.1),
                              highlightColor: const Color(
                                0xff1E3A8A,
                              ).withOpacity(0.05),
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.grey[100]!],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xff1E3A8A,
                                      ).withOpacity(0.15),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                      spreadRadius: 0,
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.7),
                                      blurRadius: 12,
                                      offset: const Offset(-4, -4),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: const Color(
                                      0xff1E3A8A,
                                    ).withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: _buildProfileImage(
                                      uniqueUsers[index].profile_pic,
                                      size: 64,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            // take the title from data base
                            '${uniqueUsers[index].first_name} ${uniqueUsers[index].last_name}',
                            style: const TextStyle(
                              color: Color(0xff1E3A8A),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Items for reklam ----------------
            Container(
              height: 150,
              width: double.infinity,
              margin: EdgeInsets.only(right: 13, left: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: adImages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.network(adImages[index], fit: BoxFit.cover),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // ---- Items Grid ----
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 320,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 2,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: futurePosts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            itemDetails(
                              myLocale: widget.locale,
                              username: futurePosts[index].username,
                              profilePic: futurePosts[index].profile_pic,
                              location: futurePosts[index].location,
                              price: futurePosts[index].prize,
                              area: futurePosts[index].area,
                              bedroom: futurePosts[index].bathroom_num,
                              bathroom: futurePosts[index].bathroom_num,
                              roomNum: futurePosts[index].room_num,
                              discription: futurePosts[index].content,
                              facade: futurePosts[index].facade,
                              condetion: futurePosts[index].condation,
                              floorNum: futurePosts[index].floor_num,
                              phoneNum: futurePosts[index].phone_num,
                              postID: futurePosts[index].post_id,
                              city: futurePosts[index].city,
                              address: futurePosts[index].address,
                              state: futurePosts[index].type_name,
                              available: futurePosts[index].is_available,
                              image1: futurePosts[index].media_path1,
                              image2: futurePosts[index].media_path2,
                              image3: futurePosts[index].media_path3,
                              image4: futurePosts[index].media_path4,
                            ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Card header (profile + title)
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  // take the profile image from data base -------------------
                                  futurePosts[index].profile_pic,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 5),
                              // take the office name from data base ----------------------
                              Text(futurePosts[index].username),
                              SizedBox(width: 10),
                            ],
                          ),
                          SizedBox(height: 5),
                          // Card image
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Image.network(
                              // take the image from data base
                              futurePosts[index].media_path1,
                              height: 100,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Price + bookmark
                          Row(
                            children: [
                              Text(
                                // take the prize from data base
                                _formatPrice(futurePosts[index].prize),
                                style: const TextStyle(
                                  color: Color(0xff1E3A8A),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Book Mark Button -------------------------
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    bookmarkedPostIds.contains(
                                          futurePosts[index].post_id,
                                        )
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color:
                                        bookmarkedPostIds.contains(
                                          futurePosts[index].post_id,
                                        )
                                        ? Colors.orange
                                        : Color(0xff1E3A8A),
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    final postId = futurePosts[index].post_id;
                                    if (postId != null) {
                                      toggleBookmark(postId);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Static title (can be dynamic later)
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  futurePosts[index].type_name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff000929),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: futurePosts[index].is_available
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  futurePosts[index].is_available
                                      ? S.of(context).Avilable
                                      : S.of(context).NotAvilable,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // title of the aqar
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${futurePosts[index].city}, ${futurePosts[index].address}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xff000929),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 25,
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(width: 1)),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Bottom info row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.bed,
                                    size: 20,
                                    color: Color(0xff7065F0),
                                  ),
                                  SizedBox(width: 5),
                                  // take number from data base
                                  SizedBox(
                                    width: 20,
                                    child: Text(
                                      futurePosts[index].room_num.toString(),
                                      style: TextStyle(fontSize: 9),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.bathtub,
                                    size: 20,
                                    color: Color(0xff7065F0),
                                  ),
                                  SizedBox(width: 5),
                                  //take number from data base
                                  SizedBox(
                                    width: 20,
                                    child: Text(
                                      futurePosts[index].bathroom_num
                                          .toString(),
                                      style: TextStyle(fontSize: 9),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.square_foot,
                                    size: 20,
                                    color: Color(0xff7065F0),
                                  ),
                                  SizedBox(width: 5),
                                  SizedBox(
                                    width: 20,
                                    child: Text(
                                      futurePosts[index].area.toString(),
                                      style: TextStyle(fontSize: 9),
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Other navigation pages

      // Purches Pages : ----------------------------
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              S.of(context).Purches,
              style: const TextStyle(fontSize: 20, color: Color(0xff995858)),
            ),
            Container(
              height: 10,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xff9CA3AF)),
                ),
              ),
            ),
            // Empty state for Purchases
            if (futurePurches.isEmpty)
              _buildEmptyState(
                icon: Icons.shopping_cart_outlined,
                title: S.of(context).NothingHereYet,
                message: S.of(context).ThereisnoPurchesYet,
              ),

            if (futurePurches.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 450,
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 2,
                ),
                // take the length of the list from the data base --------------------------------------------------------------------
                itemCount: futurePurches.length,
                itemBuilder: (context, index) {
                  return MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (
                                context,
                                animation,
                                secondaryAnimation,
                              ) => itemDetails(
                                myLocale: widget.locale,
                                username: futurePurches[index].username,
                                profilePic: futurePurches[index].profilePic,
                                location: futurePurches[index].addressName,
                                price: futurePurches[index].prize.toString(),
                                area: futurePurches[index].area!.toInt(),
                                bedroom: futurePurches[index].roomNum ?? 0,
                                bathroom: futurePurches[index].bathromNum ?? 0,
                                roomNum: futurePurches[index].floorNum ?? 0,
                                discription: futurePurches[index].content,
                                facade: futurePurches[index].facade ?? '',
                                condetion: futurePurches[index].condation ?? '',
                                floorNum: futurePurches[index].floorNum ?? 0,
                                postID: 9,
                                city: futurePurches[index].cityName,
                                address: futurePurches[index].addressName,
                                state: futurePurches[index].typeName,
                                available: true,
                                image1: futurePurches[index].mediaPath1,
                              ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(
                                  begin: begin,
                                  end: end,
                                ).chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // The Big Image ------------------------------------------- (Take it from data base)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.network(
                              futurePurches[index].mediaPath1,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // office title and image of profile ---------------------
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            futurePurches[index].mediaPath1,
                                          ),
                                          radius: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          // office name from data base ----------------------
                                          futurePurches[index].username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        S.of(context).ProcessPurches,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${futurePurches[index].cityName}, ${futurePurches[index].addressName}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Price From Data base !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.attach_money,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: Color(0xff1E3A8A),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                        _formatPrice(
                                          futurePurches[index].prize,
                                        ),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).Type,
                                      style: const TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      // take the Type from data base ----------------
                                      futurePurches[index].typeName,
                                      style: const TextStyle(
                                        color: Color(0xff995858),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).DateOfPurches,
                                      style: const TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Text(
                                      // take the Date of Purches from data base ----------------
                                      "9-9-2025",
                                      style: TextStyle(
                                        color: Color(0xff995858),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).OwnerPhoneNumber,
                                      style: const TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Text(
                                      // take the interface from data base ----------------
                                      "07511130503",
                                      style: TextStyle(
                                        color: Color(0xff995858),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),

      // Add Post Page --------------------------------
      if (SubscribeStatus == "active")
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            color: const Color(0xffF8FAFC),
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xffE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Property info header ---
                  Text(
                    S.of(context).PropertyInformations,
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // --- Property type selector ---
                  Text(
                    S.of(context).PropertyType,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // --- City & district selection ----------------------------------------
                  Text(
                    S.of(context).City,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Store selected city in DB when creating the post.
                  DropdownButtonFormField<String>(
                    value: _selectedCity,
                    isExpanded: true,
                    items: _cities.map((city) {
                      return DropdownMenuItem(
                        value: city.cityName,
                        child: Text(city.cityName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCity = value;

                        // load areas for the new city
                        final areas = _availableAreas;
                        _selectedArea = areas.isNotEmpty ? areas.first : null;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                      ),
                    ),
                  ),
                  if (_selectedCityAddresses.isNotEmpty) ...[
                    // --- Area dropdown for selected city ---
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).AreaDistrict,
                      style: const TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Store selected area/district alongside the city.
                    if (_availableAreas.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).AreaDistrict,
                        style: const TextStyle(
                          color: Color(0xff6B7280),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        value: _selectedArea ?? _availableAreas.first,
                        isExpanded: true,
                        items: _availableAreas.map((area) {
                          return DropdownMenuItem(
                            value: area,
                            child: Text(area),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedArea = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffF9FAFB),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xffE5E7EB),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 8),
                  // Persist the chosen property type for backend filtering.
                  DropdownButtonFormField<StateType>(
                    value: _selectedPropertyTypeDB,
                    isExpanded: true,
                    items: _propertyTypesFromDB.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.typeName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedPropertyTypeDB = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  // --- Map-based location picker --- =
                  Text(
                    S.of(context).Location,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Save the user-selected map location name + lat/lng.
                  TextField(
                    controller: _locationController,
                    readOnly: true,
                    onTap: _openLocationPicker,
                    decoration: InputDecoration(
                      hintText: S.of(context).TapToSelectFromTheMap,
                      filled: true,
                      fillColor: const Color(0xffF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        onPressed: _openLocationPicker,
                        icon: const Icon(
                          Icons.map_rounded,
                          color: Color(0xff1E3A8A),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xff2563EB)),
                      ),
                    ),
                  ),
                  if (_locationMapUrl != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _openLocationLink,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff1E3A8A),
                      ),
                      icon: const Icon(Icons.link),
                      label: Text(S.of(context).OpenSelectedLocation),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // --- Apartment-only building name field ---
                  if (_isApartment) ...[
                    Text(
                      S.of(context).BuildingName,
                      style: const TextStyle(
                        color: Color(0xff6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Keep the building/tower name for apartment listings.
                    TextField(
                      controller: _buildingNameController,
                      decoration: InputDecoration(
                        hintText: S.of(context).SunriseResidency,
                        filled: true,
                        fillColor: const Color(0xffF9FAFB),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xffE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xffE5E7EB),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xff2563EB),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // --- Pricing field -----------------------------------------
                  Text(
                    S.of(context).Price,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Store the asking price in the posts table.
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: S.of(context).PriceHere,
                      filled: true,
                      fillColor: const Color(0xffF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xff2563EB)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // --- Property details (rooms, area, floors) ---
                  Text(
                    S.of(context).PropertyDetails,
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).Bedroom,
                              style: const TextStyle(
                                color: Color(0xff6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Save bedroom count for search filters.
                            TextField(
                              controller: _bedroomController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '4',
                                filled: true,
                                fillColor: const Color(0xffF9FAFB),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E7EB),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E7EB),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xff2563EB),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).Bathroom,
                              style: const TextStyle(
                                color: Color(0xff6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Save bathroom count for property stats.
                            TextField(
                              controller: _bathroomController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '3',
                                filled: true,
                                fillColor: const Color(0xffF9FAFB),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E7EB),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E7EB),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xff2563EB),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).Area,
                              style: const TextStyle(
                                color: Color(0xff6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Persist total area (m²) for the listing.
                            TextField(
                              controller: _areaController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '250',
                                filled: true,
                                fillColor: const Color(0xffF9FAFB),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E7EB),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E7EB),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xff2563EB),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _floorLabel,
                              style: const TextStyle(
                                color: Color(0xff6B7280),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Persist floor/level information.
                            TextField(
                              controller: _floorController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: _floorHint,
                                filled: true,
                                fillColor: const Color(0xffF9FAFB),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E7EB),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xffE5E7EB),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xff2563EB),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // --- Description ---
                  Text(
                    S.of(context).Discription,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Save the long-form description/content to DB.
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: S.of(context).ShortDiscription,
                      filled: true,
                      fillColor: const Color(0xffF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xffE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xff2563EB)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // --- Image upload grid ---
                  Text(
                    S.of(context).Images,
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).UploadPropertyImages,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Upload & store every selected image path/url.
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...List.generate(_postImages.length, (index) {
                        final image = _postImages[index];
                        return Stack(
                          children: [
                            Container(
                              width: 74,
                              height: 74,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xffE5E7EB),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(image.path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      InkWell(
                        onTap: () => _pickImages(),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            color: const Color(0xffF3F4F6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xffE5E7EB)),
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            color: Color(0xff9CA3AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _pickImages(),
                    child: Text(
                      S.of(context).AddMore,
                      style: const TextStyle(
                        color: Color(0xff1E3A8A),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPublishing ? null : _publishProperty,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1D4ED8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: _isPublishing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              S.of(context).PublishProperty,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        )
      else
        Column(
          children: [
            SizedBox(height: 150),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffEEF2FF), Color(0xffF5F3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xffC7D2FE)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 74,
                    width: 74,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(37),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_clock_outlined,
                      color: Color(0xff1E3A8A),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    S.of(context).Expired,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff111827),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    S.of(context).Renew,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff4B5563),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PricingPlansPage(myLocale: widget.locale),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff1E3A8A),
                            side: const BorderSide(color: Color(0xff1E3A8A)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            S.of(context).SeePlans,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PricingPlansPage(myLocale: widget.locale),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            S.of(context).RenwNow,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      // Book Mark Page --------------------------
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              S.of(context).BookMark,
              style: const TextStyle(fontSize: 20, color: Color(0xff995858)),
            ),
            Container(
              height: 10,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xff9CA3AF)),
                ),
              ),
            ),

            // Empty state for Bookmarks
            if (bookmarkedPosts.isEmpty)
              _buildEmptyState(
                icon: Icons.bookmark_outline,
                title: S.of(context).NothingHereYet,
                message: S.of(context).ThereisnoBookMarkYet,
              ),

            // Show bookmarked posts
            if (bookmarkedPosts.isNotEmpty)
              Column(
                children: bookmarkedPosts.map((post) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    itemDetails(
                                      myLocale: widget.locale,
                                      username: post.username,
                                      profilePic: post.profile_pic,
                                      location: post.location,
                                      price: post.prize,
                                      area: post.area,
                                      bedroom: post.bathroom_num,
                                      bathroom: post.bathroom_num,
                                      roomNum: post.room_num,
                                      discription: post.content,
                                      facade: post.facade,
                                      condetion: post.condation,
                                      floorNum: post.floor_num,
                                      phoneNum: post.phone_num,
                                      postID: post.post_id,
                                      city: post.city,
                                      address: post.address,
                                      state: post.type_name,
                                      available: post.is_available,
                                      image1: post.media_path1,
                                      image2: post.media_path2,
                                      image3: post.media_path3,
                                      image4: post.media_path4,
                                    ),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;
                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                          ),
                        );
                      },
                      child: _buildBookmarkCard(post),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),

      // Profile and Others -----------------------------
      Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              _buildQuickActionCard(
                title: S.of(context).SeeAcount,
                subtitle: S.of(context).EditAndSeeAccount,
                icon: Icons.person_outline_rounded,
                gradientColors: const [Color(0xff7F7FD5), Color(0xff86A8E7)],
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          officialProfileSetting(
                            myLocale: widget.locale,
                            // take the username and data from data base to here : ---------------=============================
                            data: "any thing",
                            username: currentUsername,
                          ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              scale: animation.drive(
                                Tween(
                                  begin: 0.8,
                                  end: 1.0,
                                ).chain(CurveTween(curve: Curves.easeOutBack)),
                              ),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              // Plans -----------------------------
              _buildQuickActionCard(
                title: S.of(context).SeePlans,
                subtitle: S.of(context).PlansAndSubscription,
                icon: Icons.workspace_premium_rounded,
                gradientColors: const [Color(0xff1E3A8A), Color(0xff2563EB)],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PricingPlansPage(myLocale: widget.locale),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // camera Request --------------------
              if (AccountValue > 2 && SubscribeStatus == "active")
                _buildQuickActionCard(
                  title: S.of(context).RequestPictureSession,
                  subtitle: S.of(context).LetOurTeamCapture,
                  icon: Icons.camera_alt_outlined,
                  gradientColors: const [Color(0xff0E3386), Color(0xff1E90FF)],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            RequestPicturePage(myLocale: widget.locale),
                      ),
                    );
                  },
                ),
              SizedBox(height: 16),
              // About Us --------------------------
              _buildQuickActionCard(
                title: S.of(context).AboutUs,
                subtitle: S.of(context).LearnMoreAboutUs,
                icon: Icons.all_inbox_outlined,
                gradientColors: const [Color(0xff1E3A8A), Color(0xff2563EB)],
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          AboutUsPage(myLocale: widget.locale),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              scale: animation.drive(
                                Tween(
                                  begin: 0.8,
                                  end: 1.0,
                                ).chain(CurveTween(curve: Curves.easeOutBack)),
                              ),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),

              // Learn More About Subscription State --------------------------
              // _buildQuickActionCard(
              //   title: S.of(context).SeeSubscriptionState,
              //   subtitle: S.of(context).LearnMoreAboudYourSubscriptionState,
              //   icon: Icons.all_inbox_outlined,
              //   gradientColors: const [Color(0xff1E3A8A), Color(0xff2563EB)],
              //   onTap: () {
              //     Navigator.of(context).push(
              //       PageRouteBuilder(
              //         pageBuilder: (context, animation, secondaryAnimation) =>
              //             SubscriptionStatePage(
              //               status: SubscribeStatus,
              //               paidAt: DateTime.now(),
              //               expiresAt: DateTime.now(),
              //               myLocale: widget.locale,
              //             ),
              //         transitionsBuilder:
              //             (context, animation, secondaryAnimation, child) {
              //               return ScaleTransition(
              //                 scale: animation.drive(
              //                   Tween(
              //                     begin: 0.8,
              //                     end: 1.0,
              //                   ).chain(CurveTween(curve: Curves.easeOutBack)),
              //                 ),
              //                 child: FadeTransition(
              //                   opacity: animation,
              //                   child: child,
              //                 ),
              //               );
              //             },
              //         transitionDuration: const Duration(milliseconds: 300),
              //       ),
              //     );
              //   },
              // ),
              // SizedBox(height: 16),

              // Privacy Policy --------------------------
              _buildQuickActionCard(
                title: S.of(context).ContactUs,
                subtitle: S.of(context).ContactUsForMore,
                icon: Icons.contact_support_rounded,
                gradientColors: const [Color(0xff1E3A8A), Color(0xff2563EB)],
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          ContactUsPage(myLocale: widget.locale),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              scale: animation.drive(
                                Tween(
                                  begin: 0.8,
                                  end: 1.0,
                                ).chain(CurveTween(curve: Curves.easeOutBack)),
                              ),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),

              SizedBox(height: 16),
              // Contact Us --------------------------
              _buildQuickActionCard(
                title: S.of(context).PrivacyPolicy,
                subtitle: S.of(context).LearnMoreAboutPrivacy,
                icon: Icons.privacy_tip_rounded,
                gradientColors: const [Color(0xff1E3A8A), Color(0xff2563EB)],
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Privacypolicy(myLocale: widget.locale),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              scale: animation.drive(
                                Tween(
                                  begin: 0.8,
                                  end: 1.0,
                                ).chain(CurveTween(curve: Curves.easeOutBack)),
                              ),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              // LogOut Button here -------------------------------
              _buildQuickActionCard(
                title: S.of(context).LogOut,
                subtitle: S.of(context).LogOutFromAccount,
                icon: Icons.logout_rounded,
                gradientColors: const [Color(0xffD10000), Color(0xffFF0000)],
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          WarningLogOutPage(locale: widget.locale),

                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              scale: animation.drive(
                                Tween(
                                  begin: 0.8,
                                  end: 1.0,
                                ).chain(CurveTween(curve: Curves.easeOutBack)),
                              ),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                },
              ),
              SizedBox(height: 150),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _navigationList();

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 30,
              offset: const Offset(-10, -10),
            ),
          ],
          border: Border.all(
            color: const Color(0xff1E3A8A).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              setState(() {
                _selectedNavigation = value;
                if (value != 0) {
                  _pullProgress = 0.0;
                  isRefreshing = false;
                }
                if (value == 1) {
                  // Purchases tab
                  fetchPurchesData(
                    currentUsername,
                  ); // Refresh purchases when visiting the page
                }
                if (value == 3) {
                  // Bookmarks tab
                  fetchBookmarkss(); // Refresh bookmarks when visiting the page
                }
              });
            },
            currentIndex: _selectedNavigation,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedFontSize: 12,
            unselectedFontSize: 10,
            selectedIconTheme: const IconThemeData(size: 26),
            unselectedIconTheme: const IconThemeData(size: 22),
            selectedItemColor: const Color(0xff1E3A8A),
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedNavigation == 0
                        ? const Color(0xff1E3A8A).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.home_rounded),
                ),
                label: S.of(context).home,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedNavigation == 1
                        ? const Color(0xff1E3A8A).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shopping_cart_rounded),
                ),
                label: S.of(context).Purches,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedNavigation == 2
                        ? const Color(0xff1E3A8A).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add),
                ),
                label: S.of(context).NewOne,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedNavigation == 3
                        ? const Color(0xff1E3A8A).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.bookmark_rounded),
                ),
                label: S.of(context).BookMark,
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _selectedNavigation == 4
                        ? const Color(0xff1E3A8A).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_rounded),
                ),
                label: S.of(context).Settings,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (_selectedNavigation != 0) {
                return false;
              }
              return _handleScrollNotification(notification);
            },
            child: pages[_selectedNavigation],
          ),
          if (_selectedNavigation == 0) _buildRefreshBanner(context),
          if (isLoading) _buildLoadingOverlay(),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
