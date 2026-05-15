import 'package:flutter/material.dart';
import 'items_screen.dart';
import 'app_models.dart';
import '../widgets/adaptive_item_card.dart';
import '../widgets/shared_filter_row.dart';

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}

class SearchCategoryItem {
  final String label, imagePath;
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

  FilterState _filterState = FilterState();

  bool get isDark => false;
  Color get _bgColor => const Color(0xFFF8F9FA);
  Color get _searchBgColor => Colors.white;
  Color get _textPrimary => const Color(0xFF1A1A1A);
  Color get _textSecondary => const Color(0xFF757575);
  Color get _borderColor => Colors.grey.withOpacity(0.15);
  Color get _themeColor => const Color(0xFF4CAF50);

  final List<Color> _pastelColors = [
    const Color(0xFFFFE082), const Color(0xFFFFCDD2), const Color(0xFFF8BBD0),
    const Color(0xFFE1BEE7), const Color(0xFFC5CAE9), const Color(0xFFB2EBF2),
    const Color(0xFFC8E6C9), const Color(0xFFDCEDC8), const Color(0xFFFFF9C4),
  ];

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

  final List<SearchSection> _searchCategories = [
    SearchSection('Vegetables', [
      SearchCategoryItem('Potato', 'assets/images/broccoli.png'),
      SearchCategoryItem('Carrot', 'assets/images/broccoli.png'),
      SearchCategoryItem('Onion', 'assets/images/broccoli.png')
    ]),
    SearchSection('Fruits', [
      SearchCategoryItem('Apple', 'assets/images/broccoli.png'),
      SearchCategoryItem('Banana', 'assets/images/broccoli.png'),
      SearchCategoryItem('Guava', 'assets/images/broccoli.png')
    ]),
    SearchSection('Grocery', [
      SearchCategoryItem('Basmati Rice', 'assets/images/broccoli.png'),
      SearchCategoryItem('Arhar Dal', 'assets/images/broccoli.png'),
      SearchCategoryItem('Mustard Oil', 'assets/images/broccoli.png')
    ]),
    SearchSection('Snacks & Drinks', [
      SearchCategoryItem('Chips', 'assets/images/broccoli.png'),
      SearchCategoryItem('Namkeen', 'assets/images/broccoli.png'),
      SearchCategoryItem('Cold Drinks', 'assets/images/broccoli.png')
    ]),
  ];

  List<Map<String, dynamic>> get _allGroceryItems {
    List<Map<String, dynamic>> allItems = [];
    final groceryMap = globalAllCategoryData[0] ?? {};
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

  // ══════════════════════════════════════════════════════════════════════
  // MAIN FILTERING LOGIC
  // ══════════════════════════════════════════════════════════════════════
  List<Map<String, dynamic>> _applyAllFilters(List<Map<String, dynamic>> items) {
    List<Map<String, dynamic>> results = List.from(items);

    switch (_filterState.sortBy) {
      case 'low_to_high':
        results.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
        break;
      case 'high_to_low':
        results.sort((a, b) => (b['price'] as num).compareTo(a['price'] as num));
        break;
      case 'rating':
        results.sort((a, b) => ((b['rating'] ?? 0) as num).compareTo((a['rating'] ?? 0) as num));
        break;
      case 'popular':
        results.sort((a, b) => ((b['rating'] ?? 0) as num).compareTo((a['rating'] ?? 0) as num));
        break;
      case 'newest':
        break;
      case 'discount':
        results.sort((a, b) => ((b['discount'] ?? 0) as num).compareTo((a['discount'] ?? 0) as num));
        break;
    }

    if (_filterState.priceRange.start > 0 || _filterState.priceRange.end < 1000) {
      results = results.where((p) {
        final price = (p['price'] as num? ?? 0).toDouble();
        return price >= _filterState.priceRange.start && price <= _filterState.priceRange.end;
      }).toList();
    }

    if (_filterState.minRating > 0) {
      results = results.where((p) {
        final rating = (p['rating'] as num? ?? 0).toDouble();
        return rating >= _filterState.minRating;
      }).toList();
    }

    if (_filterState.selectedBrands.isNotEmpty) {
      results = results.where((p) {
        final brand = p['brand']?.toString() ?? '';
        return _filterState.selectedBrands.any(
          (b) => brand.toLowerCase().contains(b.toLowerCase()),
        );
      }).toList();
    }

    if (_filterState.selectedQuantities.isNotEmpty) {
      results = results.where((p) {
        final qty = p['quantity']?.toString() ?? p['unit']?.toString() ?? '';
        return _filterState.selectedQuantities.any(
          (q) => qty.toLowerCase().contains(q.toLowerCase()),
        );
      }).toList();
    }

    if (_filterState.selectedDiscounts.isNotEmpty) {
      results = results.where((p) {
        final discount = (p['discount'] as num? ?? 0).toDouble();
        return _filterState.selectedDiscounts.any((d) {
          if (d.contains('10%')) return discount >= 10;
          if (d.contains('20%')) return discount >= 20;
          if (d.contains('30%')) return discount >= 30;
          if (d.contains('50%')) return discount >= 50;
          if (d.contains('Buy 1 Get 1')) return p['isBogo'] == true;
          if (d.contains('Combo')) return p['isCombo'] == true;
          return false;
        });
      }).toList();
    }

    return results;
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _searchBgColor,
                shape: BoxShape.circle,
                border: Border.all(color: _borderColor),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: _searchBgColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (v) {
                        setState(() {
                          _query = v;
                          _showResults = false;
                        });
                      },
                      onSubmitted: _onSearchSubmit,
                      style: TextStyle(color: _textPrimary, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search Grocery...',
                        hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _query = '';
                          _showResults = false;
                        });
                      },
                      child: Icon(Icons.close_rounded, color: _textSecondary, size: 22),
                    )
                  else
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'YOUR PAST SEARCHES',
            style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2),
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: row1.map((s) => _buildSearchChip(s)).toList()),
              const SizedBox(height: 10),
              Row(children: row2.map((s) => _buildSearchChip(s)).toList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(Map<String, dynamic> search) {
    return GestureDetector(
      onTap: () => _onSearchSubmit(search['label']),
      child: Container(
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
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsScreen(categoryTitle: section.title, tabIndex: 0))),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle),
                  child: const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
      );
      rows.add(const SizedBox(height: 16));
      rows.add(
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: section.items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (ctx, i) {
              final c = section.items[i];
              final boxColor = _pastelColors[(globalIndex + i * 2) % _pastelColors.length];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemsScreen(categoryTitle: section.title, tabIndex: 0))),
                child: Container(
                  width: 115,
                  decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(16)),
                  child: Stack(
                    children: [
                      Positioned(top: 10, left: 12, child: Text(c.label, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w800))),
                      Positioned(
                        bottom: -5, right: -5,
                        child: Image.asset(c.imagePath, height: 80, width: 80, fit: BoxFit.contain,
                          errorBuilder: (ctx, e, s) => const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.shopping_bag, size: 40, color: Colors.black26))),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
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

    if (filtered.isEmpty) {
      return Center(child: Text("No items found", style: TextStyle(color: _textSecondary)));
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.search, color: Colors.grey, size: 20),
        title: Text(filtered[index], style: const TextStyle(fontWeight: FontWeight.w600)),
        onTap: () => _onSearchSubmit(filtered[index]),
      ),
    );
  }

  Widget _buildResultsView() {
    // ── Pre-filtered list for dynamic tags ──
    List<Map<String, dynamic>> baseResults = _allGroceryItems
        .where((p) => p['name'].toString().toLowerCase().contains(_query.toLowerCase()))
        .toList();

    // ── Apply filters for actual display ──
    List<Map<String, dynamic>> results = _applyAllFilters(baseResults);

    List<Map<String, dynamic>> related = [];
    if (results.isNotEmpty) {
      final matchedCategory = results.first['category'];
      related = _allGroceryItems
          .where((p) => p['category'] == matchedCategory && p['id'] != results.first['id'])
          .take(6)
          .toList();
    } else {
      related = _allGroceryItems.take(6).toList();
    }

    return Column(
      children: [
        // ── 🔥 MAIN CHANGE APPLIED HERE ──
        SharedFilterRow(
          tabIndex: 0,
          filterState: _filterState,
          searchResults: baseResults, 
          onFilterChanged: (newState) {
            setState(() {
              _filterState = newState;
            });
          },
        ),

        if (_filterState.hasActiveFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Text(
                  '${results.length} results found',
                  style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _filterState = FilterState()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close_rounded, size: 12, color: Colors.red.shade600),
                        const SizedBox(width: 4),
                        Text('Clear Filters', style: TextStyle(color: Colors.red.shade600, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        Expanded(
          child: results.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 245,
                        ),
                        itemCount: results.length,
                        itemBuilder: (context, index) => AdaptiveItemCard(
                          item: results[index],
                          tabIndex: 0,
                        ),
                      ),

                      if (related.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 16),
                          child: Text("Related Products", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            mainAxisExtent: 245,
                          ),
                          itemCount: related.length,
                          itemBuilder: (context, index) => AdaptiveItemCard(
                            item: related[index],
                            tabIndex: 0,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: Color(0xFFF0F0F0), shape: BoxShape.circle),
            child: const Icon(Icons.search_off_rounded, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text('No results found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(
            _filterState.hasActiveFilters
                ? 'Try removing some filters'
                : 'Try searching something else',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          if (_filterState.hasActiveFilters) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() => _filterState = FilterState()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF4CAF50)),
                ),
                child: const Text('Clear All Filters', style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}