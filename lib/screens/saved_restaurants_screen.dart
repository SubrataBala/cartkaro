import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SavedRestaurantsScreen extends StatefulWidget {
  final Color themeColor;

  const SavedRestaurantsScreen({super.key, required this.themeColor});

  @override
  State<SavedRestaurantsScreen> createState() => _SavedRestaurantsScreenState();
}

class _SavedRestaurantsScreenState extends State<SavedRestaurantsScreen> {
  // ── Dummy Watchlist Data ──
  final List<Map<String, dynamic>> _savedRestaurants = [
    {
      'id': '1',
      'name': 'Spice Symphony',
      'icon': '🍲',
      'tags': 'North Indian • Mughlai',
      'rating': '4.6',
      'reviews': '1.2k',
      'time': '35 mins',
      'distance': '2.5 km',
    },
    {
      'id': '2',
      'name': 'Pizza Paradise',
      'icon': '🍕',
      'tags': 'Italian • Fast Food',
      'rating': '4.3',
      'reviews': '850',
      'time': '25 mins',
      'distance': '1.2 km',
    },
    {
      'id': '3',
      'name': 'Sushi Central',
      'icon': '🍣',
      'tags': 'Japanese • Asian',
      'rating': '4.8',
      'reviews': '500',
      'time': '40 mins',
      'distance': '4.0 km',
    },
    {
      'id': '4',
      'name': 'Burger Barn',
      'icon': '🍔',
      'tags': 'American • Fast Food',
      'rating': '4.1',
      'reviews': '2.1k',
      'time': '20 mins',
      'distance': '1.0 km',
    },
  ];

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? height}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, height: height);
  }

  // ── Remove from Watchlist Logic ──
  void _removeRestaurant(int index) {
    final removedItem = _savedRestaurants[index];
    setState(() {
      _savedRestaurants.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedItem['name']} removed from saved list.', style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: const Color(0xFF374151),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: widget.themeColor,
          onPressed: () {
            setState(() {
              _savedRestaurants.insert(index, removedItem);
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
          title: Text('Saved Restaurants', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text('${_savedRestaurants.length} saved', style: _s(size: 13, weight: FontWeight.w600, color: widget.themeColor)),
              ),
            )
          ],
        ),
        body: _savedRestaurants.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: _savedRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = _savedRestaurants[index];
                  return _buildRestaurantCard(restaurant, index);
                },
              ),
      ),
    );
  }

  // ── RESTAURANT CARD WIDGET ──
  Widget _buildRestaurantCard(Map<String, dynamic> restaurant, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            // Yahan se restaurant details page pe jayega
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image/Icon Box
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(restaurant['icon'], style: const TextStyle(fontSize: 40)), // Replace with real image later
                  ),
                ),
                const SizedBox(width: 16),
                
                // Restaurant Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              restaurant['name'],
                              style: _s(size: 16, weight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Favorite (Save/Unsave) Button
                          GestureDetector(
                            onTap: () => _removeRestaurant(index),
                            child: Icon(Icons.favorite_rounded, color: widget.themeColor, size: 22),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant['tags'],
                        style: _s(size: 12, color: const Color(0xFF6B7280)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      
                      // Ratings & Time Row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 14, color: Color(0xFF10B981)),
                                const SizedBox(width: 4),
                                Text(restaurant['rating'], style: _s(size: 11, weight: FontWeight.w700, color: const Color(0xFF10B981))),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 4),
                          Text(restaurant['time'], style: _s(size: 11, weight: FontWeight.w500, color: const Color(0xFF6B7280))),
                          const Spacer(),
                          Text(restaurant['distance'], style: _s(size: 11, weight: FontWeight.w600, color: const Color(0xFF4B5563))),
                        ],
                      )
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

  // ── EMPTY STATE WIDGET ──
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: widget.themeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_border_rounded, size: 64, color: widget.themeColor),
          ),
          const SizedBox(height: 24),
          Text('No Saved Restaurants', style: _s(size: 18, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'You haven\'t added any restaurant\nto your watchlist yet.',
            style: _s(size: 14, color: const Color(0xFF6B7280), height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.themeColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Text('Explore Restaurants', style: _s(size: 14, weight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}