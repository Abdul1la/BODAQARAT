import 'package:aqarat_flutter_project/app_theme.dart';
import 'package:aqarat_flutter_project/backend/get_post.dart';
import 'package:aqarat_flutter_project/backend/get_user.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/postsDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class officeProfile extends StatefulWidget {
  final Locale myLocale;
  final data;
  final String username;
  @override
  const officeProfile({
    super.key,
    required this.myLocale,
    this.data,
    required this.username,
  });
  State<officeProfile> createState() =>
      _officeProfile(MyLocale: myLocale, Data: data);
}

class _officeProfile extends State<officeProfile> {
  final Locale MyLocale;
  final Data;

  User user_info = User(
    username: "loading...",
    email: "loading...",
    phoneNum: "loading...",
    firstName: "loading...",
    lastName: "loading...",
    bio: "loading...",
    profilePic: "https://example.com/profile.jpg",
    backPic: "https://example.com/back.jpg",
  );
  List<Posts> postsByUser = [];
  bool _isUserLoading = true;
  bool _isPostsLoading = true;

  bool get _isInitialLoading => _isUserLoading || _isPostsLoading;

  Future<void> CallNumber(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      debugPrint('Phone number unavailable');
      return;
    }
    var cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) {
      debugPrint('Phone number unavailable');
      return;
    }
    if (!cleaned.startsWith('+')) {
      cleaned = '$cleaned';
    }
    final uri = Uri(scheme: 'tel', path: cleaned);
    if (!await launchUrl(uri)) {
      debugPrint('Could not open dialer');
    }
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1E3A8A), Color(0xff0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff1E3A8A).withOpacity(0.2),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.home_work_outlined,
                color: Color(0xff1E3A8A),
                size: 44,
              ),
              const SizedBox(height: 18),
              Text(
                S.of(context).Loading,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff0F172A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).Fetching_The_Last_Update_To_You,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xff1E3A8A).withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              const LinearProgressIndicator(
                minHeight: 6,
                backgroundColor: Color(0xffE0E7FF),
                valueColor: AlwaysStoppedAnimation(Color(0xff1E3A8A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchUserData() async {
    try {
      final fetchedUser = await fetchUser(widget.username);
      if (!mounted) return;
      setState(() {
        if (fetchedUser != null) {
          user_info = fetchedUser;
        }
        _isUserLoading = false;
      });
      if (fetchedUser == null) {
        debugPrint("User not found");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUserLoading = false;
      });
      debugPrint('Failed to fetch user: $e');
    }
  }

  Future<void> fetchPostsData() async {
    try {
      final fetchedPosts = await fetchPost(
        widget.username,
        widget.myLocale.languageCode,
      );
      if (!mounted) return;
      setState(() {
        postsByUser = fetchedPosts;
        isBookMarked = List.generate(postsByUser.length, (_) => false);
        isAvilable = List.generate(postsByUser.length, (_) => true);
        _isPostsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isPostsLoading = false;
      });
      debugPrint('Failed to fetch posts: $e');
    }
  }

  Future<void> _handleRefresh() async {
    await Future.wait([fetchUserData(), fetchPostsData()]);
  }

  int get postCount => postsByUser.length;
  int get availableCount =>
      postsByUser.where((post) => post.is_available).length;

  _officeProfile({required this.MyLocale, this.Data});
  List<bool> isBookMarked = [false];
  List<bool> isAvilable = [false];

  void initState() {
    super.initState();
    fetchUserData();
    fetchPostsData();
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
      theme: AppTheme.theme,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            AnimatedOpacity(
              opacity: _isInitialLoading ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              child: IgnorePointer(
                ignoring: _isInitialLoading,
                child: _buildMainContent(context),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: _isInitialLoading
                  ? _buildLoadingOverlay(context)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: const Color(0xff1E3A8A),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader(context)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            sliver: _buildPostsGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        // Cover Image Section
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Background Cover
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff1D4ED8), Color(0xff1E3A8A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image:
                    (user_info.backPic != null && user_info.backPic!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(user_info.backPic!),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.35),
                          BlendMode.darken,
                        ),
                      )
                    : null,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialButton(
                        onPressed: () => Navigator.of(context).pop(),
                        color: Colors.black.withOpacity(0.35),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                        minWidth: 40,
                        height: 40,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              S.of(context).Avilable,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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

            // Profile Avatar
            Positioned(
              bottom: -50,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: const Color(0xffE0E7FF),
                      backgroundImage:
                          (user_info.profilePic != null &&
                              user_info.profilePic!.isNotEmpty)
                          ? NetworkImage(user_info.profilePic!)
                          : null,
                      child:
                          (user_info.profilePic == null ||
                              user_info.profilePic!.isEmpty)
                          ? const Icon(
                              Icons.person,
                              size: 44,
                              color: Color(0xff2567E8),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // Profile Info Card
        const SizedBox(height: 60),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Name
              Text(
                "${user_info.firstName} ${user_info.lastName}".trim(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff0F172A),
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              // Bio
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 60),
                child: SingleChildScrollView(
                  child: Text(
                    user_info.bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Stats
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildStatChip(
                        context,
                        label: S.of(context).Posts,
                        value: "$postCount",
                      ),
                    ),
                    const VerticalDivider(
                      color: Color(0xffE5E7EB),
                      thickness: 1,
                      indent: 8,
                      endIndent: 8,
                    ),
                    Expanded(
                      child: _buildStatChip(
                        context,
                        label: S.of(context).Avilable,
                        value: "$availableCount",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xffE5E7EB), height: 1),
              const SizedBox(height: 16),

              // Contact Info
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(Icons.phone_outlined, user_info.phoneNum),
                  if (user_info.email.isNotEmpty)
                    _buildInfoChip(Icons.mail_outline, user_info.email),
                ],
              ),

              const SizedBox(height: 16),

              // Call Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff111827),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  onPressed: () => CallNumber(user_info.phoneNum),
                  icon: const Icon(Icons.phone, color: Colors.white, size: 20),
                  label: Text(
                    S.of(context).CallNow,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff0F172A),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xff6B7280), fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xff2567E8), size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xff0F172A),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsGrid(BuildContext context) {
    if (postsByUser.isEmpty) {
      return SliverToBoxAdapter(child: _buildEmptyPostsState(context));
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.52,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        return _PostCard(
          post: postsByUser[index],
          username: user_info.username,
          profilePic: user_info.profilePic ?? '',
          availabilityLabel: postsByUser[index].is_available
              ? S.of(context).Avilable
              : S.of(context).NotAvilable,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => itemDetails(
                  myLocale: MyLocale,
                  username: widget.username,
                  profilePic: user_info.profilePic ?? '',
                  location: postsByUser[index].location,
                  price: postsByUser[index].price,
                  area: postsByUser[index].area,
                  bedroom: postsByUser[index].room_num,
                  bathroom: postsByUser[index].bathroom_num,
                  roomNum: postsByUser[index].room_num,
                  discription: postsByUser[index].content,
                  facade: postsByUser[index].facade,
                  condetion: postsByUser[index].condetion,
                  floorNum: postsByUser[index].floor_num,
                  phoneNum: postsByUser[index].phone_num,
                  city: postsByUser[index].city,
                  address: postsByUser[index].address,
                  state: postsByUser[index].type_name,
                  available: postsByUser[index].is_available,
                  image1: postsByUser[index].media_path1,
                  image2: postsByUser[index].media_path2,
                  image3: postsByUser[index].media_path3,
                  image4: postsByUser[index].media_path4,
                  postID: 1,
                ),
              ),
            );
          },
        );
      }, childCount: postsByUser.length),
    );
  }

  Widget _buildEmptyPostsState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 48, color: Color(0xff9CA3AF)),
          const SizedBox(height: 12),
          Text(
            S.of(context).NothingHereYet,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff1F2937),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            S.of(context).NoPropertyiesFound,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff6B7280),
              height: 1.4,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Posts post;
  final String username;
  final String profilePic;
  final String availabilityLabel;
  final VoidCallback onTap;

  const _PostCard({
    required this.post,
    required this.username,
    required this.profilePic,
    required this.availabilityLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x15000000),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: profilePic.isNotEmpty
                        ? Image.network(
                            profilePic,
                            height: 26,
                            width: 26,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 26,
                            width: 26,
                            color: const Color(0xffE0E7FF),
                            child: const Icon(Icons.person, size: 16),
                          ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff111827),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: post.media_path1.isNotEmpty
                          ? Image.network(post.media_path1, fit: BoxFit.cover)
                          : Container(color: const Color(0xffE5E7EB)),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: post.is_available
                              ? const Color(0xff10B981)
                              : const Color(0xffEF4444),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          availabilityLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatPrice(post.price),
                    style: const TextStyle(
                      color: Color(0xff1E3A8A),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Color(0xff6B7280),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${post.city}, ${post.address}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xff6B7280),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIconStat(Icons.bed, post.room_num),
                      _buildIconStat(Icons.bathtub, post.bathroom_num),
                      _buildIconStat(Icons.square_foot, post.floor_num),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildIconStat(IconData icon, int value) {
  return Row(
    children: [
      Icon(icon, size: 18, color: const Color(0xff2567E8)),
      const SizedBox(width: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xff1F2937),
          ),
        ),
    ],
  );
}

String _formatPrice(dynamic rawValue) {
  if (rawValue == null) return "--";
  final trimmed = rawValue.toString().trim();
  if (trimmed.isEmpty || trimmed == "--") return "--";
  return trimmed.startsWith("\$") ? trimmed : "\$$trimmed";
}
}
