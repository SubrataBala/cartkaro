import 'package:flutter/material.dart';
import 'search_screen.dart'; 
import 'items_screen.dart'; // Yahan se cartNotifier aur watchlistNotifier aayega

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

// --- UPDATED MODEL: Added 'category' field ---
class GroceryProduct {
  final String id;
  final String name;
  final String category; // <-- Naya Category Field
  final String deliveryTime;
  final double rating;
  final String ratingCount;
  final String image;
  final bool isBestseller;
  final List<Map<String, dynamic>> variants;

  GroceryProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.deliveryTime,
    required this.rating,
    required this.ratingCount,
    required this.image,
    required this.variants,
    this.isBestseller = false,
  });
}

class GrocerySearchScreen extends StatefulWidget {
  const GrocerySearchScreen({super.key});

  @override
  State<GrocerySearchScreen> createState() => _GrocerySearchScreenState();
}

class _GrocerySearchScreenState extends State<GrocerySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showResults = false;

  bool get isDark => false; 
  Color get _bgColor => const Color(0xFFF8F9FA); 
  Color get _searchBgColor => Colors.white;
  Color get _textPrimary => const Color(0xFF1A1A1A); 
  Color get _textSecondary => const Color(0xFF757575);
  Color get _borderColor => Colors.grey.withOpacity(0.15);

  final List<Color> _pastelColors = [
    const Color(0xFFFFE082), const Color(0xFFFFCDD2), const Color(0xFFF8BBD0),
    const Color(0xFFE1BEE7), const Color(0xFFC5CAE9), const Color(0xFFB2EBF2),
    const Color(0xFFC8E6C9), const Color(0xFFDCEDC8), const Color(0xFFFFF9C4),
  ];

  // ==========================================
  // 1. FULL PAST SEARCHES DATA
  // ==========================================
  final List<Map<String, dynamic>> _pastSearches = [
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

  // ==========================================
  // 2. FULL CATEGORIES DATA
  // ==========================================
  final List<SearchSection> _searchCategories = [
    SearchSection('Vegetables', [SearchCategoryItem('Potato', 'assets/images/broccoli.png'), SearchCategoryItem('Carrot', 'assets/images/broccoli.png'), SearchCategoryItem('Onion', 'assets/images/broccoli.png'), SearchCategoryItem('Tomato', 'assets/images/broccoli.png')]),
    SearchSection('Fruits', [SearchCategoryItem('Apple', 'assets/images/broccoli.png'), SearchCategoryItem('Banana', 'assets/images/broccoli.png'), SearchCategoryItem('Guava', 'assets/images/broccoli.png'), SearchCategoryItem('Papaya', 'assets/images/broccoli.png')]),
    SearchSection('Grocery', [SearchCategoryItem('Basmati Rice', 'assets/images/broccoli.png'), SearchCategoryItem('Arhar Dal', 'assets/images/broccoli.png'), SearchCategoryItem('Mustard Oil', 'assets/images/broccoli.png'), SearchCategoryItem('Atta', 'assets/images/broccoli.png')]),
    SearchSection('Snacks & Drinks', [SearchCategoryItem('Chips', 'assets/images/broccoli.png'), SearchCategoryItem('Namkeen', 'assets/images/broccoli.png'), SearchCategoryItem('Cold Drinks', 'assets/images/broccoli.png'), SearchCategoryItem('Juices', 'assets/images/broccoli.png')]),
    SearchSection('For home', [SearchCategoryItem('Floor Cleaner', 'assets/images/broccoli.png'), SearchCategoryItem('Detergent', 'assets/images/broccoli.png'), SearchCategoryItem('Towels', 'assets/images/broccoli.png'), SearchCategoryItem('Bulbs', 'assets/images/broccoli.png')]),
  ];

  // ==========================================
  // 3. FULL SUGGESTIONS KEYWORDS
  // ==========================================
  final List<String> _allSuggestions = [
    "Potato", "Sweet Potato", "Carrot", "Onion", "Cabbage", "Tomato", "Broccoli", 
    "Apple", "Banana", "Guava", "Papaya", 
    "Milk", "Eggs", "Bread", "Butter", "Paneer",
    "Basmati Rice", "Atta", "Arhar Dal", "Mustard Oil", "Sugar", "Tea",
    "Chips", "Namkeen", "Cold Drink", "Juice", "Cookies",
    "Soap", "Detergent", "Floor Cleaner", "Towels"
  ];
  
  // ==========================================
  // 4. FULL PRODUCTS DATA WITH VARIANTS (20+ Items)
  // ==========================================
  final List<GroceryProduct> _allProducts = [
    // --- VEGETABLES ---
    GroceryProduct(
      id: 'g_v1', name: 'Potato', category: 'Vegetables', image: 'assets/images/broccoli.png', deliveryTime: '7 MINS', rating: 4.6, ratingCount: '1.1k', isBestseller: true,
      variants: [{'weight': '500g', 'price': 18, 'mrp': 38, 'discount': 15}, {'weight': '1kg', 'price': 30, 'mrp': 58, 'discount': 20}, {'weight': '2kg', 'price': 58, 'mrp': 110, 'discount': 25}]
    ),
    GroceryProduct(
      id: 'g_v2', name: 'Sweet Potato', category: 'Vegetables', image: 'assets/images/broccoli.png', deliveryTime: '7 MINS', rating: 4.6, ratingCount: '1.1k',
      variants: [{'weight': '250g', 'price': 22, 'mrp': 42, 'discount': 15}, {'weight': '500g', 'price': 40, 'mrp': 75, 'discount': 20}]
    ),
    GroceryProduct(
      id: 'g_v3', name: 'Onion', category: 'Vegetables', image: 'assets/images/broccoli.png', deliveryTime: '7 MINS', rating: 4.6, ratingCount: '1.1k', isBestseller: true,
      variants: [{'weight': '1kg', 'price': 35, 'mrp': 55, 'discount': 15}, {'weight': '5kg', 'price': 160, 'mrp': 250, 'discount': 25}]
    ),
    GroceryProduct(
      id: 'g_v4', name: 'Cabbage', category: 'Vegetables', image: 'assets/images/broccoli.png', deliveryTime: '7 MINS', rating: 4.6, ratingCount: '1.1k',
      variants: [{'weight': '1 pc', 'price': 45, 'mrp': 65, 'discount': 15}]
    ),
    GroceryProduct(
      id: 'g_v5', name: 'Tomato Local', category: 'Vegetables', image: 'assets/images/broccoli.png', deliveryTime: '7 MINS', rating: 4.5, ratingCount: '2k', isBestseller: true,
      variants: [{'weight': '500g', 'price': 25, 'mrp': 40, 'discount': 10}, {'weight': '1kg', 'price': 45, 'mrp': 70, 'discount': 15}]
    ),
    GroceryProduct(
      id: 'g_v6', name: 'Fresh Broccoli', category: 'Vegetables', image: 'assets/images/broccoli.png', deliveryTime: '7 MINS', rating: 4.8, ratingCount: '500',
      variants: [{'weight': '1 pc (Approx 250g)', 'price': 60, 'mrp': 80, 'discount': 20}]
    ),

    // --- FRUITS ---
    GroceryProduct(
      id: 'g_f1', name: 'Apple Fuji', category: 'Fruits', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.8, ratingCount: '5k', isBestseller: true,
      variants: [{'weight': '4 pcs', 'price': 120, 'mrp': 150, 'discount': 20}, {'weight': '1kg', 'price': 200, 'mrp': 250, 'discount': 20}]
    ),
    GroceryProduct(
      id: 'g_f2', name: 'Banana Robusta', category: 'Fruits', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.7, ratingCount: '3k', isBestseller: true,
      variants: [{'weight': '6 pcs', 'price': 40, 'mrp': 50, 'discount': 20}, {'weight': '12 pcs', 'price': 75, 'mrp': 100, 'discount': 25}]
    ),
    GroceryProduct(
      id: 'g_f3', name: 'Guava', category: 'Fruits', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.5, ratingCount: '1k',
      variants: [{'weight': '500g', 'price': 50, 'mrp': 65, 'discount': 15}]
    ),

    // --- DAIRY & BAKERY (Mapped to Grocery in Categories) ---
    GroceryProduct(
      id: 'g_d1', name: 'Amul Taaza Milk', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.9, ratingCount: '15k', isBestseller: true,
      variants: [{'weight': '500ml', 'price': 27, 'mrp': 27, 'discount': 0}, {'weight': '1 L', 'price': 54, 'mrp': 54, 'discount': 0}]
    ),
    GroceryProduct(
      id: 'g_d2', name: 'White Eggs', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.7, ratingCount: '8k', isBestseller: true,
      variants: [{'weight': '6 pcs', 'price': 55, 'mrp': 65, 'discount': 10}, {'weight': '30 pcs', 'price': 250, 'mrp': 300, 'discount': 15}]
    ),
    GroceryProduct(
      id: 'g_d3', name: 'Brown Bread', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.6, ratingCount: '4k',
      variants: [{'weight': '1 Pack (400g)', 'price': 40, 'mrp': 45, 'discount': 10}]
    ),
    GroceryProduct(
      id: 'g_d4', name: 'Amul Butter', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.8, ratingCount: '9k',
      variants: [{'weight': '100g', 'price': 54, 'mrp': 54, 'discount': 0}, {'weight': '500g', 'price': 265, 'mrp': 265, 'discount': 0}]
    ),

    // --- STAPLES / GROCERY ---
    GroceryProduct(
      id: 'g_g1', name: 'India Gate Basmati Rice', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '30 MINS', rating: 4.8, ratingCount: '12k', isBestseller: true,
      variants: [{'weight': '1kg', 'price': 110, 'mrp': 140, 'discount': 18}, {'weight': '5kg', 'price': 520, 'mrp': 650, 'discount': 20}]
    ),
    GroceryProduct(
      id: 'g_g2', name: 'Aashirvaad Shudh Chakki Atta', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '30 MINS', rating: 4.7, ratingCount: '18k', isBestseller: true,
      variants: [{'weight': '1kg', 'price': 55, 'mrp': 60, 'discount': 5}, {'weight': '5kg', 'price': 240, 'mrp': 280, 'discount': 14}, {'weight': '10kg', 'price': 450, 'mrp': 530, 'discount': 15}]
    ),
    GroceryProduct(
      id: 'g_g3', name: 'Tata Sampann Arhar Dal', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.6, ratingCount: '6k',
      variants: [{'weight': '500g', 'price': 85, 'mrp': 100, 'discount': 15}, {'weight': '1kg', 'price': 160, 'mrp': 190, 'discount': 16}]
    ),
    GroceryProduct(
      id: 'g_g4', name: 'Fortune Mustard Oil', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.5, ratingCount: '8k',
      variants: [{'weight': '1 L', 'price': 145, 'mrp': 175, 'discount': 17}]
    ),
    GroceryProduct(
      id: 'g_g5', name: 'Madhur Pure & Hygienic Sugar', category: 'Grocery', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.8, ratingCount: '10k', isBestseller: true,
      variants: [{'weight': '1kg', 'price': 48, 'mrp': 55, 'discount': 12}, {'weight': '5kg', 'price': 230, 'mrp': 265, 'discount': 13}]
    ),

    // --- SNACKS & DRINKS ---
    GroceryProduct(
      id: 'g_s1', name: 'Lay\'s Classic Salted Chips', category: 'Snacks & Drinks', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.5, ratingCount: '25k', isBestseller: true,
      variants: [{'weight': '52g', 'price': 20, 'mrp': 20, 'discount': 0}, {'weight': '90g', 'price': 40, 'mrp': 40, 'discount': 0}]
    ),
    GroceryProduct(
      id: 'g_s2', name: 'Haldiram\'s Bhujia Sev', category: 'Snacks & Drinks', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.7, ratingCount: '14k',
      variants: [{'weight': '200g', 'price': 55, 'mrp': 60, 'discount': 8}, {'weight': '400g', 'price': 105, 'mrp': 120, 'discount': 12}]
    ),
    GroceryProduct(
      id: 'g_s3', name: 'Coca Cola Soft Drink', category: 'Snacks & Drinks', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.6, ratingCount: '20k', isBestseller: true,
      variants: [{'weight': '750ml', 'price': 40, 'mrp': 40, 'discount': 0}, {'weight': '1.25 L', 'price': 65, 'mrp': 65, 'discount': 0}]
    ),
    GroceryProduct(
      id: 'g_s4', name: 'Real Mixed Fruit Juice', category: 'Snacks & Drinks', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.5, ratingCount: '8k',
      variants: [{'weight': '1 L', 'price': 110, 'mrp': 130, 'discount': 15}]
    ),

    // --- FOR HOME ---
    GroceryProduct(
      id: 'g_h1', name: 'Surf Excel Easy Wash', category: 'For home', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.8, ratingCount: '18k', isBestseller: true,
      variants: [{'weight': '1kg', 'price': 115, 'mrp': 135, 'discount': 15}, {'weight': '3kg', 'price': 340, 'mrp': 400, 'discount': 15}]
    ),
    GroceryProduct(
      id: 'g_h2', name: 'Harpic Power Plus Toilet Cleaner', category: 'For home', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.7, ratingCount: '11k',
      variants: [{'weight': '500ml', 'price': 93, 'mrp': 105, 'discount': 11}, {'weight': '1 L', 'price': 180, 'mrp': 210, 'discount': 14}]
    ),
  ];
  void _onSearchSubmit(String val) {
    if (val.isEmpty) return;
    setState(() {
      _query = val;
      _searchController.text = val;
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: NoJellyScrollBehavior(),
          child: Column(
            children: [
              _buildSearchHeader(),
              Expanded(
                child: _searchController.text.isEmpty
                    ? _buildDefaultView()      
                    : _showResults 
                        ? _buildResultsView()  
                        : _buildSuggestionsView(), 
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
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _searchBgColor, shape: BoxShape.circle, border: Border.all(color: _borderColor)), child: Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 20))),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50, decoration: BoxDecoration(color: _searchBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: _searchController, autofocus: true, onChanged: (v) { setState(() { _query = v; _showResults = false; }); }, onSubmitted: _onSearchSubmit, style: TextStyle(color: _textPrimary, fontSize: 15), decoration: InputDecoration(hintText: 'Search Grocery...', hintStyle: TextStyle(color: _textSecondary, fontSize: 14), border: InputBorder.none))),
                  if (_searchController.text.isNotEmpty) GestureDetector(onTap: () { _searchController.clear(); setState(() { _query = ''; _showResults = false; }); }, child: Icon(Icons.close_rounded, color: _textSecondary, size: 22)) else Icon(Icons.mic_none_rounded, color: _textSecondary, size: 22),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultView() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildPastSearches(),
          const SizedBox(height: 30),
          ..._buildSearchCategoryRows(),
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
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('YOUR PAST SEARCHES', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2))),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, physics: const ClampingScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              Row(children: row1.map((search) => _buildSearchChip(search)).toList()), 
              const SizedBox(height: 10), 
              Row(children: row2.map((search) => _buildSearchChip(search)).toList())
            ]
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(Map<String, dynamic> search) {
    return GestureDetector(
      onTap: () => _onSearchSubmit(search['label']),
      child: Container(
        margin: const EdgeInsets.only(right: 10), height: 38, padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: search['color'], borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(search['icon'], color: Colors.black87, size: 16), const SizedBox(width: 6), Text(search['label'], style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w700))]),
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
              GestureDetector(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsScreen(categoryTitle: section.title, tabIndex: 0))); }, child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle), child: const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.black, size: 20))),
            ],
          ),
        )
      );
      rows.add(const SizedBox(height: 16));
      rows.add(
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal, physics: const ClampingScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: section.items.length, separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (ctx, i) {
              final c = section.items[i];
              final boxColor = _pastelColors[(globalIndex + i * 2) % _pastelColors.length]; 
              return GestureDetector(
                onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsScreen(categoryTitle: section.title, tabIndex: 0))); },
                child: Container(
                  width: 115, decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(16)),
                  child: Stack(children: [Positioned(top: 10, left: 12, child: Text(c.label, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w800))), Positioned(bottom: -5, right: -5, child: Image.asset(c.imagePath, height: 80, width: 80, fit: BoxFit.contain, errorBuilder: (ctx,e,s) => const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.shopping_bag, size: 40, color: Colors.black26))))]),
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

  Widget _buildSuggestionsView() {
    final filtered = _allSuggestions.where((item) => item.toLowerCase().contains(_query.toLowerCase())).toList();
    if(filtered.isEmpty) return Center(child: Text("No items found", style: TextStyle(color: _textSecondary)));
    return ListView.builder(itemCount: filtered.length, itemBuilder: (context, index) => ListTile(leading: const Icon(Icons.search, color: Colors.grey, size: 20), title: Text(filtered[index], style: const TextStyle(fontWeight: FontWeight.w600)), onTap: () => _onSearchSubmit(filtered[index])));
  }

  Widget _buildResultsView() {
    final results = _allProducts.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();
    
    // --- SMART RELATED PRODUCTS LOGIC ---
    List<GroceryProduct> related = [];
    if (results.isNotEmpty) {
      String matchedCategory = results.first.category; // E.g., 'Vegetables'
      related = _allProducts.where((p) => p.category == matchedCategory && !results.contains(p)).take(6).toList();
    } else {
      related = _allProducts.take(6).toList();
    }

    return Column(
      children: [
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(20, 8, 20, 16), child: Row(children: ['Filters', 'Sort', 'Quantity', 'Price'].map((f) => Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)), child: Row(children: [Text(f, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const SizedBox(width: 4), const Icon(Icons.keyboard_arrow_down, size: 16)]))).toList())),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, 
                    mainAxisSpacing: 16, 
                    crossAxisSpacing: 12, 
                    mainAxisExtent: 260 
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) => SearchProductCard(product: results[index]), 
                ),
                
                if (related.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 16), child: Text("Related Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 12, mainAxisExtent: 260, 
                    ),
                    itemCount: related.length,
                    itemBuilder: (context, index) => SearchProductCard(product: related[index]),
                  ),
                  const SizedBox(height: 30),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// STATEFUL PRODUCT CARD (Variant Dropdown, Cart, Watchlist Working)
// =========================================================================
class SearchProductCard extends StatefulWidget {
  final GroceryProduct product;
  const SearchProductCard({super.key, required this.product});

  @override
  State<SearchProductCard> createState() => _SearchProductCardState();
}

class _SearchProductCardState extends State<SearchProductCard> {
  int _selectedVariantIndex = 0;
  final Color _themeColor = const Color(0xFF4CAF50); 

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final currentVariant = product.variants[_selectedVariantIndex];
    
    // Yeh ID Cart aur Watchlist ko match karegi
    final String cartItemId = "${product.id}|$_selectedVariantIndex";

    int price = int.parse(currentVariant['price'].toString());
    int mrp = int.parse(currentVariant['mrp'].toString());
    int discount = int.parse(currentVariant['discount'].toString());

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(height: 90, decoration: const BoxDecoration(color: Color(0xFFF4F5F7), borderRadius: BorderRadius.vertical(top: Radius.circular(12))), child: Center(child: Image.asset(product.image, height: 60, errorBuilder: (_,__,___) => Text('🥦', style: TextStyle(fontSize: 40))))),
              
              Positioned(
                top: 6, left: 6, 
                child: ValueListenableBuilder(
                  valueListenable: watchlistNotifier,
                  builder: (context, Set<String> favs, _) {
                    final isFav = favs.contains(product.id);
                    return GestureDetector(
                      onTap: () {
                        var newFavs = Set<String>.from(favs);
                        isFav ? newFavs.remove(product.id) : newFavs.add(product.id);
                        watchlistNotifier.value = newFavs;
                      },
                      child: Icon(isFav ? Icons.bookmark : Icons.bookmark_border_rounded, color: isFav ? _themeColor : Colors.grey, size: 20),
                    );
                  }
                ),
              ),

              if (product.isBestseller)
                Positioned(bottom: 0, left: 0, right: 0, child: Container(color: const Color(0xFF5A8DFF), padding: const EdgeInsets.symmetric(vertical: 2), child: const Center(child: Text('Bestseller', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))),
            ],
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                  
                  Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 4), 
                    decoration: BoxDecoration(color: const Color(0xFFF8F9FA), border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)), 
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        isExpanded: true, value: _selectedVariantIndex, icon: Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.grey.shade600), dropdownColor: Colors.white,
                        style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w600),
                        items: product.variants.asMap().entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value['weight']))).toList(),
                        onChanged: (val) => setState(() => _selectedVariantIndex = val!),
                      ),
                    )
                  ),
                  
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(product.deliveryTime, style: TextStyle(fontSize: 8, color: Colors.grey.shade500, fontWeight: FontWeight.w800)), Row(children: [Icon(Icons.star, size: 10, color: Colors.green.shade600), const SizedBox(width: 2), Text('${product.rating} (${product.ratingCount})', style: const TextStyle(fontSize: 8, color: Colors.black87, fontWeight: FontWeight.bold))])]),
                  
                  if (discount > 0) Text('$discount% OFF', style: const TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold))
                  else const Text('', style: TextStyle(fontSize: 9)),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('₹$price', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), if (discount > 0) Text('₹$mrp', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 9))]),
                      
                      ValueListenableBuilder(
                        valueListenable: groceryCartNotifier,
                        builder: (context, Map<String, int> counts, _) {
                          final count = counts[cartItemId] ?? 0;
                          if (count == 0) {
                            return GestureDetector(
                              onTap: () { var current = {...groceryCartNotifier.value}; current[cartItemId] = 1; groceryCartNotifier.value = current; },
                              child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.green, width: 1.2), borderRadius: BorderRadius.circular(6)), child: const Text('ADD', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w900, fontSize: 10))),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, 
                                children: [
                                  GestureDetector(onTap: () { var current = {...groceryCartNotifier.value}; current[cartItemId] = (current[cartItemId] ?? 0) - 1; if (current[cartItemId]! <= 0) current.remove(cartItemId); groceryCartNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4), child: Text('-', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
                                  Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  GestureDetector(onTap: () { var current = {...groceryCartNotifier.value}; current[cartItemId] = (current[cartItemId] ?? 0) + 1; groceryCartNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4), child: Text('+', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}