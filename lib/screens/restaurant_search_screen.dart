import 'package:flutter/material.dart';
import 'items_screen.dart'; // ── Yahan se aapka purana 'PremiumItemCard' aur 'ItemsScreen' aayega ──
import 'app_models.dart';   // ── Yahan se Notifiers aur Data aayega ──

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

// ── Search UI ke liye simple class (sirf pastel boxes ke liye) ──
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

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showResults = false;

  bool get isDark => false; 
  Color get _bgColor => const Color(0xFFF8F9FA); 
  Color get _searchBgColor => Colors.white;
  Color get _textPrimary => const Color(0xFF1A1A1A); 
  Color get _textSecondary => const Color(0xFF757575);
  Color get _borderColor => Colors.grey.withOpacity(0.15);
  final Color _themeColor = const Color(0xFFE53935); // Restaurant Red

  // ── ⚠️ MAIN CHANGE: Sabhi Tiles ke liye sirf ek Single Light Red color ──
  final Color _singleLightRed = const Color.fromARGB(255, 255, 128, 147); // Light Red background

  // ==========================================
  // 1. PAST SEARCHES
  // ==========================================
  final List<Map<String, dynamic>> _pastSearches = [
    {'label': 'Biryani', 'icon': Icons.rice_bowl},
    {'label': 'Pizza', 'icon': Icons.local_pizza},
    {'label': 'Burger', 'icon': Icons.fastfood},
    {'label': 'Cold Drink', 'icon': Icons.local_drink},
    {'label': 'Momos', 'icon': Icons.set_meal},
    {'label': 'Noodles', 'icon': Icons.ramen_dining},
    {'label': 'Dosa', 'icon': Icons.restaurant},
    {'label': 'Paneer', 'icon': Icons.room_service},
  ];

  // ==========================================
  // 2. CATEGORY CONTENT 
  // ==========================================
  final List<SearchSection> _searchCategories = [
    SearchSection('Top Picks', [SearchCategoryItem('Biryani', 'assets/images/broccoli.png'), SearchCategoryItem('Pizza', 'assets/images/broccoli.png'), SearchCategoryItem('Momos', 'assets/images/broccoli.png')]),
    SearchSection('Trending', [SearchCategoryItem('Burger', 'assets/images/broccoli.png'), SearchCategoryItem('Noodles', 'assets/images/broccoli.png'), SearchCategoryItem('Cold Coffee', 'assets/images/broccoli.png')]),
    SearchSection('Top Cuisines', [SearchCategoryItem('North Indian', 'assets/images/broccoli.png'), SearchCategoryItem('South Indian', 'assets/images/broccoli.png'), SearchCategoryItem('Chinese', 'assets/images/broccoli.png')]),
    SearchSection('Biryani & Pulao', [SearchCategoryItem('Chicken', 'assets/images/broccoli.png'), SearchCategoryItem('Mutton', 'assets/images/broccoli.png'), SearchCategoryItem('Veg Pulao', 'assets/images/broccoli.png')]),
    SearchSection('Pizzas & Burgers', [SearchCategoryItem('Cheese Pizza', 'assets/images/broccoli.png'), SearchCategoryItem('Chicken Burger', 'assets/images/broccoli.png'), SearchCategoryItem('Paneer Burger', 'assets/images/broccoli.png')]),
    SearchSection('Noodles & Momos', [SearchCategoryItem('Hakka', 'assets/images/broccoli.png'), SearchCategoryItem('Steam Momo', 'assets/images/broccoli.png'), SearchCategoryItem('Fried Momo', 'assets/images/broccoli.png')]),
  ];

  // ==========================================
  // 3. MASTER DATA FETCHER
  // ==========================================
  List<Map<String, dynamic>> get _allRestaurantItems {
    List<Map<String, dynamic>> allItems = [];
    final restaurantMap = globalAllCategoryData[1] ?? {}; // 1 is Restaurant Tab
    
    restaurantMap.forEach((categoryName, items) {
      for (var item in items) {
        var itemCopy = Map<String, dynamic>.from(item);
        itemCopy['category'] = categoryName; 
        allItems.add(itemCopy);
      }
    });
    return allItems;
  }

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
                  Expanded(child: TextField(controller: _searchController, autofocus: true, onChanged: (v) { setState(() { _query = v; _showResults = false; }); }, onSubmitted: _onSearchSubmit, style: TextStyle(color: _textPrimary, fontSize: 15), decoration: InputDecoration(hintText: 'Search for dishes...', hintStyle: TextStyle(color: _textSecondary, fontSize: 14), border: InputBorder.none))),
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

  // =========================================================================
  // 🔥 FULLY REDESIGNED DEFAULT VIEW
  // =========================================================================
  Widget _buildDefaultView() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildPastSearches(),
          const SizedBox(height: 30),
          ..._buildSearchCategoryRows(),
        ],
      ),
    );
  }

  Widget _buildPastSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Searches', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
              Text('Clear', style: TextStyle(color: _themeColor, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          )
        ),
        const SizedBox(height: 16),
        // ── Modern Wrap Layout for Chips ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 12,
            children: _pastSearches.map((search) => _buildSearchChip(search)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(Map<String, dynamic> search) {
    return GestureDetector(
      onTap: () => _onSearchSubmit(search['label']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(Icons.history, color: Colors.grey.shade400, size: 16),
            const SizedBox(width: 6), 
            Text(search['label'], style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700))
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchCategoryRows() {
    List<Widget> rows = [];

    for (var section in _searchCategories) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(section.title, style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
        )
      );
      rows.add(const SizedBox(height: 16));
      rows.add(
        // ── Modern 2-Column Grid Tiles ──
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: section.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            childAspectRatio: 2.6, 
            crossAxisSpacing: 12, 
            mainAxisSpacing: 12,
          ),
          itemBuilder: (ctx, i) {
            final c = section.items[i];
            
            return GestureDetector(
              // ── Calling your old ItemsScreen with tabIndex: 1 ──
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => ItemsScreen(categoryTitle: section.title, tabIndex: 1))); },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      decoration: BoxDecoration(
                        // ── ⚠️ MAIN CHANGE: Yahan sirf light red color use ho rha hai ──
                        color: _singleLightRed, 
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                      child: Center(
                        child: Image.asset(c.imagePath, width: 32, height: 32, fit: BoxFit.contain, errorBuilder: (_,__,___) => const Icon(Icons.fastfood, size: 20, color: Colors.black26)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(c.label, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w800), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            );
          },
        )
      );
      rows.add(const SizedBox(height: 32));
    }
    return rows;
  }

  // =========================================================================
  // SEARCH RESULTS VIEW 
  // =========================================================================

  Widget _buildSuggestionsView() {
    final filtered = _allRestaurantItems
        .where((item) => item['name'].toString().toLowerCase().contains(_query.toLowerCase()))
        .map((item) => item['name'].toString())
        .toSet() 
        .toList();

    if(filtered.isEmpty) return Center(child: Text("No dishes found", style: TextStyle(color: _textSecondary)));
    
    return ListView.builder(
      itemCount: filtered.length, 
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.search, color: Colors.grey, size: 20), 
        title: Text(filtered[index], style: const TextStyle(fontWeight: FontWeight.w600)), 
        onTap: () => _onSearchSubmit(filtered[index])
      )
    );
  }

  Widget _buildResultsView() {
    final results = _allRestaurantItems.where((p) => p['name'].toString().toLowerCase().contains(_query.toLowerCase())).toList();
    
    List<Map<String, dynamic>> related = [];
    if (results.isNotEmpty) {
      String matchedCategory = results.first['category']; 
      related = _allRestaurantItems.where((p) => p['category'] == matchedCategory && p['id'] != results.first['id']).take(6).toList();
    } else {
      related = _allRestaurantItems.take(6).toList();
    }

    return Column(
      children: [
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(20, 8, 20, 16), child: Row(children: ['Filters', 'Sort', 'Veg/Non-Veg', 'Price'].map((f) => Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)), child: Row(children: [Text(f, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const SizedBox(width: 4), const Icon(Icons.keyboard_arrow_down, size: 16)]))).toList())),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 12, mainAxisExtent: 245
                  ),
                  itemCount: results.length,
                  // ── MAIN FIX: Calling your old PremiumItemCard ──
                  itemBuilder: (context, index) => PremiumItemCard(
                    item: results[index], isDark: false, themeColor: _themeColor, cartNotifier: restaurantCartNotifier 
                  ), 
                ),
                
                if (related.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 16), child: Text("Related Dishes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 12, mainAxisExtent: 245, 
                    ),
                    itemCount: related.length,
                    itemBuilder: (context, index) => PremiumItemCard(
                      item: related[index], isDark: false, themeColor: _themeColor, cartNotifier: restaurantCartNotifier 
                    ),
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