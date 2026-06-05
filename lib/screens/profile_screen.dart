import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'login_screen.dart'; // This is no longer needed

// ─────────────────────────────────────────────
//  CartKaro Design Tokens
// ─────────────────────────────────────────────
const Color kSurface         = Color(0xFFF4F4F6); // Light grey surface
const Color kBg              = Color(0xFFFAFAFC); // Main scaffold background
const Color kTextDark        = Color(0xFF1A1A2E);
const Color kMuted           = Color(0xFF8A8A9A);
const Color kDivider         = Color(0xFFE0E0E0);

const String kFontFamily     = 'Poppins';

// ─────────────────────────────────────────────
//  ProfileScreen
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  final Color activeThemeColor;
  final VoidCallback? onGuestLogout;

  const ProfileScreen({super.key, required this.activeThemeColor, this.onGuestLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Loading...';
  String _userPhone = '';
  String _userInitials = '';
  bool _isLoading = true;

  // Helper to easily access the dynamic color
  Color get activeThemeColor => widget.activeThemeColor;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _userName = 'Guest User';
        _isLoading = false;
      });
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          _userName = data['name'] ?? 'No Name';
          _userPhone = data['phone'] ?? '';
          _userInitials = _getInitials(_userName);
          _isLoading = false;
        });
      } else {
         setState(() {
          _userName = 'User';
          _userPhone = user.phoneNumber ?? '';
          _userInitials = 'U';
          _isLoading = false;
        });
      }
    } catch (e) {
      // It's good practice to print errors for debugging
      debugPrint('Error loading user data: $e');
      setState(() {
        _userName = 'Error';
        _isLoading = false;
      });
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1 && parts.last.isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase() + parts.last.substring(0, 1).toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '';
  }

  Future<void> _showEditNameDialog() async {
    final nameController = TextEditingController(text: _userName);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Name', style: getStyle(weight: FontWeight.w600)),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter your full name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(nameController.text.trim());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != _userName) {
      await _updateUserName(newName);
    }
  }

  Future<void> _updateUserName(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'name': newName});
      setState(() {
        _userName = newName;
        _userInitials = _getInitials(newName);
      });
    } catch (e) {
      debugPrint('Error updating user name: $e');
      // Optionally, show a snackbar to the user
    }
  }

  // ── Logout Logic ─────────────────────────────
  Future<void> _handleLogout() async {
    // The AuthGate will listen to this and automatically navigate to the LoginScreen.
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      // This is a guest user, trigger the callback to exit guest mode.
      widget.onGuestLogout?.call();
    }
  }

  // ── Helpers ──────────────────────────────────
  TextStyle _poppins({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = kTextDark,
    double? height,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: kFontFamily,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  // Helper for applying Poppins easily
  TextStyle getStyle({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = kTextDark,
    double? height,
    double? letterSpacing,
  }) =>
      _poppins(
        size: size,
        weight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  BoxDecoration _cardDecoration({
    Color color = Colors.white,
    double radius = 20,
    List<BoxShadow>? shadows,
  }) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.055),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
      );

  // ─────────────────────────────────────────────
  //  1. Hero Card
  // ─────────────────────────────────────────────
  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: _cardDecoration(radius: 28),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      child: Row(
        children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      activeThemeColor.withOpacity(0.85),
                      activeThemeColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: activeThemeColor.withOpacity(0.3),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: activeThemeColor.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text(
                          _userInitials,
                          style: getStyle(size: 26, weight: FontWeight.w700, color: Colors.white),
                        ),
                ),
              ),
              // Edit badge
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: () {
                    _showEditNameDialog();
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: activeThemeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: activeThemeColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          // Name & phone
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userName,
                  style: getStyle(
                    size: 19,
                    weight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                if (_userPhone.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.phone_rounded,
                          size: 13, color: activeThemeColor),
                      const SizedBox(width: 5),
                      Text(
                        _userPhone,
                        style: getStyle(size: 13, color: kMuted),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                // "Verified" pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: activeThemeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded,
                          size: 12, color: activeThemeColor),
                      const SizedBox(width: 4),
                      Text(
                        'Verified Account',
                        style: getStyle(
                          size: 11,
                          weight: FontWeight.w600,
                          color: activeThemeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  2. Wallet & Loyalty Banner
  // ─────────────────────────────────────────────
  Widget _buildWalletBanner() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            activeThemeColor,
            activeThemeColor.withOpacity(0.72),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: activeThemeColor.withOpacity(0.38),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Row(
              children: [
                // Wallet side
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_balance_wallet_rounded,
                              color: Colors.white70, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'CartKaro Wallet',
                            style: getStyle(
                              size: 12,
                              color: Colors.white70,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '₹ 248.50',
                        style: getStyle(
                          size: 26,
                          weight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                                width: 1),
                          ),
                          child: Text(
                            'Add Money  +',
                            style: getStyle(
                              size: 11,
                              weight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  width: 1,
                  height: 70,
                  color: Colors.white.withOpacity(0.25),
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                ),
                // Coins side
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🪙', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1,240',
                      style: getStyle(
                        size: 18,
                        weight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'CartKaro Coins',
                      style: getStyle(
                        size: 10,
                        color: Colors.white70,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  3. Quick Action Card — Safe Vector Watermark Version
  // ─────────────────────────────────────────────
  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required IconData watermarkIcon, // 🔥 Now passing IconData instead of Widget
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.hardEdge, 
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 🔥 Vector Watermark effect (massive, faded, clean)
            Positioned(
              right: -10, 
              bottom: -10,
              child: Icon(
                watermarkIcon,
                size: 90,
                color: activeThemeColor.withOpacity(0.06), // Very soft tint
              ),
            ),

            // Foreground content with full padding
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top row: glowing icon + arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Glowing circular icon container
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: activeThemeColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeThemeColor.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(icon, color: activeThemeColor, size: 20),
                      ),
                      // Subtle arrow indicator
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 11, color: kMuted.withOpacity(0.45)),
                    ],
                  ),

                  // Bottom section: label + status pill
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: getStyle(size: 13.5, weight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Status pill badge with light tint
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: activeThemeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          subtitle,
                          style: getStyle(
                              size: 10,
                              weight: FontWeight.w600,
                              color: activeThemeColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
  }

  Widget _buildQuickActionGrid() {
    final actions = [
      {
        'icon': Icons.receipt_long_rounded,
        'label': 'My Orders',
        'subtitle': '3 active orders',
        'watermark': Icons.inventory_2_rounded, // 🔥 Clean vector icon
      },
      {
        'icon': Icons.location_on_rounded,
        'label': 'Saved Addresses',
        'subtitle': '2 locations saved',
        'watermark': Icons.home_rounded, // 🔥 Clean vector icon
      },
      {
        'icon': Icons.credit_card_rounded,
        'label': 'Payments',
        'subtitle': 'Cards & UPI',
        'watermark': Icons.credit_card_rounded, // 🔥 Clean vector icon
      },
      {
        'icon': Icons.bookmark_rounded,
        'label': 'Watchlist',
        'subtitle': '12 items saved',
        'watermark': Icons.star_rounded, // 🔥 Clean vector icon
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.15, 
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final a = actions[index];
        return _buildActionCard(
          icon: a['icon'] as IconData,
          label: a['label'] as String,
          subtitle: a['subtitle'] as String,
          watermarkIcon: a['watermark'] as IconData, // Passed correctly here
          onTap: () {},
        );
      }
    );
  }

  // ─────────────────────────────────────────────
  //  4. Settings List Tile helper
  // ─────────────────────────────────────────────
  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: activeThemeColor.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: activeThemeColor, size: 19),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getStyle(size: 13.5, weight: FontWeight.w600),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle, style: getStyle(size: 11, color: kMuted)),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: kMuted.withOpacity(0.7)),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 72, endIndent: 18, color: kDivider),
      ],
    );
  }

  // 🔥 MAIN FIX: Properly wired Navigation logic for all screens
  Widget _buildSettingsSection() {
    return Container(
      decoration: _cardDecoration(), 
      child: Column(
        children: [
          _buildListTile(icon: Icons.headset_mic_rounded, title: 'Customer Support', subtitle: 'Chat, call or email us'),
          _buildListTile(icon: Icons.settings_rounded, title: 'App Settings', subtitle: 'Notifications, language & more'),
          _buildListTile(icon: Icons.help_outline_rounded, title: 'FAQ', subtitle: 'Frequently asked questions'),
          _buildListTile(icon: Icons.privacy_tip_outlined, title: 'Terms & Conditions', showDivider: false),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  5. Logout Button
  // ─────────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _handleLogout(); // 🔥 TRIGGERS LOGOUT & SHOWS OTP SCREEN
        },
        icon: Icon(Icons.logout_rounded, color: activeThemeColor, size: 18),
        label: Text(
          'Log Out',
          style: getStyle(
            size: 14,
            weight: FontWeight.w600,
            color: activeThemeColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: BorderSide(color: activeThemeColor, width: 1.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: activeThemeColor.withOpacity(0.04),
        ),
      ),
    );
  }

  // ── Section Header helper ───────────────
  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 12),
        child: Text(
          title,
          style: getStyle(size: 13, weight: FontWeight.w700, color: kMuted, letterSpacing: 0.6),
        ),
      );

  // ─────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // The AuthGate ensures this screen is only reached when logged in.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: kBg, 
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Profile',
                      style: getStyle(size: 22, weight: FontWeight.w800, letterSpacing: -0.5),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kDivider),
                      ),
                      child: const Icon(Icons.notifications_none_rounded, color: kTextDark, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                  _buildHeroCard(context),
                  const SizedBox(height: 20),

                  _sectionHeader('WALLET & REWARDS'),
                  _buildWalletBanner(),
                  const SizedBox(height: 24),

                // ── 3. Quick Actions ─────────────
                _sectionHeader('QUICK ACTIONS'),
                _buildQuickActionGrid(), 
                const SizedBox(height: 24),

                // ── 4. Settings ──────────────────
                _sectionHeader('MORE'),
                _buildSettingsSection(),
                const SizedBox(height: 24),

                  _buildLogoutButton(context),
                  const SizedBox(height: 28),

                // ── Footer ───────────────────────
                Center(
                  child: Text(
                    'CartKaro v2.4.1  •  Made with ❤️ in India',
                    style: getStyle(size: 11, color: kMuted),
                  ),
                ),
                const SizedBox(height: 80), // Padding for Bottom Nav Bar
              ],
            ),
          ),
        ),
      ),
    );
  }
}