import 'package:flutter/material.dart';
import 'items_screen.dart';
import 'app_models.dart';
import '../widgets/adaptive_item_card.dart'; // ── MAIN FIX: Naya AdaptiveItemCard yahan se aayega ──

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
  Color get _themeColor => const Color(0xFF4CAF50); // Grocery Green

  final List<Color> _pastelColors = [
    const Color(0xFFFFE082), const Color(0xFFFFCDD2), const Color(0xFFF8BBD0),
    const Color(0xFFE1BEE7), const Color(0xFFC5CAE9), const Color(0xFFB2EBF2),
    const Color(0xFFC8E6C9), const Color(0xFFDCEDC8), const Color(0xFFFFF9C4),
  ];

  // ==========================================
  // 1. PAST SEARCHES
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
  ];

  // ==========================================
  // 2. CATEGORY BOXES UI
  // ==========================================
  final List<SearchSection> _searchCategories = [
    SearchSection('Vegetables', [SearchCategoryItem('Potato', 'assets/images/broccoli.png'), SearchCategoryItem('Carrot', 'assets/images/broccoli.png'), SearchCategoryItem('Onion', 'assets/images/broccoli.png')]),
    SearchSection('Fruits', [SearchCategoryItem('Apple', 'assets/images/broccoli.png'), SearchCategoryItem('Banana', 'assets/images/broccoli.png'), SearchCategoryItem('Guava', 'assets/images/broccoli.png')]),
    SearchSection('Grocery', [SearchCategoryItem('Basmati Rice', 'assets/images/broccoli.png'), SearchCategoryItem('Arhar Dal', 'assets/images/broccoli.png'), SearchCategoryItem('Mustard Oil', 'assets/images/broccoli.png')]),
    SearchSection('Snacks & Drinks', [SearchCategoryItem('Chips', 'assets/images/broccoli.png'), SearchCategoryItem('Namkeen', 'assets/images/broccoli.png'), SearchCategoryItem('Cold Drinks', 'assets/images/broccoli.png')]),
  ];

  // ==========================================
  // 3. MASTER DATA FETCHER
  // ==========================================
  List<Map<String, dynamic>> get _allGroceryItems {
    List<Map<String, dynamic>> allItems = [];
    final groceryMap = globalAllCategoryData[0] ?? {}; // 0 is Grocery Tab
    
    groceryMap.forEach((categoryName, items) {
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
    final filtered = _allGroceryItems
        .where((item) => item['name'].toString().toLowerCase().contains(_query.toLowerCase()))
        .map((item) => item['name'].toString())
        .toSet() 
        .toList();

    if(filtered.isEmpty) return Center(child: Text("No items found", style: TextStyle(color: _textSecondary)));
    
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
    final results = _allGroceryItems.where((p) => p['name'].toString().toLowerCase().contains(_query.toLowerCase())).toList();
    
    List<Map<String, dynamic>> related = [];
    if (results.isNotEmpty) {
      String matchedCategory = results.first['category']; 
      related = _allGroceryItems.where((p) => p['category'] == matchedCategory && p['id'] != results.first['id']).take(6).toList();
    } else {
      related = _allGroceryItems.take(6).toList();
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
                    mainAxisExtent: 245 
                  ),
                  itemCount: results.length,
                  // ── MAIN FIX: Replaced old PremiumItemCard with AdaptiveItemCard ──
                  itemBuilder: (context, index) => AdaptiveItemCard(
                    item: results[index], 
                    tabIndex: 0, // 0 For Grocery
                  ), 
                ),
                
                if (related.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 16), child: Text("Related Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 12, mainAxisExtent: 245, 
                    ),
                    itemCount: related.length,
                    itemBuilder: (context, index) => AdaptiveItemCard(
                      item: related[index], 
                      tabIndex: 0, // 0 For Grocery
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