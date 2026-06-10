import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HiddenRestaurantsScreen extends StatefulWidget {
  final Color themeColor;

  const HiddenRestaurantsScreen({super.key, required this.themeColor});

  @override
  State<HiddenRestaurantsScreen> createState() => _HiddenRestaurantsScreenState();
}

class _HiddenRestaurantsScreenState extends State<HiddenRestaurantsScreen> {
  // ── Dummy Hidden Data ──
  final List<Map<String, dynamic>> _hiddenRestaurants = [
    {
      'id': '1',
      'name': 'Greasy Spoon Diner',
      'icon': '🥡',
      'tags': 'Chinese • Street Food',
      'hiddenOn': '12 May, 2026',
    },
    {
      'id': '2',
      'name': 'The Stale Burger',
      'icon': '🍔',
      'tags': 'Fast Food • American',
      'hiddenOn': '28 April, 2026',
    },
    {
      'id': '3',
      'name': 'Soggy Fries Hub',
      'icon': '🍟',
      'tags': 'Snacks • Beverages',
      'hiddenOn': '15 March, 2026',
    },
  ];

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? height}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, height: height);
  }

  // ── Unhide Logic ──
  void _unhideRestaurant(int index) {
    final unhiddenItem = _hiddenRestaurants[index];
    setState(() {
      _hiddenRestaurants.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${unhiddenItem['name']} is now visible in your feed.', style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: const Color(0xFF374151),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: widget.themeColor,
          onPressed: () {
            setState(() {
              _hiddenRestaurants.insert(index, unhiddenItem);
            });
          },
        ),
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
        backgroundColor: const Color(0xFFFAFAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Hidden Restaurants', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
        ),
        body: _hiddenRestaurants.isEmpty
            ? _buildEmptyState()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'These restaurants will not appear in your searches or recommendations.',
                      style: _s(size: 13, color: const Color(0xFF6B7280), height: 1.4),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _hiddenRestaurants.length,
                      itemBuilder: (context, index) {
                        return _buildHiddenCard(_hiddenRestaurants[index], index);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ── HIDDEN RESTAURANT CARD ──
  Widget _buildHiddenCard(Map<String, dynamic> restaurant, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Greyscale / Muted Icon Box
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6), // Slightly darker grey for hidden feel
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Opacity(
                opacity: 0.5, // Faded emoji
                child: Text(restaurant['icon'], style: const TextStyle(fontSize: 28)),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Restaurant Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant['name'],
                  style: _s(size: 15, weight: FontWeight.w600, color: const Color(0xFF374151)), // Muted text color
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant['tags'],
                  style: _s(size: 12, color: const Color(0xFF9CA3AF)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.visibility_off_rounded, size: 12, color: Color(0xFFEF4444)),
                    const SizedBox(width: 4),
                    Text('Hidden on ${restaurant['hiddenOn']}', style: _s(size: 11, color: const Color(0xFFEF4444))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          
          // Unhide Button
          OutlinedButton(
            onPressed: () => _unhideRestaurant(index),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: widget.themeColor, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Unhide', style: _s(size: 12, weight: FontWeight.w600, color: widget.themeColor)),
          ),
        ],
      ),
    );
  }

  // ── EMPTY STATE WIDGET ──
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.visibility_outlined, size: 64, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 24),
          Text('No Hidden Restaurants', style: _s(size: 18, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Restaurants you hide will appear here.\nYou can unhide them anytime.',
            style: _s(size: 14, color: const Color(0xFF6B7280), height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}