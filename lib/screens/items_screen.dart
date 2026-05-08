import 'package:flutter/material.dart';

// ── GLOBAL STATE & DATA (Home Screen bhi inko use karega) ──
ValueNotifier<Map<String, int>> cartCountNotifier = ValueNotifier({});
ValueNotifier<Set<String>> watchlistNotifier = ValueNotifier({});

// ── NAYA: UNIQUE IDs KE SATH DATA ──
// Dhyan rakhein: Har item ki 'id' ekdum alag hai taaki ek sath sab select na hon
final Map<int, Map<String, List<Map<String, dynamic>>>> globalAllCategoryData = {
  0: { // ── GROCERY TAB DATA (Index 0) ──
    'Vegetables': [
      {'id': 'g_v1', 'name': 'Potato', 'weight': '1kg', 'price': '30', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_v2', 'name': 'Carrot', 'weight': '500g', 'price': '40', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_v3', 'name': 'Onion', 'weight': '1kg', 'price': '35', 'image': 'assets/images/broccoli.png'},
    ],
    'Grocery': [
      {'id': 'g_g1', 'name': 'Basmati Rice', 'weight': '1kg', 'price': '120', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_g2', 'name': 'Buckwheat', 'weight': '500g', 'price': '90', 'image': 'assets/images/broccoli.png'},
    ],
    'For home': [
      {'id': 'g_h1', 'name': 'Rug', 'weight': '1 pc', 'price': '499', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_h2', 'name': 'Screwdriver', 'weight': '1 pc', 'price': '150', 'image': 'assets/images/broccoli.png'},
    ],
    'Fruits': [
      {'id': 'g_f1', 'name': 'Banana', 'weight': '1 Dozen', 'price': '60', 'image': 'assets/images/broccoli.png'},
      {'id': 'g_f2', 'name': 'Apple', 'weight': '1kg', 'price': '160', 'image': 'assets/images/broccoli.png'},
    ],
  },
  1: { // ── RESTAURANT TAB DATA (Index 1) ──
    'Biryani': [
      {'id': 'r_b1', 'name': 'Chicken Biryani', 'weight': 'Full', 'price': '280', 'image': 'assets/images/broccoli.png'},
      {'id': 'r_b2', 'name': 'Mutton Biryani', 'weight': 'Full', 'price': '350', 'image': 'assets/images/broccoli.png'},
    ],
    'Fast Food': [
      {'id': 'r_f1', 'name': 'Burger', 'weight': '1 pc', 'price': '80', 'image': 'assets/images/broccoli.png'},
      {'id': 'r_f2', 'name': 'Pizza', 'weight': 'Medium', 'price': '199', 'image': 'assets/images/broccoli.png'},
    ],
  },
  2: { // ── MEDICAL TAB DATA (Index 2) ──
    'Medicines': [
      {'id': 'm_m1', 'name': 'Paracetamol', 'weight': '10 strip', 'price': '20', 'image': 'assets/images/broccoli.png'},
      {'id': 'm_m2', 'name': 'Cough Syrup', 'weight': '100ml', 'price': '85', 'image': 'assets/images/broccoli.png'},
      {'id': 'm_m3', 'name': 'Vicks Vaporub', 'weight': '50g', 'price': '95', 'image': 'assets/images/broccoli.png'},
    ],
    'First Aid': [
      {'id': 'm_fa1', 'name': 'Band-Aid', 'weight': '5 Pcs', 'price': '10', 'image': 'assets/images/broccoli.png'},
      {'id': 'm_fa2', 'name': 'Dettol', 'weight': '250ml', 'price': '120', 'image': 'assets/images/broccoli.png'},
    ],
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
  Color get _bgColor => _isDark ? const Color(0xFF121212) : Colors.white;
  Color get _cardColor => _isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5); 
  Color get _textColor => _isDark ? Colors.white : Colors.black;
  Color get _iconColor => _isDark ? Colors.white : Colors.black;

  Color get _themeColor {
    if (widget.tabIndex == 1) return const Color(0xFFE53935); // Restaurant: Red
    if (widget.tabIndex == 2) return const Color(0xFF1565C0); // Medical: Blue
    return const Color(0xFF4CAF50); // Grocery: Green
  }

  // Filter Data Logic based on Search
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
      // Yahan koi Bottom Navigation (Footer) nahi hai
      body: Column(
        children: [
          // ── SEARCH BAR ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 50, // Fixed height for perfect alignment
              decoration: BoxDecoration(
                color: _isDark ? Colors.white10 : Colors.grey[100],
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
          
          // ── ITEMS GRID ──
          Expanded(
            child: _filteredItems.isEmpty 
              ? Center(child: Text("No items found", style: TextStyle(color: _textColor)))
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Center(child: Image.asset(item['image'], height: 75)),
                    // ── WATCHLIST HEART ICON (Bada size) ──
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
                          size: 28, // Fix: Icon bada kiya
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

// ── ADD TO CART BUTTON LOGIC (- 1 + FIX WALA) ──
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
          // ADD Button State
          return GestureDetector(
            onTap: () {
              var current = {...cartCountNotifier.value};
              current[itemId] = 1;
              cartCountNotifier.value = current;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(8)),
              child: const Text('ADD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          );
        } else {
          // - 1 + State (FIX: MainAxisSize.min added)
          return Container(
            decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Fix: Button failega nahi
              children: [
                GestureDetector(
                  onTap: () {
                    var current = {...cartCountNotifier.value};
                    current[itemId] = (current[itemId] ?? 0) - 1;
                    if (current[itemId]! <= 0) current.remove(itemId);
                    cartCountNotifier.value = current;
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text('-', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                Text('$count', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    var current = {...cartCountNotifier.value};
                    current[itemId] = (current[itemId] ?? 0) + 1;
                    cartCountNotifier.value = current;
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text('+', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}