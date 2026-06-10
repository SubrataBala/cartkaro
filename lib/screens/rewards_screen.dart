import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RewardsScreen extends StatelessWidget {
  final Color themeColor;

  const RewardsScreen({super.key, required this.themeColor});

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? height}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, height: height);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB), // Softer background
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9FAFB),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('My Rewards', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. PREMIUM BALANCE CARD ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [themeColor, themeColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background Design Elements
                      Positioned(
                        right: -30,
                        top: -30,
                        child: CircleAvatar(radius: 70, backgroundColor: Colors.white.withOpacity(0.1)),
                      ),
                      Positioned(
                        right: 40,
                        bottom: -40,
                        child: CircleAvatar(radius: 50, backgroundColor: Colors.white.withOpacity(0.1)),
                      ),
                      
                      // Card Content
                      Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                                      child: const Text('💎', style: TextStyle(fontSize: 18)),
                                    ),
                                    const SizedBox(width: 12),
                                    Text('CartKaro Coins', style: _s(size: 14, weight: FontWeight.w600, color: Colors.white.withOpacity(0.9))),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                  child: Text('100 Coins = ₹10', style: _s(size: 11, weight: FontWeight.w600, color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Text('Total Balance', style: _s(size: 13, color: Colors.white.withOpacity(0.8))),
                            const SizedBox(height: 4),
                            Text('1,240', style: _s(size: 44, weight: FontWeight.w800, color: Colors.white, height: 1.1)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── 2. UNLOCKED REWARDS ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rewards from Orders', style: _s(size: 17, weight: FontWeight.w700)),
                    const Text('🎁', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // 🔥 Height badha di hai (190) taaki overflow na ho 🔥
              SizedBox(
                height: 190,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildRewardCard(
                      icon: '🎉',
                      title: 'You Won',
                      coins: '50',
                      date: 'Order #8892',
                      isUnlocked: true,
                    ),
                    _buildRewardCard(
                      icon: '✨',
                      title: 'You Won',
                      coins: '20',
                      date: 'Order #8841',
                      isUnlocked: true,
                    ),
                    _buildRewardCard(
                      icon: '🔒',
                      title: 'Locked',
                      coins: '???',
                      date: 'Order 1 more time',
                      isUnlocked: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── 3. COIN HISTORY ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Recent Activity', style: _s(size: 17, weight: FontWeight.w700)),
              ),
              const SizedBox(height: 16),
              
              // Clean List Design without outer heavy borders
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildHistoryTile(icon: Icons.add_circle_rounded, title: 'Order Delivered', orderId: 'Order #8892', coins: '+50', isCredit: true),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(height: 1, color: Color(0xFFE5E7EB))),
                    _buildHistoryTile(icon: Icons.add_circle_rounded, title: 'Order Delivered', orderId: 'Order #8841', coins: '+20', isCredit: true),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(height: 1, color: Color(0xFFE5E7EB))),
                    _buildHistoryTile(icon: Icons.remove_circle_rounded, title: 'Coins Redeemed', orderId: 'Used at Checkout', coins: '-100', isCredit: false),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Divider(height: 1, color: Color(0xFFE5E7EB))),
                    _buildHistoryTile(icon: Icons.add_circle_rounded, title: 'Order Delivered', orderId: 'Order #8750', coins: '+30', isCredit: true),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Widget: Reward Card (Scratch Card Style) ──
  Widget _buildRewardCard({required String icon, required String title, required String coins, required String date, required bool isUnlocked}) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked ? themeColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isUnlocked ? themeColor.withOpacity(0.3) : const Color(0xFFE5E7EB), width: 1.5),
        boxShadow: isUnlocked ? [] : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 56, width: 56,
            decoration: BoxDecoration(
              color: isUnlocked ? Colors.white : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
              boxShadow: isUnlocked ? [BoxShadow(color: themeColor.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))] : [],
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(height: 16),
          Text(title, style: _s(size: 12, color: isUnlocked ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF), weight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            isUnlocked ? '$coins Coins' : 'Mystery',
            style: _s(size: 16, color: isUnlocked ? themeColor : const Color(0xFF6B7280), weight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUnlocked ? themeColor.withOpacity(0.1) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(date, style: _s(size: 10, weight: FontWeight.w600, color: isUnlocked ? themeColor : const Color(0xFF9CA3AF)), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // ── Widget: History ListTile ──
  Widget _buildHistoryTile({required IconData icon, required String title, required String orderId, required String coins, required bool isCredit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: isCredit ? themeColor : const Color(0xFFEF4444),
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _s(size: 15, weight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(orderId, style: _s(size: 12, color: const Color(0xFF6B7280))),
              ],
            ),
          ),
          Text(
            coins,
            style: _s(size: 16, weight: FontWeight.w800, color: isCredit ? themeColor : const Color(0xFF111827)),
          ),
        ],
      ),
    );
  }
}