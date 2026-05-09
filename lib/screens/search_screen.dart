import 'package:flutter/material.dart';
import 'app_models.dart';
import 'items_screen.dart';

// YAHAN BHI JELLY EFFECT OFF
class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class SearchCategoryItem {
  final String label;
  final String imagePath;
  SearchCategoryItem(this.label, this.imagePath);
}

class SearchSection {
  final String title;
  final List<SearchCategoryItem> items;
  SearchSection(this.title, this.items);
}

class SearchScreen extends StatefulWidget {
  final int initialTab; 
  const SearchScreen({super.key, required this.initialTab});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool get isDark => widget.initialTab == 0;
  Color get _bgColor => isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  Color get _searchBgColor => isDark ? const Color(0xFF252525) : Colors.white;
  Color get _textPrimary => isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _textSecondary => isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);
  Color get _borderColor => isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.15);

  final List<Color> _pastelColors = [
    const Color(0xFFFFE082), const Color(0xFFFFCDD2), const Color(0xFFF8BBD0),
    const Color(0xFFE1BEE7), const Color(0xFFC5CAE9), const Color(0xFFB2EBF2),
    const Color(0xFFC8E6C9), const Color(0xFFDCEDC8), const Color(0xFFFFF9C4),
  ];

  List<Map<String, dynamic>> get _pastSearches {
    if (widget.initialTab == 1) { 
      return [
        {'label': 'Biryani', 'icon': Icons.rice_bowl, 'color': const Color(0xFFFFCDD2)},
        {'label': 'Pizza', 'icon': Icons.local_pizza, 'color': const Color(0xFFFFF9C4)},
        {'label': 'Burger', 'icon': Icons.fastfood, 'color': const Color(0xFFDCEDC8)},
        {'label': 'Cold Drink', 'icon': Icons.local_drink, 'color': const Color(0xFFB2EBF2)},
        {'label': 'Ice Cream', 'icon': Icons.icecream, 'color': const Color(0xFFE1BEE7)},
        {'label': 'Momos', 'icon': Icons.set_meal, 'color': const Color(0xFFFFE082)},
        {'label': 'Noodles', 'icon': Icons.ramen_dining, 'color': const Color(0xFFC8E6C9)},
        {'label': 'Pasta', 'icon': Icons.restaurant, 'color': const Color(0xFFF8BBD0)},
        {'label': 'Rolls', 'icon': Icons.breakfast_dining, 'color': const Color(0xFFC5CAE9)},
        {'label': 'Cake', 'icon': Icons.cake, 'color': const Color(0xFFFFCDD2)},
      ];
    } else if (widget.initialTab == 2) { 
      return [
        {'label': 'Paracetamol', 'icon': Icons.medication, 'color': const Color(0xFFBBDEFB)},
        {'label': 'Vicks', 'icon': Icons.healing, 'color': const Color(0xFFC8E6C9)},
        {'label': 'Cough Syrup', 'icon': Icons.local_drink, 'color': const Color(0xFFFFCCBC)},
        {'label': 'Band-Aid', 'icon': Icons.medical_services, 'color': const Color(0xFFD1C4E9)},
        {'label': 'Vitamin C', 'icon': Icons.health_and_safety, 'color': const Color(0xFFF8BBD0)},
        {'label': 'Thermometer', 'icon': Icons.thermostat, 'color': const Color(0xFFFFF9C4)},
        {'label': 'Digene', 'icon': Icons.science, 'color': const Color(0xFFFFE082)},
        {'label': 'ORS', 'icon': Icons.water_drop, 'color': const Color(0xFFE1BEE7)},
        {'label': 'Cotton', 'icon': Icons.cloud, 'color': const Color(0xFFB2EBF2)},
        {'label': 'Dettol', 'icon': Icons.clean_hands, 'color': const Color(0xFFDCEDC8)},
      ];
    }
    return [
      {'label': 'Milk', 'icon': Icons.water_drop, 'color': const Color(0xFFFFCDD2)},
      {'label': 'Egg', 'icon': Icons.egg, 'color': const Color(0xFFC8E6C9)},
      {'label': 'Cookie', 'icon': Icons.cookie, 'color': const Color(0xFFE1BEE7)},
      {'label': 'Dry Fruits', 'icon': Icons.spa, 'color': const Color(0xFFB2EBF2)},
      {'label': 'Bread', 'icon': Icons.breakfast_dining, 'color': const Color(0xFFFFF9C4)},
      {'label': 'Soap', 'icon': Icons.clean_hands, 'color': const Color(0xFFDCEDC8)},
      {'label': 'Rice', 'icon': Icons.rice_bowl, 'color': const Color(0xFFFFE082)},
      {'label': 'Sugar', 'icon': Icons.scatter_plot, 'color': const Color(0xFFF8BBD0)},
      {'label': 'Tea', 'icon': Icons.emoji_food_beverage, 'color': const Color(0xFFC5CAE9)},
      {'label': 'Chips', 'icon': Icons.fastfood, 'color': const Color(0xFFFFCCBC)},
    ];
  }

  // ── YE DEKHO AAPKA POORA PURANA DATA JO SCREENSHOT MEIN THA ──
  List<SearchSection> get _searchCategories {
    if (widget.initialTab == 1) { 
      return [
        SearchSection('Top Cuisines', [SearchCategoryItem('North Indian', 'assets/images/broccoli.png'), SearchCategoryItem('South Indian', 'assets/images/broccoli.png'), SearchCategoryItem('Chinese', 'assets/images/broccoli.png'), SearchCategoryItem('Italian', 'assets/images/broccoli.png')]),
        SearchSection('Biryani & Pulao', [SearchCategoryItem('Chicken', 'assets/images/broccoli.png'), SearchCategoryItem('Mutton', 'assets/images/broccoli.png'), SearchCategoryItem('Veg Pulao', 'assets/images/broccoli.png'), SearchCategoryItem('Hyderabadi', 'assets/images/broccoli.png')]),
        SearchSection('Pizzas & Burgers', [SearchCategoryItem('Cheese Pizza', 'assets/images/broccoli.png'), SearchCategoryItem('Veggie', 'assets/images/broccoli.png'), SearchCategoryItem('Chicken Burger', 'assets/images/broccoli.png'), SearchCategoryItem('Paneer Burger', 'assets/images/broccoli.png')]),
        SearchSection('Noodles & Momos', [SearchCategoryItem('Hakka', 'assets/images/broccoli.png'), SearchCategoryItem('Chowmein', 'assets/images/broccoli.png'), SearchCategoryItem('Steam Momo', 'assets/images/broccoli.png'), SearchCategoryItem('Fried Momo', 'assets/images/broccoli.png')]),
      ];
    } else if (widget.initialTab == 2) { 
      return [
        SearchSection('Daily Medicines', [SearchCategoryItem('Fever & Pain', 'assets/images/broccoli.png'), SearchCategoryItem('Cold & Cough', 'assets/images/broccoli.png'), SearchCategoryItem('Digestion', 'assets/images/broccoli.png'), SearchCategoryItem('Allergy', 'assets/images/broccoli.png')]),
        SearchSection('Vitamins & Supplements', [SearchCategoryItem('Vitamin C', 'assets/images/broccoli.png'), SearchCategoryItem('Omega 3', 'assets/images/broccoli.png'), SearchCategoryItem('Multivitamins', 'assets/images/broccoli.png'), SearchCategoryItem('Calcium', 'assets/images/broccoli.png')]),
        SearchSection('First Aid Kits', [SearchCategoryItem('Bandages', 'assets/images/broccoli.png'), SearchCategoryItem('Antiseptics', 'assets/images/broccoli.png'), SearchCategoryItem('Cotton', 'assets/images/broccoli.png'), SearchCategoryItem('Sprays', 'assets/images/broccoli.png')]),
        SearchSection('Personal Care', [SearchCategoryItem('Skin Care', 'assets/images/broccoli.png'), SearchCategoryItem('Hair Care', 'assets/images/broccoli.png'), SearchCategoryItem('Baby Care', 'assets/images/broccoli.png'), SearchCategoryItem('Women Care', 'assets/images/broccoli.png')]),
      ];
    }
    return [
      SearchSection('Vegetables', [SearchCategoryItem('Potato', 'assets/images/broccoli.png'), SearchCategoryItem('Carrot', 'assets/images/broccoli.png'), SearchCategoryItem('Onion', 'assets/images/broccoli.png'), SearchCategoryItem('Tomato', 'assets/images/broccoli.png')]),
      SearchSection('Fruits', [SearchCategoryItem('Apple', 'assets/images/broccoli.png'), SearchCategoryItem('Banana', 'assets/images/broccoli.png'), SearchCategoryItem('Guava', 'assets/images/broccoli.png'), SearchCategoryItem('Papaya', 'assets/images/broccoli.png')]),
      SearchSection('Grocery', [SearchCategoryItem('Basmati Rice', 'assets/images/broccoli.png'), SearchCategoryItem('Arhar Dal', 'assets/images/broccoli.png'), SearchCategoryItem('Mustard Oil', 'assets/images/broccoli.png'), SearchCategoryItem('Atta', 'assets/images/broccoli.png')]),
      SearchSection('Snacks & Drinks', [SearchCategoryItem('Chips', 'assets/images/broccoli.png'), SearchCategoryItem('Namkeen', 'assets/images/broccoli.png'), SearchCategoryItem('Cold Drinks', 'assets/images/broccoli.png'), SearchCategoryItem('Juices', 'assets/images/broccoli.png')]),
      SearchSection('For home', [SearchCategoryItem('Floor Cleaner', 'assets/images/broccoli.png'), SearchCategoryItem('Detergent', 'assets/images/broccoli.png'), SearchCategoryItem('Towels', 'assets/images/broccoli.png'), SearchCategoryItem('Bulbs', 'assets/images/broccoli.png')]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: NoJellyScrollBehavior(), // JELLY EFFECT OFF IN SEARCH
          child: Column(
            children: [
              _buildSearchHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(), // JELLY OFF
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildPastSearches(),
                      const SizedBox(height: 30),
                      ..._buildSearchCategoryRows(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _searchBgColor, shape: BoxShape.circle, border: Border.all(color: _borderColor)),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: _searchBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: TextStyle(color: _textPrimary, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'What do you want to order..',
                        hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.mic_none_rounded, color: _textSecondary, size: 22),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastSearches() {
    final searches = _pastSearches;
    final half = (searches.length / 2).ceil();
    final row1 = searches.sublist(0, half);
    final row2 = searches.sublist(half);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('YOUR PAST SEARCHES', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(), // Horizontal Jelly Off
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: row1.map((search) => _buildSearchChip(search)).toList(),
              ),
              const SizedBox(height: 10), 
              Row(
                children: row2.map((search) => _buildSearchChip(search)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(Map<String, dynamic> search) {
    return Container(
      margin: const EdgeInsets.only(right: 10), 
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: search['color'], borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(search['icon'], color: Colors.black87, size: 16),
          const SizedBox(width: 6),
          Text(search['label'], style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  List<Widget> _buildSearchCategoryRows() {
    List<Widget> rows = [];
    int globalIndex = 0; 

    for (var section in _searchCategories) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(section.title, style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsScreen(categoryTitle: section.title, tabIndex: widget.initialTab)));
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFFEEEEEE), shape: BoxShape.circle),
                  child: const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        )
      );
      rows.add(const SizedBox(height: 16));
      
      rows.add(
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal, 
            physics: const ClampingScrollPhysics(), // Horizontal Jelly Off
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: section.items.length, separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (ctx, i) {
              final c = section.items[i];
              final boxColor = _pastelColors[(globalIndex + i * 2) % _pastelColors.length]; 
              
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsScreen(categoryTitle: section.title, tabIndex: widget.initialTab)));
                },
                child: Container(
                  width: 115, decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    children: [
                      Positioned(top: 10, left: 12, child: Text(c.label, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w800))),
                      Positioned(bottom: -5, right: -5, child: Image.asset(c.imagePath, height: 80, width: 80, fit: BoxFit.contain, errorBuilder: (ctx,e,s) => const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.shopping_bag, size: 40, color: Colors.black26)))),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      );
      rows.add(const SizedBox(height: 32));
      globalIndex += 3; 
    }
    return rows;
  }
}