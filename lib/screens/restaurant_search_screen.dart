import 'package:flutter/material.dart';
import 'app_models.dart';
import 'restaurant_menu_screen.dart';
import 'restaurant_data.dart';
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

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});
  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
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
  final Color _themeColor = const Color(0xFFE53935);
  final Color _singleLightRed = const Color.fromARGB(255, 255, 128, 147);

  final List<Map<String, dynamic>> _pastSearches = [
    {'label': 'Biryani', 'icon': Icons.rice_bowl},
    {'label': 'Pizza', 'icon': Icons.local_pizza},
    {'label': 'Burger', 'icon': Icons.fastfood},
    {'label': 'Cold Coffee', 'icon': Icons.local_cafe},
    {'label': 'Momos', 'icon': Icons.set_meal},
    {'label': 'Noodles', 'icon': Icons.ramen_dining},
    {'label': 'Masala Dosa', 'icon': Icons.restaurant},
    {'label': 'Paneer Tikka', 'icon': Icons.room_service},
    {'label': 'Ice Cream', 'icon': Icons.icecream},
    {'label': 'Chole Bhature', 'icon': Icons.dinner_dining},
  ];

  final List<SearchSection> _searchCategories = [
    SearchSection('Top Picks For You', [
      SearchCategoryItem('Chicken Biryani', 'assets/images/broccoli.png'),
      SearchCategoryItem('Margherita Pizza', 'assets/images/broccoli.png'),
      SearchCategoryItem('Paneer Butter Masala', 'assets/images/broccoli.png'),
      SearchCategoryItem('Chicken Roll', 'assets/images/broccoli.png'),
    ]),
    SearchSection('Trending This Week', [
      SearchCategoryItem('Zinger Burger', 'assets/images/burger.png'),
      SearchCategoryItem('Hakka Noodles', 'assets/images/broccoli.png'),
      SearchCategoryItem('Cold Coffee', 'assets/images/broccoli.png'),
      SearchCategoryItem('Choco Lava Cake', 'assets/images/broccoli.png'),
    ]),
    SearchSection('Top Cuisines', [
      SearchCategoryItem('North Indian', 'assets/images/broccoli.png'),
      SearchCategoryItem('South Indian', 'assets/images/broccoli.png'),
      SearchCategoryItem('Chinese', 'assets/images/broccoli.png'),
      SearchCategoryItem('Italian', 'assets/images/broccoli.png'),
    ]),
    SearchSection('Biryani & Pulao', [
      SearchCategoryItem('Hyderabadi', 'assets/images/broccoli.png'),
      SearchCategoryItem('Lucknowi', 'assets/images/broccoli.png'),
      SearchCategoryItem('Kolkata Biryani', 'assets/images/broccoli.png'),
      SearchCategoryItem('Veg Pulao', 'assets/images/broccoli.png'),
    ]),
    SearchSection('Fast Food & Snacks', [
      SearchCategoryItem('Pizzas', 'assets/images/broccoli.png'),
      SearchCategoryItem('Burgers', 'assets/images/burger.png'),
      SearchCategoryItem('Sandwiches', 'assets/images/broccoli.png'),
      SearchCategoryItem('Fries', 'assets/images/broccoli.png'),
    ]),
    SearchSection('Street Food & Chaat', [
      SearchCategoryItem('Pani Puri', 'assets/images/broccoli.png'),
      SearchCategoryItem('Pav Bhaji', 'assets/images/broccoli.png'),
      SearchCategoryItem('Samosa', 'assets/images/broccoli.png'),
      SearchCategoryItem('Vada Pav', 'assets/images/broccoli.png'),
    ]),
    SearchSection('Desserts & Drinks', [
      SearchCategoryItem('Ice Cream', 'assets/images/broccoli.png'),
      SearchCategoryItem('Milkshakes', 'assets/images/broccoli.png'),
      SearchCategoryItem('Gulab Jamun', 'assets/images/broccoli.png'),
      SearchCategoryItem('Sweet Lassi', 'assets/images/broccoli.png'),
    ]),
  ];

  List<Map<String, dynamic>> get _extractedRestaurants {
    List<Map<String, dynamic>> resList = [];
    Set<String> addedRes = {};
    restaurantData.forEach((category, items) {
      for (var item in items) {
        String resName = item['restaurant'] ?? 'Unknown Restaurant';
        if (!addedRes.contains(resName)) {
          addedRes.add(resName);
          List<Map<String, dynamic>> resMenu = [];
          restaurantData.forEach((cat, itms) {
            resMenu.addAll(itms.where((i) => i['restaurant'] == resName).map((i) {
              var newItem = Map<String, dynamic>.from(i);
              newItem['category'] = cat;
              return newItem;
            }));
          });
          resList.add({
            'name': resName,
            'image': item['image'],
            'categories': category,
            'rating': item['rating'] ?? '4.5',
            'time': item['time'] ?? '30 Mins',
            'distance': item['distance'] ?? '2.0 km',
            'totalSells': item['totalSells'] ?? '1K+ orders',
            'isVeg': item['isVeg'] ?? false,
            'menu': resMenu,
          });
        }
      }
    });
    return resList;
  }

  List<Map<String, dynamic>> get _matchedRestaurants {
    final restaurants = _extractedRestaurants;
    if (_query.isEmpty) return restaurants;
    List<Map<String, dynamic>> results = [];
    String queryLower = _query.toLowerCase();
    for (var res in restaurants) {
      bool isMatch = res['name'].toString().toLowerCase().contains(queryLower);
      if (!isMatch) {
        List menu = res['menu'];
        for (var item in menu) {
          if (item['name'].toString().toLowerCase().contains(queryLower)) {
            isMatch = true;
            break;
          }
        }
      }
      if (isMatch) results.add(res);
    }
    return results;
  }

  List<Map<String, dynamic>> _applyAllFilters(List<Map<String, dynamic>> restaurants) {
    List<Map<String, dynamic>> results = List.from(restaurants);

    switch (_filterState.sortBy) {
      case 'rating':
        results.sort((a, b) {
          final ratingA = double.tryParse(a['rating'].toString()) ?? 0;
          final ratingB = double.tryParse(b['rating'].toString()) ?? 0;
          return ratingB.compareTo(ratingA);
        });
        break;
      case 'popular':
        results.sort((a, b) {
          final aVal = _parseSells(a['totalSells'].toString());
          final bVal = _parseSells(b['totalSells'].toString());
          return bVal.compareTo(aVal);
        });
        break;
      case 'low_to_high':
        results.sort((a, b) {
          final aMin = _getMinPrice(a['menu'] as List);
          final bMin = _getMinPrice(b['menu'] as List);
          return aMin.compareTo(bMin);
        });
        break;
      case 'high_to_low':
        results.sort((a, b) {
          final aMin = _getMinPrice(a['menu'] as List);
          final bMin = _getMinPrice(b['menu'] as List);
          return bMin.compareTo(aMin);
        });
        break;
      case 'newest':
        results.sort((a, b) => (b['isNew'] == true ? 1 : 0).compareTo(a['isNew'] == true ? 1 : 0));
        break;
    }

    if (_filterState.vegFilter == 'veg') {
      results = results.where((r) {
        return r['isVeg'] == true ||
            (r['menu'] as List).any((item) => item['isVeg'] == true);
      }).toList();
    } else if (_filterState.vegFilter == 'non_veg') {
      results = results.where((r) {
        return r['isVeg'] == false ||
            (r['menu'] as List).any((item) => item['isVeg'] == false);
      }).toList();
    }

    if (_filterState.distanceFilter != 'all') {
      final maxKm = double.tryParse(
            _filterState.distanceFilter.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          100;
      results = results.where((r) {
        final distStr = r['distance'].toString().replaceAll(RegExp(r'[^0-9.]'), '');
        final dist = double.tryParse(distStr) ?? 0;
        return dist <= maxKm;
      }).toList();
    }

    if (_filterState.minRating > 0) {
      results = results.where((r) {
        final rating = double.tryParse(r['rating'].toString()) ?? 0;
        return rating >= _filterState.minRating;
      }).toList();
    }

    return results;
  }

  double _parseSells(String sells) {
    sells = sells.toLowerCase().replaceAll('+', '').replaceAll(' orders', '').trim();
    if (sells.endsWith('k')) return (double.tryParse(sells.replaceAll('k', '')) ?? 0) * 1000;
    if (sells.endsWith('m')) return (double.tryParse(sells.replaceAll('m', '')) ?? 0) * 1000000;
    return double.tryParse(sells) ?? 0;
  }

  double _getMinPrice(List menu) {
    if (menu.isEmpty) return 0;
    double min = double.infinity;
    for (var item in menu) {
      final price = (item['price'] as num? ?? 0).toDouble();
      if (price < min) min = price;
    }
    return min == double.infinity ? 0 : min;
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
                        hintText: 'Search for dishes or restaurants...',
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
              Text('Recent Searches', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
              Text('Clear', style: TextStyle(color: _themeColor, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 12,
            children: _pastSearches.map((s) => _buildSearchChip(s)).toList(),
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
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(search['icon'], color: Colors.grey.shade400, size: 16),
            const SizedBox(width: 6),
            Text(search['label'], style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchCategoryRows() {
    List<Widget> rows = [];
    for (var section in _searchCategories) {
      rows.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(section.title, style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
      ));
      rows.add(const SizedBox(height: 16));
      rows.add(
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: section.items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 2.6, crossAxisSpacing: 12, mainAxisSpacing: 12,
          ),
          itemBuilder: (ctx, i) {
            final c = section.items[i];
            return GestureDetector(
              onTap: () => _onSearchSubmit(c.label),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      decoration: BoxDecoration(
                        color: _singleLightRed,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                      ),
                      child: Center(
                        child: Image.asset(c.imagePath, width: 32, height: 32, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, color: Colors.white, size: 24)),
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
        ),
      );
      rows.add(const SizedBox(height: 32));
    }
    return rows;
  }

  Widget _buildSuggestionsView() {
    final restaurants = _matchedRestaurants;
    if (restaurants.isEmpty) {
      return Center(child: Text("No restaurants or dishes found", style: TextStyle(color: _textSecondary)));
    }
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.restaurant, color: Colors.grey, size: 20),
        title: Text(restaurants[index]['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("Sells $_query", style: const TextStyle(fontSize: 12, color: Colors.grey)),
        onTap: () => _onSearchSubmit(restaurants[index]['name']),
      ),
    );
  }

  Widget _buildResultsView() {
    // ── Pre-filtered list for dynamic tags ──
    List<Map<String, dynamic>> baseRestaurants = _matchedRestaurants;
    
    // ── Apply filters for actual display ──
    List<Map<String, dynamic>> restaurants = _applyAllFilters(baseRestaurants);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 🔥 MAIN CHANGE APPLIED HERE ──
        SharedFilterRow(
          tabIndex: 1,
          filterState: _filterState,
          searchResults: baseRestaurants,
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
                  '${restaurants.length} restaurants found',
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

        if (!_filterState.hasActiveFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text(
              'Restaurants selling "$_query"',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _textPrimary),
            ),
          ),

        const SizedBox(height: 8),

        Expanded(
          child: restaurants.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: restaurants.length,
                  separatorBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Colors.grey.shade200, height: 1),
                  ),
                  itemBuilder: (context, index) {
                    final r = restaurants[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RestaurantMenuScreen(
                              restaurant: VendorRestaurant(
                                id: 'extracted',
                                name: r['name'],
                                categories: r['categories'],
                                rating: r['rating'],
                                time: r['time'],
                                distance: r['distance'],
                                totalSells: r['totalSells'],
                                imagePath: r['image'],
                                menu: List<Map<String, dynamic>>.from(r['menu']),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 100, height: 100,
                              color: Colors.grey.shade100,
                              child: Image.asset(r['image'], fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 40))),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(r['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ),
                                    if (r['isVeg'] == true)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.green.shade300)),
                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                          Icon(Icons.eco_rounded, size: 10, color: Colors.green.shade600),
                                          const SizedBox(width: 3),
                                          Text('Veg', style: TextStyle(color: Colors.green.shade700, fontSize: 9, fontWeight: FontWeight.w800)),
                                        ]),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(r['categories'], style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 8),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Icon(Icons.star, color: Colors.orange, size: 14),
                                    const SizedBox(width: 4),
                                    Text(r['rating'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey)),
                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: Colors.grey, fontSize: 10))),
                                    Text(r['time'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                                    const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: Colors.grey, fontSize: 10))),
                                    Text(r['distance'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                      child: Text('📈 ${r['totalSells']}', style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: _themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                      child: Text('View Menu', style: TextStyle(color: _themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
            child: const Icon(Icons.restaurant_outlined, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            "No restaurants found for '$_query'",
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
                  color: const Color(0xFFE53935).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE53935)),
                ),
                child: const Text('Clear All Filters', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}