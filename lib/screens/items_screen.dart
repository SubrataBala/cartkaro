import 'package:flutter/material.dart';
import 'app_models.dart'; // Colors laane ke liye

// ── GLOBAL STATE & DATA ──
ValueNotifier<Map<String, int>> cartCountNotifier = ValueNotifier({});
ValueNotifier<Set<String>> watchlistNotifier = ValueNotifier({});

// ── FULL CATEGORY DATA FOR ALL TABS ──
final Map<int, Map<String, List<Map<String, dynamic>>>> globalAllCategoryData = {
  0: { // ── GROCERY (Index 0) ──
    'Vegetables': [
      {'id': 'g_v1', 'name': 'Potato', 'weight': '1kg', 'price': '30', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_v2', 'name': 'Carrot', 'weight': '500g', 'price': '40', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_v3', 'name': 'Onion', 'weight': '1kg', 'price': '35', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_v4', 'name': 'Cabbage', 'weight': '1 pc', 'price': '45', 'image': 'assets/images/broccoli.png'},
    ],
    'Fruits': [
      {'id': 'g_f1', 'name': 'Banana', 'weight': '1 Dozen', 'price': '60', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_f2', 'name': 'Apple', 'weight': '1kg', 'price': '160', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_f3', 'name': 'Guava', 'weight': '1kg', 'price': '50', 'image': 'assets/images/broccoli.png'},
    ],
    'Grocery': [
      {'id': 'g_g1', 'name': 'Basmati Rice', 'weight': '1kg', 'price': '120', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_g2', 'name': 'Arhar Dal', 'weight': '500g', 'price': '85', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_g3', 'name': 'Mustard Oil', 'weight': '1L', 'price': '155', 'image': 'assets/images/broccoli.png'},
    ],
    'For home': [
      {'id': 'g_h1', 'name': 'Floor Cleaner', 'weight': '1L', 'price': '199', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_h2', 'name': 'Towels', 'weight': 'Pack of 2', 'price': '250', 'image': 'assets/images/broccoli.png'},
    ],
  },
  1: { // ── RESTAURANT (Index 1) ──
    'Biryani & Pulao': [
      {'id': 'r_b1', 'name': 'Chicken Biryani', 'weight': 'Full', 'price': '280', 'image': 'assets/images/broccoli.png'},
      {'id': 'r_b2', 'name': 'Mutton Biryani', 'weight': 'Full', 'price': '350', 'image': 'assets/images/broccoli.png'},
      {'id': 'r_b3', 'name': 'Veg Pulao', 'weight': 'Full', 'price': '180', 'image': 'assets/images/broccoli.png'},
    ],
    'Pizzas & Burgers': [
      {'id': 'r_p1', 'name': 'Cheese Burger', 'weight': '1 pc', 'price': '99', 'image': 'assets/images/broccoli.png'},
      {'id': 'r_p2', 'name': 'Margherita Pizza', 'weight': 'Medium', 'price': '249', 'image': 'assets/images/broccoli.png'},
    ],
    'Noodles & Momos': [
      {'id': 'r_n1', 'name': 'Hakka Noodles', 'weight': 'Full', 'price': '120', 'image': 'assets/images/broccoli.png'},
      {'id': 'r_n2', 'name': 'Chicken Steam Momo', 'weight': '8 pcs', 'price': '110', 'image': 'assets/images/broccoli.png'},
    ],
  },
  2: { // ── MEDICAL (Index 2) ──
    'Daily Medicines': [
      {'id': 'm_m1', 'name': 'Paracetamol 500mg', 'weight': '10 Tabs', 'price': '20', 'image': 'assets/images/broccoli.png'},
      {'id': 'm_m2', 'name': 'Cough Syrup', 'weight': '100ml', 'price': '85', 'image': 'assets/images/broccoli.png'},
      {'id': 'm_m3', 'name': 'Vicks Vaporub', 'weight': '50g', 'price': '95', 'image': 'assets/images/broccoli.png'},
    ],
    'First Aid Kits': [
      {'id': 'm_fa1', 'name': 'Band-Aid', 'weight': '20 Pcs', 'price': '40', 'image': 'assets/images/broccoli.png'},
      {'id': 'm_fa2', 'name': 'Dettol Antiseptic', 'weight': '250ml', 'price': '120', 'image': 'assets/images/broccoli.png'},
      {'id': 'm_fa3', 'name': 'Cotton Roll', 'weight': '100g', 'price': '35', 'image': 'assets/images/broccoli.png'},
    ],
    'Vitamins & Supplements': [
      {'id': 'm_v1', 'name': 'Vitamin C Tablets', 'weight': '20 Tabs', 'price': '55', 'image': 'assets/images/broccoli.png'},
      {'id': 'm_v2', 'name': 'Fish Oil Omega 3', 'weight': '60 Caps', 'price': '499', 'image': 'assets/images/broccoli.png'},
    ]
  }
};

class ItemsScreen extends StatefulWidget {
  final String categoryTitle;
  final int tabIndex;

  const ItemsScreen({super.key, required this.categoryTitle, required this.tabIndex});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  bool get _isDark => widget.tabIndex == 0;
  Color get _bgColor => _isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  Color get _cardColor => _isDark ? const Color(0xFF1E1E1E) : Colors.white; 
  Color get _textColor => _isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _iconColor => _isDark ? Colors.white : Colors.black;

  Color get _themeColor {
    if (widget.tabIndex == 1) return kRestaurantRed; 
    if (widget.tabIndex == 2) return kMedicalBlue; 
    return kGroceryGreen; 
  }

  List<Map<String, dynamic>> get _filteredItems {
    final tabData = globalAllCategoryData[widget.tabIndex] ?? {};
    List<Map<String, dynamic>> categoryItems = tabData[widget.categoryTitle] ?? [];
    
    if (_searchQuery.isEmpty) return categoryItems;
    return categoryItems.where((item) => item['name'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: _iconColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.categoryTitle, style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 50, 
              decoration: BoxDecoration(
                color: _isDark ? Colors.white10 : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(color: _textColor),
                textAlignVertical: TextAlignVertical.center, 
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 14), 
                  hintText: "Search in ${widget.categoryTitle}...",
                  hintStyle: TextStyle(color: _textColor.withOpacity(0.4)),
                  prefixIcon: Icon(Icons.search_rounded, color: _themeColor),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          Expanded(
            child: _filteredItems.isEmpty 
              ? Center(child: Text("No items available", style: TextStyle(color: _textColor.withOpacity(0.5), fontSize: 16)))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filteredItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return _buildProductCard(item);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    final String id = item['id'];
    
    return ValueListenableBuilder(
      valueListenable: watchlistNotifier,
      builder: (context, Set<String> favorites, _) {
        final bool isFav = favorites.contains(id);
        
        return Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20),
            border: !_isDark ? Border.all(color: Colors.grey.shade200) : null,
            boxShadow: !_isDark ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))] : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(child: Image.asset(item['image'], height: 75)),
                    Positioned(
                      top: 10, right: 10,
                      child: GestureDetector(
                        onTap: () {
                          var newFavs = Set<String>.from(watchlistNotifier.value);
                          if (isFav) newFavs.remove(id); else newFavs.add(id);
                          watchlistNotifier.value = newFavs;
                        },
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border_rounded,
                          color: isFav ? Colors.red : _textColor.withOpacity(0.3),
                          size: 28, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: TextStyle(color: _textColor, fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(item['weight'], style: TextStyle(color: _textColor.withOpacity(0.5), fontSize: 11)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹${item['price']}', style: TextStyle(color: _textColor, fontWeight: FontWeight.w800, fontSize: 15)),
                        _AddToCartButton(itemId: id, themeColor: _themeColor),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final String itemId;
  final Color themeColor;
  const _AddToCartButton({required this.itemId, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cartCountNotifier,
      builder: (context, Map<String, int> counts, _) {
        final count = counts[itemId] ?? 0;
        if (count == 0) {
          return GestureDetector(
            onTap: () {
              var current = {...cartCountNotifier.value}; current[itemId] = 1; cartCountNotifier.value = current;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(8)),
              child: const Text('ADD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                GestureDetector(
                  onTap: () {
                    var current = {...cartCountNotifier.value};
                    current[itemId] = (current[itemId] ?? 0) - 1;
                    if (current[itemId]! <= 0) current.remove(itemId);
                    cartCountNotifier.value = current;
                  },
                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text('-', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                ),
                Text('$count', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    var current = {...cartCountNotifier.value}; current[itemId] = (current[itemId] ?? 0) + 1; cartCountNotifier.value = current;
                  },
                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text('+', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}