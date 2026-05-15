import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_screen.dart'; // 🔥 IMPORTED TO CHECK LOGIN STATE

// ─────────────────────────────────────────────
//  CartKaro Design Tokens
// ─────────────────────────────────────────────
const Color kSurface         = Color(0xFFF4F4F6);
const Color kBg              = Color(0xFFFAFAFC);
const Color kTextDark        = Color(0xFF1A1A2E);
const Color kMuted           = Color(0xFF8A8A9A);

const String kFontFamily     = 'Poppins';

// ─────────────────────────────────────────────
//  ProfileScreen
// ─────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  final Color activeThemeColor;

  const ProfileScreen({super.key, required this.activeThemeColor});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Helper to easily access the dynamic color
  Color get activeThemeColor => widget.activeThemeColor;

  // ── Logout Logic ─────────────────────────────
  void _handleLogout() {
    setState(() {
      isUserLoggedIn = false;
    });
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
                  child: Text(
                    'SS', // Shyam Sundar
                    style: _poppins(
                      size: 26,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Edit badge
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: () {},
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
                  'Shyam Sundar', // Updated to your name!
                  style: _poppins(
                    size: 19,
                    weight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone_rounded,
                        size: 13, color: activeThemeColor),
                    const SizedBox(width: 5),
                    Text(
                      '+91 98765 43210',
                      style: _poppins(size: 13, color: kMuted),
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
                        style: _poppins(
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
                            style: _poppins(
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
                        style: _poppins(
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
                            style: _poppins(
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
                      style: _poppins(
                        size: 18,
                        weight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'CartKaro Coins',
                      style: _poppins(
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
  //  3. Quick Action Card (grid cell)
  // ─────────────────────────────────────────────
  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required String bgEmoji,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: _cardDecoration(),
        // 🔥 Slightly reduced padding to prevent squishing
        padding: const EdgeInsets.fromLTRB(14, 16, 12, 14),
        child: Stack(
          children: [
            // Ghost emoji background
            Positioned(
              right: -6,
              bottom: -8,
              child: Text(
                bgEmoji,
                style: const TextStyle(fontSize: 46), // 🔥 Reduced from 52
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38, // 🔥 Slightly smaller
                  height: 38,
                  decoration: BoxDecoration(
                    color: activeThemeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: activeThemeColor, size: 18), // 🔥 Reduced from 20
                ),
                const SizedBox(height: 12), // 🔥 Reduced from 20 to give text more space
                Text(
                  label,
                  style: _poppins(
                    size: 13,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: _poppins(size: 10.5, color: kMuted),
                  maxLines: 1, // Prevents overflow if text gets too long
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
        'emoji': '📦',
      },
      {
        'icon': Icons.location_on_rounded,
        'label': 'Saved Addresses',
        'subtitle': '2 locations saved',
        'emoji': '🏠',
      },
      {
        'icon': Icons.credit_card_rounded,
        'label': 'Payments',
        'subtitle': 'Cards & UPI',
        'emoji': '💳',
      },
      {
        'icon': Icons.bookmark_rounded,
        'label': 'Watchlist',
        'subtitle': '12 items saved',
        'emoji': '⭐',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        // 🔥 Changed from 1.35 to 1.15 to make the cards slightly taller and fix overflow
        childAspectRatio: 1.15,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final a = actions[index];
        return _buildActionCard(
          icon: a['icon'] as IconData,
          label: a['label'] as String,
          subtitle: a['subtitle'] as String,
          bgEmoji: a['emoji'] as String,
          onTap: () {},
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  4. Settings List Tile
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
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                        style: _poppins(
                            size: 13.5, weight: FontWeight.w600),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(subtitle,
                            style: _poppins(size: 11, color: kMuted)),
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
        if (showDivider)
          const Divider(
            height: 1,
            indent: 72,
            endIndent: 18,
            color: kSurface,
          ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildListTile(
            icon: Icons.headset_mic_rounded,
            title: 'Customer Support',
            subtitle: 'Chat, call or email us',
          ),
          _buildListTile(
            icon: Icons.settings_rounded,
            title: 'App Settings',
            subtitle: 'Notifications, language & more',
          ),
          _buildListTile(
            icon: Icons.help_outline_rounded,
            title: 'FAQ',
            subtitle: 'Frequently asked questions',
          ),
          _buildListTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Terms & Conditions',
            showDivider: false,
          ),
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
          _handleLogout(); 
        },
        icon: Icon(Icons.logout_rounded, color: activeThemeColor, size: 18),
        label: Text(
          'Log Out',
          style: _poppins(
            size: 14,
            weight: FontWeight.w600,
            color: activeThemeColor,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          side: BorderSide(color: activeThemeColor, width: 1.6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: activeThemeColor.withOpacity(0.04),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Section Header
  // ─────────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 12),
      child: Text(
        title,
        style: _poppins(
          size: 13,
          weight: FontWeight.w700,
          color: kMuted,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // 🔥 UNAUTHENTICATED STATE CHECK
    if (!isUserLoggedIn) {
      return const LoginScreen(); 
    }

    // 🔥 AUTHENTICATED STATE UI
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kBg,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top App Bar ──────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Profile',
                      style: _poppins(
                        size: 22,
                        weight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: kSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_none_rounded,
                          color: kTextDark, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── 1. Hero Card ─────────────────
                _buildHeroCard(context),
                const SizedBox(height: 20),

                // ── 2. Wallet Banner ─────────────
                _sectionHeader('WALLET & REWARDS'),
                _buildWalletBanner(),
                const SizedBox(height: 24),

                // ── 3. Quick Actions ─────────────
                _sectionHeader('QUICK ACTIONS'),
                _buildQuickActionGrid(),
                const SizedBox(height: 24),

                // ── 4. Settings ────────────────── (🔥 PRO BANNER REMOVED FROM HERE)
                _sectionHeader('MORE'),
                _buildSettingsSection(),
                const SizedBox(height: 24),

                // ── 5. Logout ────────────────────
                _buildLogoutButton(context),
                const SizedBox(height: 28),

                // ── Footer ───────────────────────
                Center(
                  child: Text(
                    'CartKaro v2.4.1  •  Made with ❤️ in India',
                    style: _poppins(size: 11, color: kMuted),
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