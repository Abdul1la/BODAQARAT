import 'dart:async';
import 'dart:ui' as ui;
import 'package:aqarat_flutter_project/AboutUs.dart';
import 'package:aqarat_flutter_project/ContactUs.dart';
import 'package:aqarat_flutter_project/PrivacyPolicy.dart';
import 'package:aqarat_flutter_project/app_theme.dart';
import 'package:aqarat_flutter_project/backend/get_post.dart';
import 'package:aqarat_flutter_project/backend/reklam.dart';
import 'package:aqarat_flutter_project/global.dart';
import 'package:flutter/material.dart';
import 'package:aqarat_flutter_project/flutter_notification.dart';
import 'package:aqarat_flutter_project/postsDetail.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:aqarat_flutter_project/search_page.dart';
import 'package:aqarat_flutter_project/askForLogin.dart';
import 'package:aqarat_flutter_project/Office_Profile.dart';
import 'package:aqarat_flutter_project/navigation.dart';
import 'package:aqarat_flutter_project/theme_settings_page.dart';

class ChangeLocale extends StatefulWidget {
  final Locale myLocaly;
  const ChangeLocale({super.key, required this.myLocaly});

  @override
  State<ChangeLocale> createState() => ChangeLocaleState(MyLocaly: myLocaly);
}

class ChangeLocaleState extends State<ChangeLocale> {
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
  late int postsCount = 0;
  String username = usernameGlobal;
  List<PostsInDB> futurePosts = [];
  bool isLoading = true;
  bool isRefreshing = false;
  double _pullProgress = 0.0;
  List<String> adImages = [];
  // Update these asset paths to your custom illustrations.
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
        username,
      );
      setState(() {
        futurePosts = fetchedPosts;
        isBookmarked = List.generate(futurePosts.length, (index) => false);
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

  List<bool> isBookmarked = [];
  List<bool> isAvilable = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  void initState() {
    super.initState();

    // Fetch all posts
    fetchPostsData();

    // Fetch ads images
    fetechads();
    // Initialize bookmarks list
    isBookmarked = List.generate(futurePosts.length, (index) => false);
    // isAvilable = List.generate(futurePosts.length, (index) => true);

    // Start the timer for automatic page scrolling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
        if (futurePosts.isNotEmpty) {
          if (_currentPage < futurePosts.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          if (_pageController.hasClients) {
            _pageController.animateToPage(
              _currentPage,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    });
  }

  // WHEN LANGUAGE CHANGED ALL POSTS SHOULD BE REFETCHED

  @override
  void didUpdateWidget(covariant MyApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the locale changed, refetch posts
    if (oldWidget.locale != widget.locale) {
      fetchPostsData();
    }
  }

  // dispose ----------------
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  int _selectedNavigation = 0;

  // Function called when pull-to-refresh is triggered
  Future<void> refreshData() async {
    // Subtle haptic feedback for a modern feel
    HapticFeedback.lightImpact();
    setState(() {
      isRefreshing = true;
      _pullProgress = 1.0;
    });

    try {
      final fetchedPosts = await fetchAllPosts(
        widget.locale.languageCode,
        username,
      );
      if (mounted) {
        setState(() {
          futurePosts = fetchedPosts;
          isBookmarked = List.generate(futurePosts.length, (index) => false);
        });
      }
    } catch (e) {
      print('Error refreshing posts: $e');
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
          fetechads();
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
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.25),
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
                            ? S.of(context).RefreshingContent
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
                            ? S.of(context).SwipeDownToRefresh
                            : S.of(context).FetchingTheLatest,
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.secondary,
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
                color: Theme.of(context).colorScheme.surface.withOpacity(0.92),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.28),
                    blurRadius: 34,
                    offset: const Offset(0, 20),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.12),
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
                            Icons.home_work_rounded,
                            color: Color(0xff1E3A8A),
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    S.of(context).Loading,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).Fetching_The_Last_Update_To_You,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.72),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 26),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
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

  Widget _buildLockedSection({
    required BuildContext context,
    required String title,
    required String description,
    required String helperText,
    required String actionLabel,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onAction,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 60),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xff0F172A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.last.withOpacity(0.3),
                    blurRadius: 32,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Icon(icon, size: 54, color: Colors.white),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xffE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    helperText,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        actionLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _navigationList() {
    return [
      // Home Page
      RefreshIndicator(
        onRefresh: refreshData,
        color: Theme.of(context).colorScheme.primary,
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
                              colors: [
                                Theme.of(context).colorScheme.surface,
                                Colors.grey[50]!,
                              ],
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
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.search,
                                  color: Theme.of(context).colorScheme.primary,
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
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff1E3A8A),
                        const Color(0xff3B82F6),
                      ],
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
                      widget.onChangeLocale(value);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 20,
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'en',
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
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Book Mark Button -------------------------
                              Expanded(
                                child: IconButton(
                                  icon: Icon(
                                    isBookmarked[index]
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isBookmarked[index]
                                        ? Colors.orange
                                        : Color(0xff1E3A8A),
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => askForLogin(
                                              myLocale: widget.locale,
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
                                                position: animation.drive(
                                                  tween,
                                                ),
                                                child: child,
                                              );
                                            },
                                        transitionDuration: const Duration(
                                          milliseconds: 400,
                                        ),
                                      ),
                                    );
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
                                  // take the title from data base
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  // take the Location from the data base ------------------
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
      _buildLockedSection(
        context: context,
        title: S.of(context).Purches,
        description: S.of(context).needToLoginPurches,
        helperText: S.of(context).CreateNewAccount,
        actionLabel: S.of(context).SignUp,
        icon: Icons.shopping_bag_rounded,
        gradientColors: const [Color(0xff1E3A8A), Color(0xff2563EB)],
        onAction: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  askForLogin(myLocale: widget.locale),
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
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
      ),
      // book Mark Page --------------------------
      _buildLockedSection(
        context: context,
        title: S.of(context).BookMark,
        description: S.of(context).needToLoginBookMark,
        helperText: S.of(context).CreateNewAccount,
        actionLabel: S.of(context).SignUp,
        icon: Icons.bookmark_added_rounded,
        gradientColors: const [Color(0xff1E3A8A), Color(0xff2563EB)],
        onAction: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  askForLogin(myLocale: widget.locale),
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
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
      ),

      Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 30),

            // Enhanced Create Account Button
            SizedBox(height: 16),
            _buildQuickActionCard(
              title: S.of(context).createAccount,
              subtitle: S.of(context).CreateNewAccount,
              icon: Icons.person_outline_rounded,
              gradientColors: const [Color(0xff7F7FD5), Color(0xff86A8E7)],
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        askForLogin(myLocale: widget.locale),
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
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _navigationList();

    return Scaffold(
      drawer: const Drawer(),
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
                  child: const Icon(Icons.bookmark_rounded),
                ),
                label: S.of(context).BookMark,
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
