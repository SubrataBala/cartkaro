import 'package:flutter/material.dart';
import 'items_screen.dart';
import 'app_models.dart';
import '../widgets/adaptive_item_card.dart';
import '../widgets/shared_filter_row.dart';

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

class MedicalSearchScreen extends StatefulWidget {
  const MedicalSearchScreen({super.key});
  @override
  State<MedicalSearchScreen> createState() => _MedicalSearchScreenState();
}

class _MedicalSearchScreenState extends State<MedicalSearchScreen> {
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
  final Color _themeColor = const Color(0xFF1565C0);
  final Color _singleSkyBlue = const Color(0xFFE3F2FD);

  final List<Map<String, dynamic>> _pastSearches = [
    {'label': 'Paracetamol', 'icon': Icons.medication},
    {'label': 'Vicks', 'icon': Icons.healing},
    {'label': 'Cough Syrup', 'icon': Icons.local_drink},
    {'label': 'Band-Aid', 'icon': Icons.medical_services},
    {'label': 'Vitamin C', 'icon': Icons.health_and_safety},
    {'label': 'Thermometer', 'icon': Icons.thermostat},
    {'label': 'Digene', 'icon': Icons.science},
    {'label': 'ORS', 'icon': Icons.water_drop},
  ];

  final List<SearchSection> _searchCategories = [
    SearchSection('Daily Medicines', [
      SearchCategoryItem('Fever & Pain', 'assets/images/broccoli.png'),
      SearchCategoryItem('Cold & Cough', 'assets/images/broccoli.png'),
      SearchCategoryItem('Digestion', 'assets/images/broccoli.png'),
    ]),
    SearchSection('Vitamins & Supplements', [
      SearchCategoryItem('Vitamin C', 'assets/images/broccoli.png'),
      SearchCategoryItem('Omega 3', 'assets/images/broccoli.png'),
      SearchCategoryItem('Multivitamins', 'assets/images/broccoli.png'),
    ]),
    SearchSection('First Aid Kits', [
      SearchCategoryItem('Bandages', 'assets/images/broccoli.png'),
      SearchCategoryItem('Antiseptics', 'assets/images/broccoli.png'),
      SearchCategoryItem('Cotton', 'assets/images/broccoli.png'),
    ]),
    SearchSection('Personal Care', [
      SearchCategoryItem('Skin Care', 'assets/images/broccoli.png'),
      SearchCategoryItem('Hair Care', 'assets/images/broccoli.png'),
      SearchCategoryItem('Baby Care', 'assets/images/broccoli.png'),
    ]),
  ];

  List<Map<String, dynamic>> get _allMedicalItems {
    List<Map<String, dynamic>> allItems = [];
    final medicalMap = globalAllCategoryData[2] ?? {};
    medicalMap.forEach((categoryName, items) {
      for (var item in items) {
        var itemCopy = Map<String, dynamic>.from(item);
        itemCopy['category'] = categoryName;
        allItems.add(itemCopy);
      }
    });
    return allItems;
  }

  // ══════════════════════════════════════════════════════════════════════
  // MAIN FILTERING LOGIC
  // ══════════════════════════════════════════════════════════════════════
  List<Map<String, dynamic>> _applyAllFilters(List<Map<String, dynamic>> items) {
    List<Map<String, dynamic>> results = List.from(items);

    switch (_filterState.sortBy) {
      case 'low_to_high':
        results.sort((a, b) => (a['price'] as num? ?? 0).compareTo(b['price'] as num? ?? 0));
        break;
      case 'high_to_low':
        results.sort((a, b) => (b['price'] as num? ?? 0).compareTo(a['price'] as num? ?? 0));
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

    if (_filterState.selectedForms.isNotEmpty) {
      results = results.where((p) {
        final form = p['form']?.toString() ?? p['type']?.toString() ?? '';
        return _filterState.selectedForms.any(
          (f) => form.toLowerCase().contains(f.toLowerCase()),
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
          return false;
        });
      }).toList();
    }

    return results;
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
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
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
                        hintText: 'Search medicines...',
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
              Text('Previously Searched', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.2)),
              Text('CLEAR', style: TextStyle(color: _themeColor, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _pastSearches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (ctx, i) => _buildSearchChip(_pastSearches[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(Map<String, dynamic> search) {
    return GestureDetector(
      onTap: () => _onSearchSubmit(search['label']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(search['icon'], color: _themeColor, size: 14),
            const SizedBox(width: 6),
            Text(search['label'], style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(section.title, style: TextStyle(color: _textPrimary, fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
      );
      rows.add(const SizedBox(height: 12));
      rows.add(
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: section.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) {
            final c = section.items[i];
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ItemsScreen(categoryTitle: section.title, tabIndex: 2))),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: _singleSkyBlue, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Image.asset(c.imagePath, width: 24, height: 24, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(Icons.medical_services, size: 20, color: _themeColor)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Text(c.label, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600))),
                    Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 20),
                  ],
                ),
              ),
            );
          },
        ),
      );
      rows.add(const SizedBox(height: 28));
    }
    return rows;
  }

  Widget _buildSuggestionsView() {
    final filtered = _allMedicalItems
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
    List<Map<String, dynamic>> baseResults = _allMedicalItems
        .where((p) => p['name'].toString().toLowerCase().contains(_query.toLowerCase()))
        .toList();

    // ── Apply filters for actual display ──
    List<Map<String, dynamic>> results = _applyAllFilters(baseResults);

    List<Map<String, dynamic>> related = [];
    if (results.isNotEmpty) {
      final matchedCategory = results.first['category'];
      related = _allMedicalItems
          .where((p) => p['category'] == matchedCategory && p['id'] != results.first['id'])
          .take(6)
          .toList();
    } else {
      related = _allMedicalItems.take(6).toList();
    }

    return Column(
      children: [
        // ── 🔥 MAIN CHANGE APPLIED HERE ──
        SharedFilterRow(
          tabIndex: 2,
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
                  '${results.length} medicines found',
                  style: TextStyle(color: _textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _filterState = FilterState()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close_rounded, size: 12, color: Colors.blue.shade700),
                        const SizedBox(width: 4),
                        Text('Clear Filters', style: TextStyle(color: Colors.blue.shade700, fontSize: 11, fontWeight: FontWeight.w700)),
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
                      ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: (context, index) => AdaptiveItemCard(
                          item: results[index],
                          tabIndex: 2,
                        ),
                      ),

                      if (related.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Text("Frequently bought together", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ),
                        ListView.builder(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: related.length,
                          itemBuilder: (context, index) => AdaptiveItemCard(
                            item: related[index],
                            tabIndex: 2,
                          ),
                        ),
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
            decoration: BoxDecoration(color: _singleSkyBlue, shape: BoxShape.circle),
            child: Icon(Icons.medication_outlined, size: 40, color: _themeColor),
          ),
          const SizedBox(height: 16),
          Text(
            "No medicines found for '$_query'",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _filterState.hasActiveFilters ? 'Try removing some filters' : 'Try searching something else',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          if (_filterState.hasActiveFilters) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() => _filterState = FilterState()),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF1565C0)),
                ),
                child: const Text('Clear All Filters', style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}