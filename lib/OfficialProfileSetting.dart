import 'package:aqarat_flutter_project/OfficePostShow.dart';
import 'package:aqarat_flutter_project/backend/available.dart';
import 'package:aqarat_flutter_project/backend/get_post.dart';
import 'package:aqarat_flutter_project/backend/get_user.dart';
import 'package:aqarat_flutter_project/backend/postadd.dart';
import 'package:aqarat_flutter_project/generated/l10n.dart';
import 'package:aqarat_flutter_project/officeAccountInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class officialProfileSetting extends StatefulWidget {
  final Locale myLocale;
  final String? data;
  final String username;
  @override
  const officialProfileSetting({
    super.key,
    required this.myLocale,
    this.data,
    required this.username,
  });
  State<officialProfileSetting> createState() =>
      _officeProfile(MyLocale: myLocale, Data: data);
}

String _formatPrice(dynamic rawValue) {
  if (rawValue == null) return "--";
  final trimmed = rawValue.toString().trim();
  if (trimmed.isEmpty || trimmed == "--") return "--";
  return trimmed.startsWith("\$") ? trimmed : "\$$trimmed";
}

class _officeProfile extends State<officialProfileSetting> {
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
    city: "loading...",
    district: "loading...",
  );

  List<Posts> postsByUser = [];
  bool _isUserLoading = true;
  bool _isPostsLoading = true;

  bool get _isInitialLoading => _isUserLoading || _isPostsLoading;
  int get postsCount => postsByUser.length;
  int get availableCount =>
      postsByUser.where((post) => post.is_available).length;

  _officeProfile({required this.MyLocale, this.Data});

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchPostsData();
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
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUserLoading = false);
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
        _isPostsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPostsLoading = false);
    }
  }

  Future<void> _handleRefresh() async {
    await Future.wait([fetchUserData(), fetchPostsData()]);
  }

  Future<void> _handlePostAction(String action, Posts post) async {
    if (action != 'delete') return;
    final ok = await deletePost(post.post_id, post.username);
    if (!mounted) return;
    if (ok) {
      await fetchPostsData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).DeletePost)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).ErrorRefreshingPost)),
      );
    }
  }

  Future<void> _markPostUnavailableAPI(int index) async {
    final post = postsByUser[index];

    final ok = await PostAvailabilityAPI.makePostUnavailable(
      widget.username,
      post.post_id,
    );

    if (!mounted) return;

    if (ok) {
      setState(() {
        postsByUser[index] = postsByUser[index].copyWith(is_available: false);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).NotAvilable)));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update availability")));
    }
  }

  Future<void> _markPostAvailableAPI(int index) async {
    final post = postsByUser[index];

    final ok = await PostAvailabilityAPI.makePostAvailable(
      widget.username,
      post.post_id,
    );

    if (!mounted) return;

    if (ok) {
      setState(() {
        postsByUser[index] = postsByUser[index].copyWith(is_available: true);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).Avilable)));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update availability")));
    }
  }

  void _markPostUnavailable(int index) {
    final post = postsByUser[index];
    final updated = Posts(
      username: post.username,
      content: post.content,
      phone_num: post.phone_num,
      media_path1: post.media_path1,
      media_path2: post.media_path2,
      media_path3: post.media_path3,
      media_path4: post.media_path4,
      price: post.price,
      location: post.location,
      area: post.area,
      facade: post.facade,
      condetion: post.condetion,
      floor_num: post.floor_num,
      room_num: post.room_num,
      bathroom_num: post.bathroom_num,
      created_at: post.created_at,
      city: post.city,
      address: post.address,
      type_name: post.type_name,
      is_available: false,
      post_id: post.post_id,
    );
    setState(() {
      postsByUser[index] = updated;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.of(context).NotAvilable)));
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 320),
              opacity: _isInitialLoading ? 0 : 1,
              child: IgnorePointer(
                ignoring: _isInitialLoading,
                child: _buildMainContent(context),
              ),
            ),
            if (_isInitialLoading)
              const Center(child: CircularProgressIndicator()),
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
        Stack(
          clipBehavior: Clip.none,
          children: [
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () => Navigator.of(context).pop(),
                        color: Colors.black.withOpacity(0.35),
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified, color: Colors.amber),
                            const SizedBox(width: 6),
                            Text(
                              S.of(context).Avilable,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: CircleAvatar(
                radius: 62,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 58,
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
                          size: 48,
                          color: Color(0xff2567E8),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 70, 20, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 25,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "${user_info.firstName} ${user_info.lastName}".trim(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user_info.bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xff6B7280), height: 1.5),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatChip(
                      context,
                      label: S.of(context).Posts,
                      value: "$postsCount",
                    ),
                    _buildStatChip(
                      context,
                      label: S.of(context).Avilable,
                      value: "$availableCount",
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(Icons.phone_outlined, user_info.phoneNum),
                    if (user_info.email.isNotEmpty)
                      _buildInfoChip(Icons.mail_outline, user_info.email),
                    if (user_info.city != null || user_info.district != null)
                      _buildInfoChip(
                        Icons.location_on_outlined,
                        [
                          if ((user_info.city ?? '').isNotEmpty) user_info.city,
                          if ((user_info.district ?? '').isNotEmpty)
                            user_info.district,
                        ].whereType<String>().join(" • "),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff111827),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.phone, color: Colors.white),
                        label: Text(
                          S.of(context).CallNow,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xff111827),
                          side: const BorderSide(color: Color(0xffE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OfficeAccountInfo(
                                myLocale: widget.myLocale,
                                data: widget.data,
                                username: widget.username,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings_outlined),
                        label: Text(
                          S.of(context).Settings,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // onMarkUnavailable()
  Widget _buildStatChip(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Color(0xff6B7280))),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xff2567E8), size: 18),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xff0F172A),
              fontWeight: FontWeight.w600,
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
        final post = postsByUser[index];
        return _AdminPostCard(
          post: post,
          username: user_info.username,
          profilePic: user_info.profilePic ?? '',
          availabilityLabel: post.is_available
              ? S.of(context).Avilable
              : S.of(context).NotAvilable,
          isAvailable: post.is_available,
          onDelete: () => _handlePostAction('delete', post),
          onMarkUnavailable: () => _markPostUnavailableAPI(index),
          onMarkAvailable: () => _markPostAvailableAPI(index),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OfficeitemDetails(
                  myLocale: MyLocale,
                  username: widget.username,
                  profilePic: user_info.profilePic ?? '',
                  location: post.location,
                  price: post.price,
                  area: post.area,
                  bedroom: post.room_num,
                  bathroom: post.bathroom_num,
                  roomNum: post.room_num,
                  discription: post.content,
                  facade: post.facade,
                  condetion: post.condetion,
                  floorNum: post.floor_num,
                  phoneNum: post.phone_num,
                  city: post.city,
                  address: post.address,
                  state: post.type_name,
                  available: post.is_available,
                  image1: post.media_path1,
                  image2: post.media_path2,
                  image3: post.media_path3,
                  image4: post.media_path4,
                  postID: post.post_id,
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
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(24),
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
          SizedBox(
            width: 220,
            child: Text(
              S.of(context).NoPropertyiesFound,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xff6B7280), height: 1.4),
            ),
          ),
        ],
      ),
      );
    }
  }

class _AdminPostCard extends StatelessWidget {
  final Posts post;
  final String username;
  final String profilePic;
  final String availabilityLabel;
  final bool isAvailable;
  final VoidCallback onDelete;
  final VoidCallback onMarkUnavailable;
  final VoidCallback onMarkAvailable;
  final VoidCallback onTap;

  const _AdminPostCard({
    required this.post,
    required this.username,
    required this.profilePic,
    required this.availabilityLabel,
    required this.isAvailable,
    required this.onDelete,
    required this.onMarkUnavailable,
    required this.onMarkAvailable,
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
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        onDelete();
                      } else if (value == 'unavailable') {
                        onMarkUnavailable();
                      } else if (value == 'available') {
                        onMarkAvailable();
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (context) {
                      final toggleValue =
                          isAvailable ? 'unavailable' : 'available';
                      final toggleLabel = isAvailable
                          ? S.of(context).NotAvilable
                          : S.of(context).Avilable;
                      final toggleIcon = isAvailable
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined;

                      return [
                        PopupMenuItem(
                          value: toggleValue,
                          child: Row(
                            children: [
                              Icon(
                                toggleIcon,
                                size: 18,
                                color: const Color(0xff059669),
                              ),
                              const SizedBox(width: 8),
                              Text(toggleLabel),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                size: 18,
                                color: Color(0xffB91C1C),
                              ),
                              const SizedBox(width: 8),
                              Text(S.of(context).DeletePost),
                            ],
                          ),
                        ),
                      ];
                    },
                    child: const Icon(Icons.more_horiz, color: Colors.black54),
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
}
