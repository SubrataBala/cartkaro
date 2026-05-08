import 'package:flutter/material.dart';
import 'home_screen.dart'; // Models import karne ke liye

class SearchScreen extends StatefulWidget {
  final int initialTab;
  const SearchScreen({super.key, required this.initialTab});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late bool isDark;
  
  @override
  void initState() {
    super.initState();
    isDark = widget.initialTab == 0; 
  }

  Color get _bgColor => isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  Color get _searchBgColor => isDark ? const Color(0xFF252525) : Colors.white;
  Color get _textPrimary => isDark ? Colors.white : const Color(0xFF1A1A1A); 
  Color get _textSecondary => isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);
  Color get _borderColor => isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.15);

  // ─── PASTEL COLORS LIST ───
  final List<Color> _pastelColors = const [
    Color(0xFFFFCDD2), // Light Red/Pink
    Color(0xFFF8BBD0), // Light Pink
    Color(0xFFE1BEE7), // Light Purple
    Color(0xFFD1C4E9), // Light Deep Purple
    Color(0xFFC5CAE9), // Light Indigo
    Color(0xFFBBDEFB), // Light Blue
    Color(0xFFB2EBF2), // Light Cyan
    Color(0xFFB2DFDB), // Light Teal
    Color(0xFFC8E6C9), // Light Green
    Color(0xFFDCEDC8), // Light Lime
    Color(0xFFF0F4C3), // Light Yellow-Green
    Color(0xFFFFF9C4), // Light Yellow
    Color(0xFFFFECB3), // Light Amber
    Color(0xFFFFE0B2), // Light Orange
    Color(0xFFFFCCBC), // Light Deep Orange
  ];

  // ─── DYNAMIC PAST SEARCHES ───
  List<CategoryItem> get _pastSearches {
    // Agar aap is list ko empty [] return karoge (jaise naye user ke liye), 
    // toh Past Searches section apne aap hide ho jayega!
    
    if (widget.initialTab == 1) { 
      return const [
        CategoryItem('Biryani', 'assets/images/broccoli.png'),
        CategoryItem('Pizza', 'assets/images/broccoli.png'),
        CategoryItem('Burger', 'assets/images/broccoli.png'),
        CategoryItem('Coke', 'assets/images/broccoli.png'),
        CategoryItem('Fries', 'assets/images/broccoli.png'),
        CategoryItem('Momos', 'assets/images/broccoli.png'),
        CategoryItem('Rolls', 'assets/images/broccoli.png'),
        CategoryItem('Pasta', 'assets/images/broccoli.png'),
        CategoryItem('Noodles', 'assets/images/broccoli.png'),
        CategoryItem('Ice Cream', 'assets/images/broccoli.png'),
      ];
    } else if (widget.initialTab == 2) { 
      return const [
        CategoryItem('Paracetamol', 'assets/images/broccoli.png'),
        CategoryItem('Vicks', 'assets/images/broccoli.png'),
        CategoryItem('Band-Aid', 'assets/images/broccoli.png'),
        CategoryItem('Dettol', 'assets/images/broccoli.png'),
        CategoryItem('Inhaler', 'assets/images/broccoli.png'),
        CategoryItem('Cough Syrup', 'assets/images/broccoli.png'),
        CategoryItem('Cotton', 'assets/images/broccoli.png'),
        CategoryItem('Thermometer', 'assets/images/broccoli.png'),
        CategoryItem('Mask', 'assets/images/broccoli.png'),
        CategoryItem('Sanitizer', 'assets/images/broccoli.png'),
      ];
    }
    return const [
      CategoryItem('Milk', 'assets/images/broccoli.png'),
      CategoryItem('Egg', 'assets/images/broccoli.png'),
      CategoryItem('Cookie', 'assets/images/broccoli.png'),
      CategoryItem('Dry Fruits', 'assets/images/broccoli.png'),
      CategoryItem('Bags', 'assets/images/broccoli.png'),
      CategoryItem('Cold Drink', 'assets/images/broccoli.png'),
      CategoryItem('Ice Cream', 'assets/images/broccoli.png'),
      CategoryItem('Soap', 'assets/images/broccoli.png'),
      CategoryItem('Iron', 'assets/images/broccoli.png'),
      CategoryItem('Towel', 'assets/images/broccoli.png'),
    ];
  }

  // ─── DYNAMIC SEARCH CATEGORIES ───
  List<GridSectionData> get _searchCategories {
    if (widget.initialTab == 1) { 
      return [
        GridSectionData('Biryani', [
          CategoryItem('Chicken', 'assets/images/broccoli.png'), CategoryItem('Mutton', 'assets/images/broccoli.png'), CategoryItem('Veg', 'assets/images/broccoli.png'), 
          CategoryItem('Paneer', 'assets/images/broccoli.png'), CategoryItem('Egg', 'assets/images/broccoli.png'), CategoryItem('Handi', 'assets/images/broccoli.png'),
        ]),
        GridSectionData('Fast Food', [
          CategoryItem('Burgers', 'assets/images/broccoli.png'), CategoryItem('Pizza', 'assets/images/broccoli.png'), CategoryItem('Fries', 'assets/images/broccoli.png'), 
          CategoryItem('Hot Dog', 'assets/images/broccoli.png'), CategoryItem('Tacos', 'assets/images/broccoli.png'), CategoryItem('Wraps', 'assets/images/broccoli.png'),
        ]),
      ];
    } else if (widget.initialTab == 2) { 
      return [
        GridSectionData('Medicines', [
          CategoryItem('Fever', 'assets/images/broccoli.png'), CategoryItem('Cold', 'assets/images/broccoli.png'), CategoryItem('Cough', 'assets/images/broccoli.png'), 
          CategoryItem('Pain', 'assets/images/broccoli.png'), CategoryItem('Allergy', 'assets/images/broccoli.png'), CategoryItem('Gastric', 'assets/images/broccoli.png'),
        ]),
        GridSectionData('First Aid', [
          CategoryItem('Bandage', 'assets/images/broccoli.png'), CategoryItem('Dettol', 'assets/images/broccoli.png'), CategoryItem('Cotton', 'assets/images/broccoli.png'), 
          CategoryItem('Spray', 'assets/images/broccoli.png'), CategoryItem('Ointment', 'assets/images/broccoli.png'), CategoryItem('Tape', 'assets/images/broccoli.png'),
        ]),
      ];
    }
    return [
      GridSectionData('Vegetables', [
        CategoryItem('Potato', 'assets/images/broccoli.png'), CategoryItem('Carrot', 'assets/images/broccoli.png'), CategoryItem('Onion', 'assets/images/broccoli.png'), 
        CategoryItem('Tomato', 'assets/images/broccoli.png'), CategoryItem('Cabbage', 'assets/images/broccoli.png'), CategoryItem('Capsicum', 'assets/images/broccoli.png'),
      ]),
      GridSectionData('Grocery', [
        CategoryItem('Rice', 'assets/images/broccoli.png'), CategoryItem('Buckwheat', 'assets/images/broccoli.png'), CategoryItem('Cous Cous', 'assets/images/broccoli.png'), 
        CategoryItem('Atta', 'assets/images/broccoli.png'), CategoryItem('Masala', 'assets/images/broccoli.png'), CategoryItem('Oil', 'assets/images/broccoli.png'),
      ]),
      GridSectionData('For home', [
        CategoryItem('Rug', 'assets/images/broccoli.png'), CategoryItem('Screwdriver', 'assets/images/broccoli.png'), CategoryItem('Towels', 'assets/images/broccoli.png'), 
        CategoryItem('Bulb', 'assets/images/broccoli.png'), CategoryItem('Mop', 'assets/images/broccoli.png'), CategoryItem('Bucket', 'assets/images/broccoli.png'),
      ]),
      GridSectionData('Fruits', [
        CategoryItem('Banana', 'assets/images/broccoli.png'), CategoryItem('Apple', 'assets/images/broccoli.png'), CategoryItem('Dragon Fruit', 'assets/images/broccoli.png'), 
        CategoryItem('Mango', 'assets/images/broccoli.png'), CategoryItem('Grapes', 'assets/images/broccoli.png'), CategoryItem('Orange', 'assets/images/broccoli.png'),
      ]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final pastSearchesList = _pastSearches; // List ko fetch kiya

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBarTop(),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    
                    // ── DYNAMIC PAST SEARCHES CONDITION ──
                    if (pastSearchesList.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'YOUR PAST SEARCHES', 
                          style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2)
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildPastSearchesWrap(pastSearchesList), 
                      const SizedBox(height: 32),
                    ],
                    
                    ..._buildSearchCategoryRows(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBarTop() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: _searchBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor, width: 1.2),
          boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: _textSecondary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: TextField(
                autofocus: true,
                style: TextStyle(color: _textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'What do you want to order..',
                  hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            Container(width: 1, height: 24, color: isDark ? Colors.grey[800] : Colors.grey[300]),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.mic_none_rounded, color: _textSecondary, size: 22),
              onPressed: (){},
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPastSearchesWrap(List<CategoryItem> searches) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: searches.take(5).toList().asMap().entries.map((entry) => _buildPastSearchPill(entry.value, entry.key)).toList(),
          ),
          // Agar 5 se zyada items hain, tabhi dusri line dikhegi
          if (searches.length > 5) ...[
            const SizedBox(height: 12),
            Row(
              children: searches.skip(5).toList().asMap().entries.map((entry) => _buildPastSearchPill(entry.value, entry.key + 5)).toList(),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildPastSearchPill(CategoryItem item, int index) {
    final color = _pastelColors[index % _pastelColors.length]; 
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color, 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(item.imagePath, height: 22, width: 22, fit: BoxFit.contain, errorBuilder: (c,e,s) => const Icon(Icons.image, size: 22, color: Colors.black54)),
          const SizedBox(width: 8),
          Text(item.label, style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)), 
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
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFFEEEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.black, size: 20),
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
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: section.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (ctx, i) {
              final c = section.items[i];
              final boxColor = _pastelColors[(globalIndex + i * 2) % _pastelColors.length]; 
              
              return Container(
                width: 115, 
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 12,
                      child: Text(
                        c.label, 
                        style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w800) 
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                        child: Image.asset(c.imagePath, height: 75, width: 85, fit: BoxFit.contain, alignment: Alignment.bottomRight, errorBuilder: (ctx,e,s) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.shopping_bag, size: 40, color: Colors.black26),
                        )),
                      ),
                    ),
                  ],
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