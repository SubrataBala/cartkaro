import 'package:flutter/material.dart';

ValueNotifier<Map<String, int>> groceryCartNotifier = ValueNotifier({});
ValueNotifier<Map<String, int>> restaurantCartNotifier = ValueNotifier({});
ValueNotifier<Map<String, int>> medicalCartNotifier = ValueNotifier({});

ValueNotifier<Set<String>> watchlistNotifier = ValueNotifier({});

final Map<int, Map<String, List<Map<String, dynamic>>>> globalAllCategoryData = {
  0: { 
    'Vegetables': [
      {
        'id': 'g_v1', 'name': 'Potato', 'image': 'assets/images/broccoli.png', 'weight': '1kg', 'price': '30',
        'isBestseller': true,
        'variants': [{'weight': '500g', 'price': '18'}, {'weight': '1kg', 'price': '30'}, {'weight': '2kg', 'price': '58'}]
      },
      {
        'id': 'g_v2', 'name': 'Carrot', 'image': 'assets/images/broccoli.png', 'weight': '500g', 'price': '40',
        'variants': [{'weight': '250g', 'price': '22'}, {'weight': '500g', 'price': '40'}, {'weight': '1kg', 'price': '75'}]
      },
      {
        'id': 'g_v3', 'name': 'Onion', 'image': 'assets/images/broccoli.png', 'weight': '1kg', 'price': '35',
        'variants': [{'weight': '1kg', 'price': '35'}, {'weight': '5kg', 'price': '160'}]
      },
      {'id': 'g_v4', 'name': 'Cabbage', 'image': 'assets/images/broccoli.png', 'weight': '1 pc', 'price': '45'}, 
    ],
    'Fruits': [
      {'id': 'g_f1', 'name': 'Apple', 'image': 'assets/images/broccoli.png', 'weight': '1kg', 'price': '120', 'isBestseller': true}, 
    ],
  },
  1: { 
    'Biryani & Pulao': [
      {
        'id': 'r_b1', 'name': 'Chicken Biryani', 'image': 'assets/images/broccoli.png', 'weight': 'Full', 'price': '280',
        'isBestseller': true,
        'variants': [{'weight': 'Half', 'price': '160'}, {'weight': 'Full', 'price': '280'}, {'weight': 'Family Pack', 'price': '650'}]
      },
      {'id': 'r_b2', 'name': 'Mutton Biryani', 'weight': 'Full', 'price': '350', 'image': 'assets/images/broccoli.png'},
    ],
  },
  2: { 
    'Daily Medicines': [
      {
        'id': 'm_m1', 'name': 'Paracetamol', 'image': 'assets/images/broccoli.png', 'weight': '10 Tabs', 'price': '20',
        'isBestseller': true,
        'variants': [{'weight': '10 Tabs', 'price': '20'}, {'weight': '15 Tabs', 'price': '28'}]
      },
      {'id': 'm_m2', 'name': 'Cough Syrup', 'weight': '100ml', 'price': '85', 'image': 'assets/images/broccoli.png'},
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

  // --- UPDATED: Force Light Theme (isDark = false) ---
  bool get _isDark => false; 
  Color get _bgColor => const Color(0xFFF8F9FA); 
  Color get _textColor => const Color(0xFF1A1A1A);
  Color get _iconColor => Colors.black;

  Color get _themeColor {
    if (widget.tabIndex == 1) return const Color(0xFFE53935); 
    if (widget.tabIndex == 2) return const Color(0xFF1565C0); 
    return const Color(0xFF4CAF50); 
  }

  ValueNotifier<Map<String, int>> get _activeCartNotifier {
    if (widget.tabIndex == 1) return restaurantCartNotifier;
    if (widget.tabIndex == 2) return medicalCartNotifier;
    return groceryCartNotifier;
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
        backgroundColor: Colors.white,
        elevation: 0.5, // Subtle shadow for better separation on white
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: _iconColor, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text(widget.categoryTitle, style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 50, 
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(color: _textColor, fontSize: 14),
                textAlignVertical: TextAlignVertical.center, 
                decoration: InputDecoration(
                  isDense: true, contentPadding: EdgeInsets.zero, 
                  hintText: "Search in ${widget.categoryTitle}...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search_rounded, color: _themeColor, size: 22),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          Expanded(
            child: _filteredItems.isEmpty 
              ? Center(child: Text("No items available", style: TextStyle(color: _textColor.withOpacity(0.5), fontSize: 16)))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  physics: const ClampingScrollPhysics(), 
                  itemCount: _filteredItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, 
                    mainAxisSpacing: 16, 
                    crossAxisSpacing: 12, 
                    mainAxisExtent: 245, 
                  ),
                  itemBuilder: (context, index) {
                    return PremiumItemCard(
                      item: _filteredItems[index], isDark: _isDark, themeColor: _themeColor, cartNotifier: _activeCartNotifier,
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}

class PremiumItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isDark;
  final Color themeColor;
  final ValueNotifier<Map<String, int>> cartNotifier;

  const PremiumItemCard({super.key, required this.item, required this.isDark, required this.themeColor, required this.cartNotifier});

  @override
  State<PremiumItemCard> createState() => _PremiumItemCardState();
}

class _PremiumItemCardState extends State<PremiumItemCard> {
  int _selectedVariantIndex = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final bool hasVariants = item.containsKey('variants');
    final List variants = hasVariants ? item['variants'] : [{'weight': item['weight'], 'price': item['price']}];
    final currentVariant = variants[_selectedVariantIndex];
    
    final String cartItemId = "${item['id']}|$_selectedVariantIndex";

    Color cardBgColor = Colors.white;
    Color imageBoxBg = const Color(0xFFF3F4F6); 
    Color textColor = const Color(0xFF1A1A1A);

    int price = int.parse(currentVariant['price'].toString());
    int oldPrice = price + 20;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cardBgColor, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90, 
            decoration: BoxDecoration(color: imageBoxBg),
            child: Stack(
              children: [
                Center(child: Padding(padding: const EdgeInsets.all(12), child: Image.asset(item['image']))),
                Positioned(
                  top: 6, left: 6,
                  child: ValueListenableBuilder(
                    valueListenable: watchlistNotifier,
                    builder: (context, Set<String> favs, _) {
                      final isFav = favs.contains(item['id']);
                      return GestureDetector(
                        onTap: () {
                          var newFavs = Set<String>.from(favs);
                          isFav ? newFavs.remove(item['id']) : newFavs.add(item['id']);
                          watchlistNotifier.value = newFavs;
                        },
                        child: Icon(isFav ? Icons.bookmark : Icons.bookmark_border_rounded, color: isFav ? widget.themeColor : textColor.withOpacity(0.3), size: 16),
                      );
                    }
                  ),
                ),
                if (item['isBestseller'] == true)
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.9)),
                      child: const Text('Bestseller', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Text(item['name'], style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 10, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                  
                  Container(
                    height: 24, padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey.shade300)),
                    child: hasVariants 
                      ? DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true, value: _selectedVariantIndex, icon: const Icon(Icons.keyboard_arrow_down, size: 12, color: Colors.black54), dropdownColor: cardBgColor,
                            style: const TextStyle(color: Colors.black87, fontSize: 9, fontWeight: FontWeight.w600),
                            items: variants.asMap().entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value['weight']))).toList(),
                            onChanged: (val) => setState(() => _selectedVariantIndex = val!),
                          ),
                        )
                      : Align(alignment: Alignment.centerLeft, child: Text(item['weight'], style: const TextStyle(color: Colors.black87, fontSize: 9, fontWeight: FontWeight.w600))),
                  ),
                  
                  Row(
                    children: [
                      Text('7 MINS', style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 7, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.green, size: 8),
                      Text(' 4.6 (1.1k)', style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 8, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  
                  const Text('15% OFF', style: TextStyle(color: Colors.green, fontSize: 8, fontWeight: FontWeight.bold)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('₹$price', style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 13)),
                          Text('₹$oldPrice', style: TextStyle(color: textColor.withOpacity(0.4), fontSize: 8, decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      CartAddButton(itemId: cartItemId, themeColor: widget.themeColor, cartNotifier: widget.cartNotifier),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartAddButton extends StatelessWidget {
  final String itemId;
  final Color themeColor;
  final ValueNotifier<Map<String, int>> cartNotifier;

  const CartAddButton({super.key, required this.itemId, required this.themeColor, required this.cartNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cartNotifier,
      builder: (context, Map<String, int> counts, _) {
        final count = counts[itemId] ?? 0;
        if (count == 0) {
          return GestureDetector(
            onTap: () { var current = {...cartNotifier.value}; current[itemId] = 1; cartNotifier.value = current; },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: themeColor), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
              child: Text('ADD', style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 9)),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(4), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
            child: Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                GestureDetector(onTap: () { var current = {...cartNotifier.value}; current[itemId] = (current[itemId] ?? 0) - 1; if (current[itemId]! <= 0) current.remove(itemId); cartNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4), child: Text('-', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
                Text('$count', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                GestureDetector(onTap: () { var current = {...cartNotifier.value}; current[itemId] = (current[itemId] ?? 0) + 1; cartNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4), child: Text('+', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
              ],
            ),
          );
        }
      },
    );
  }
}