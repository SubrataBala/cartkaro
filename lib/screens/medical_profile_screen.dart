import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// ── NAVIGATION IMPORTS ──
import 'rewards_screen.dart';
import 'rating_review_screen.dart';
import 'claim_gift_card_screen.dart';
import 'share_app_screen.dart';
import 'faq_screen.dart';
import 'about_us_screen.dart';
import 'customer_support_screen.dart';
import 'terms_conditions_screen.dart';
import 'app_settings_screen.dart';
import 'shopping_list_screen.dart';
import 'prescriptions_screen.dart';
import 'health_articles_screen.dart';
import 'track_order_screen.dart';
import 'my_orders_screen.dart'; // 🔥 Updated to My Orders
import 'addresses_screen.dart';
import 'payments_screen.dart';
import 'wallet_screen.dart';         // 🔥 CartKaro Wallet
import 'cartkaro_plus_screen.dart';  // 🔥 CartKaro Plus
import 'cartkaro_elite_screen.dart'; // 🔥 CartKaro Elite

// ─────────────────────────────────────────────
//  CartKaro Premium Design Tokens (Medical)
// ─────────────────────────────────────────────
const Color kTheme = Color(0xFF1565C0); // Medical Blue
const Color kBg = Color(0xFFFFFFFF);
const Color kSurface = Color(0xFFFAFAFA);
const Color kBorder = Color(0xFFEBEBEB);
const Color kTextDark = Color(0xFF222222);
const Color kMuted = Color(0xFF999999);
const String kFont = 'Poppins';

class MedicalProfileScreen extends StatefulWidget {
  final VoidCallback? onGuestLogout;

  const MedicalProfileScreen({super.key, this.onGuestLogout});

  @override
  State<MedicalProfileScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends State<MedicalProfileScreen> {
  String _userName = 'Loading...';
  String _userPhone = '';
  String _userGmail = '';
  String _userInitials = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ── Firebase Data Loading ─────────────────────────────────────
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _userName = 'Guest User';
        _userInitials = 'G';
        _isLoading = false;
      });
      return;
    }

    String phone = user.phoneNumber ?? 'No Phone';

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        final d = doc.data()!;
        setState(() {
          _userName = d['name'] ?? 'Add Name';
          _userPhone = d['phone'] ?? phone;
          _userGmail = d['gmail'] ?? '';
          _userInitials = _initials(_userName);
          _isLoading = false;
        });
      } else {
        setState(() {
          _userName = 'Add Name';
          _userPhone = phone;
          _userInitials = 'U';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('ProfileScreen Error: $e');
      setState(() {
        _userName = 'Add Name';
        _userPhone = phone;
        _userInitials = 'U';
        _isLoading = false;
      });
    }
  }

  // ── Get Letters for Initials ─────────────────────────
  String _initials(String name) {
    if (name.isEmpty || name == 'Add Name' || name == 'Error Loading') {
      return 'U';
    }
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';

    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  // ── Edit Name Dialog ──────────────────────────
  Future<void> _editName() async {
    final ctrl = TextEditingController(
      text: _userName == 'Add Name' ? '' : _userName,
    );
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Edit Name', style: _s(size: 18, weight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: _s(size: 15),
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            hintStyle: _s(size: 14, color: kMuted),
            filled: true,
            fillColor: kSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kTheme, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: _s(size: 14, color: kMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: kTheme,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Save',
              style: _s(size: 14, weight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && result != _userName) {
      await _updateField(
        'name',
        result,
        onSuccess: () {
          setState(() {
            _userName = result;
            _userInitials = _initials(result);
          });
        },
      );
    }
  }

  // ── Edit Gmail Dialog ─────────────────────────
  Future<void> _editGmail() async {
    final ctrl = TextEditingController(text: _userGmail);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Edit Gmail', style: _s(size: 18, weight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          style: _s(size: 15),
          decoration: InputDecoration(
            hintText: 'Enter Gmail address',
            hintStyle: _s(size: 14, color: kMuted),
            filled: true,
            fillColor: kSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kTheme, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: _s(size: 14, color: kMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: kTheme,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Save',
              style: _s(size: 14, weight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      await _updateField(
        'gmail',
        result,
        onSuccess: () {
          setState(() {
            _userGmail = result;
          });
        },
      );
    }
  }

  Future<void> _updateField(
    String field,
    String value, {
    required VoidCallback onSuccess,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        field: value,
      }, SetOptions(merge: true));
      onSuccess();
    } catch (e) {
      debugPrint('Update $field error: $e');
    }
  }

  Future<void> _logout() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      widget.onGuestLogout?.call();
    }
  }

  // ── Helper Methods ─────────────────────────
  TextStyle _s({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = kTextDark,
    double? letterSpacing,
    double? height,
  }) => TextStyle(
    fontFamily: kFont,
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 12),
    child: Text(
      text.toUpperCase(),
      style: _s(
        size: 12,
        weight: FontWeight.w700,
        color: kMuted,
        letterSpacing: 1.2,
      ),
    ),
  );

  // ─────────────────────────────────────────────
  //  UI WIDGETS
  // ─────────────────────────────────────────────

  // ── Hero Section (Profile Info) ──
  Widget _buildHero() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Dynamic Initials Avatar - Medical Blue
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: kTheme,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: kTheme.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _userInitials,
                      style: const TextStyle(
                        fontFamily: kFont,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 20),
          // User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _editName,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _userName,
                          style: _s(
                            size: 18,
                            weight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.edit_outlined, size: 16, color: kMuted),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 14, color: kMuted),
                    const SizedBox(width: 6),
                    Text(
                      _userPhone.isEmpty || _userPhone == 'No Phone'
                          ? 'Add Phone'
                          : _userPhone,
                      style: _s(size: 13, color: kMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _editGmail,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.mail_outline_rounded,
                        size: 14,
                        color: kMuted,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _userGmail.isEmpty ? 'Add your email' : _userGmail,
                          style: _s(
                            size: 13,
                            color: _userGmail.isEmpty ? kTheme : kMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.edit_outlined, size: 14, color: kMuted),
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

  // ── Wallet Section (Fixed Click) ──
  Widget _buildWallet() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kTheme, // Theme color ke hisaab se adjust hoga
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kTheme.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 16,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              Text(
                'CartKaro Wallet',
                style: _s(
                  size: 13,
                  color: Colors.white.withOpacity(0.9),
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹ 248.50', style: TextStyle(fontFamily: kFont, fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
              
              // 🔥 YAHAN CHANGE KIYA HAI - Sirf ye button click hoga! 🔥
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => WalletScreen(themeColor: kTheme)));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add_rounded, size: 16, color: kTheme),
                      const SizedBox(width: 4),
                      Text(
                        'Add Money',
                        style: _s(
                          size: 12,
                          weight: FontWeight.w700,
                          color: kTheme,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Premium Membership Cards ──
  Widget _buildMembershipCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // 1. CartKaro Plus (Gradient Blue)
          Expanded(
            child: GestureDetector(
              onTap: () {
                // 🔥 CartKaro Plus Navigation
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartKaroPlusScreen(themeColor: kTheme)));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ], // Deep Ocean Blue gradient
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2C5364).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.flash_on_rounded,
                      color: Colors.amber,
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'CartKaro\nPlus',
                      style: _s(
                        size: 15,
                        weight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 2. CartKaro Elite (Premium Black & Gold)
          Expanded(
            child: GestureDetector(
              onTap: () {
                // 🔥 CartKaro Elite Navigation
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CartKaroEliteScreen(themeColor: kTheme)));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF111111),
                      Color(0xFF2C2C2C),
                    ], // Matte Black
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF444444),
                    width: 0.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFFFD700),
                      size: 24,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'CartKaro\nElite',
                      style: _s(
                        size: 15,
                        weight: FontWeight.w800,
                        color: const Color(0xFFFFD700),
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Actions Grid ──
  Widget _buildQuickGrid() {
    final items = [
      {'icon': Icons.local_shipping_outlined, 'title': 'Track Order'},
      {'icon': Icons.receipt_long_rounded, 'title': 'My Orders'}, // 🔥 My Orders Setup Done
      {'icon': Icons.location_on_outlined, 'title': 'Addresses'},
      {'icon': Icons.credit_card_outlined, 'title': 'Payments'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.6,
        ),
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          return Container(
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
            ),
            child: InkWell(
              onTap: () {
                // ── QUICK ACTIONS NAVIGATION ──
                if (items[i]['title'] == 'Track Order') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TrackOrderScreen(themeColor: kTheme)));
                } else if (items[i]['title'] == 'My Orders') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MyOrdersScreen(themeColor: kTheme)));
                } else if (items[i]['title'] == 'Addresses') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressesScreen(themeColor: kTheme)));
                } else if (items[i]['title'] == 'Payments') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentsScreen(themeColor: kTheme)));
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(items[i]['icon'] as IconData, size: 22, color: kTheme),
                    const Spacer(),
                    Text(
                      items[i]['title'] as String,
                      style: _s(size: 13, weight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── More Options List ──
  Widget _buildListTile(IconData icon, String title, {bool showBorder = true}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // ── MORE OPTIONS NAVIGATION ──
            if (title == 'Rewards') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RewardsScreen(themeColor: kTheme)));
            } else if (title == 'Rating & Review') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RatingReviewScreen(themeColor: kTheme)));
            } else if (title == 'Claim Gift Card') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ClaimGiftCardScreen(themeColor: kTheme)));
            } else if (title == 'Share the App') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ShareAppScreen(themeColor: kTheme)));
            } else if (title == 'FAQ') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FaqScreen(themeColor: kTheme)));
            } else if (title == 'About Us') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen(themeColor: kTheme)));
            } else if (title == 'Customer Support') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerSupportScreen(themeColor: kTheme)));
            } else if (title == 'Terms & Conditions') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionsScreen(themeColor: kTheme)));
            } else if (title == 'App Settings') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AppSettingsScreen(themeColor: kTheme, serviceType: "medical",)));
            } else if (title == 'Shopping List') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ShoppingListScreen(themeColor: kTheme, type: "medical",)));
            } else if (title == 'Prescriptions') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrescriptionsScreen(themeColor: kTheme)));
            } else if (title == 'Health Articles') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HealthArticlesScreen(themeColor: kTheme)));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, size: 18, color: kTheme), 
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: _s(size: 14.5, weight: FontWeight.w500),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: kMuted,
                ),
              ],
            ),
          ),
        ),
        if (showBorder)
          const Divider(height: 1, indent: 64, endIndent: 20, color: kBorder),
      ],
    );
  }

  // ── Social Media Icons ──
  Widget _buildSocial() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _socialBtn(
            Colors.transparent,
            const Color(0xFFEEEEEE),
            CustomPaint(size: const Size(28, 28), painter: _InstagramPainter()),
          ),
          _socialBtn(
            Colors.black,
            Colors.black,
            CustomPaint(size: const Size(20, 20), painter: _XPainter()),
          ),
          _socialBtn(
            const Color(0xFF1877F2),
            const Color(0xFF1877F2),
            CustomPaint(size: const Size(22, 22), painter: _FacebookPainter()),
          ),
          _socialBtn(
            const Color(0xFFFF0000),
            const Color(0xFFFF0000),
            CustomPaint(size: const Size(26, 20), painter: _YouTubePainter()),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(Color bgColor, Color borderColor, Widget icon) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 70,
        height: 56,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kBg,
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(overscroll: false), // Removes jelly effect
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Padding
                  const SizedBox(height: 20),

                  _buildHero(),

                  const SizedBox(height: 24),
                  
                  // 🔥 WALLET IS HERE
                  _buildWallet(),

                  const SizedBox(height: 16),
                  
                  // 🔥 PREMIUM CARDS ARE HERE
                  _buildMembershipCards(),

                  _label('Quick Actions'),
                  _buildQuickGrid(),

                  _label('More Options'),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: kBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kBorder),
                    ),
                    child: Column(
                      children: [
                        _buildListTile(Icons.medical_information_outlined, 'Prescriptions'),
                        _buildListTile(Icons.health_and_safety_outlined, 'Health Articles'),
                        _buildListTile(Icons.list_alt_rounded, 'Shopping List'),
                        _buildListTile(Icons.emoji_events_outlined, 'Rewards'),
                        _buildListTile(
                          Icons.star_outline_rounded,
                          'Rating & Review',
                        ),
                        _buildListTile(
                          Icons.card_giftcard_rounded,
                          'Claim Gift Card',
                        ),
                        _buildListTile(
                          Icons.ios_share_rounded,
                          'Share the App',
                        ),
                        _buildListTile(Icons.help_outline_rounded, 'FAQ'),
                        _buildListTile(Icons.info_outline_rounded, 'About Us'),
                        _buildListTile(
                          Icons.support_agent_rounded,
                          'Customer Support',
                        ),
                        _buildListTile(
                          Icons.description_outlined,
                          'Terms & Conditions',
                        ),
                        _buildListTile(
                          Icons.settings_outlined,
                          'App Settings',
                          showBorder: false,
                        ),
                      ],
                    ),
                  ),

                  _label('Follow Us'),
                  _buildSocial(),

                  const SizedBox(height: 40),

                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          _logout();
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: kTheme, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Log Out',
                          style: _s(
                            size: 15,
                            weight: FontWeight.w600,
                            color: kTheme,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Center(
                    child: Text(
                      'CartKaro v2.5.0',
                      style: _s(size: 12, color: kMuted),
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding for Nav Bar
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════
//  Custom Painters — Social Logos (Ultra Premium)
// ═════════════════════════════════════════════

class _InstagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = const LinearGradient(
      colors: [
        Color(0xFFF58529),
        Color(0xFFDD2A7B),
        Color(0xFF8134AF),
        Color(0xFF515BD4),
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ).createShader(rect);
    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final boxW = size.width * 0.8;
    final boxH = size.height * 0.8;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - boxW / 2, cy - boxH / 2, boxW, boxH),
        Radius.circular(size.width * 0.25),
      ),
      paint,
    );
    canvas.drawCircle(Offset(cx, cy), size.width * 0.22, paint);
    canvas.drawCircle(
      Offset(cx + boxW * 0.25, cy - boxH * 0.25),
      size.width * 0.06,
      paint..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _XPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width;
    final h = size.height;
    path.moveTo(w * 0.02, 0);
    path.lineTo(w * 0.40, h * 0.46);
    path.lineTo(w * 0.02, h);
    path.lineTo(w * 0.14, h);
    path.lineTo(w * 0.47, h * 0.58);
    path.lineTo(w * 0.86, h);
    path.lineTo(w * 0.98, h);
    path.lineTo(w * 0.60, h * 0.52);
    path.lineTo(w * 0.96, 0);
    path.lineTo(w * 0.84, 0);
    path.lineTo(w * 0.50, h * 0.40);
    path.lineTo(w * 0.14, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FacebookPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final path = Path();

    path.moveTo(w * 0.62, h);
    path.lineTo(w * 0.62, h * 0.55);
    path.lineTo(w * 0.78, h * 0.55);
    path.lineTo(w * 0.82, h * 0.35);
    path.lineTo(w * 0.62, h * 0.35);
    path.lineTo(w * 0.62, h * 0.25);
    path.quadraticBezierTo(w * 0.62, h * 0.18, w * 0.72, h * 0.18);
    path.lineTo(w * 0.82, h * 0.18);
    path.lineTo(w * 0.82, 0);
    path.lineTo(w * 0.65, 0);
    path.quadraticBezierTo(w * 0.38, 0, w * 0.38, h * 0.28);
    path.lineTo(w * 0.38, h * 0.35);
    path.lineTo(w * 0.22, h * 0.35);
    path.lineTo(w * 0.22, h * 0.55);
    path.lineTo(w * 0.38, h * 0.55);
    path.lineTo(w * 0.38, h);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _YouTubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.35, h * 0.25);
    path.lineTo(w * 0.75, h * 0.50);
    path.lineTo(w * 0.35, h * 0.75);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
