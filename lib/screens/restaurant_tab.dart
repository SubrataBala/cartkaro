import 'dart:async';
import 'package:flutter/material.dart';
import 'app_models.dart';
import '../widgets/shared_card_widgets.dart';
import '../screens/restaurant_item_details_screen.dart'; // ← ADD THIS IMPORT
import 'restaurant_menu_screen.dart';
import '../widgets/shared_filter_row.dart';

// ─── CONSTANTS ────────────────────────────────────────────────────────────────
const Color kRestaurantOrange = Color(0xFFFF6B35);
const Color kDarkIcon = Color(0xFF1C1C1E);
const Color kBgPage = Color(0xFFFFFFFF);
const Color kTextDark = Color(0xFF1A1A1A);
const Color kTextGrey = Color(0xFF9E9E9E);
const Color kTextMedium = Color(0xFF616161);
const Color kBorderLight = Color(0xFFEEEEEE);

class _NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}

// ─── RESTAURANT TAB ───────────────────────────────────────────────────────────
class RestaurantTab extends StatefulWidget {
  const RestaurantTab({super.key});
  @override
  State<RestaurantTab> createState() => _RestaurantTabState();
}

class _RestaurantTabState extends State<RestaurantTab> {
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  int _activeCategoryIndex = -1;

  FilterState _filterState = FilterState();

  final List<_BannerModel> _banners = const [
    _BannerModel(
      codeLabel: 'FIRST50',
      topText: 'Use code FIRST50 at checkout.',
      title: 'Get 50% Off\nYour First Order!',
      cta: 'Order Now',
      bgColor: Color(0xFFFF6B35),
      imagePath: 'assets/images/broccoli.png',
    ),
    _BannerModel(
      codeLabel: 'BIRYANI30',
      topText: 'Use code BIRYANI30 at checkout.',
      title: 'Biryani Fest\nIs Back!',
      cta: 'Explore Now',
      bgColor: Color(0xFFB71C1C),
      imagePath: 'assets/images/broccoli.png',
    ),
  ];

  final List<_CategoryIconModel> _categories = const [
    _CategoryIconModel('Burger', 'assets/images/burger.png'),
    _CategoryIconModel('Pizza', 'assets/images/pizza.png'),
    _CategoryIconModel('Salad', 'assets/images/salad.png'),
    _CategoryIconModel('Sushi', 'assets/images/sushi.png'),
    _CategoryIconModel('Momos', 'assets/images/momos.png'),
    _CategoryIconModel('Biryani', 'assets/images/biryani.png'),
  ];

  final List<_FoodCardModel> _topPicks = const [
    _FoodCardModel(id: 'r1', name: 'Chicken Dum Biryani', restaurant: 'Biryani Blues', rating: '4.7', reviews: '2.1k+', deliveryTime: '28 min', deliveryFee: 'Free Delivery', price: '160', imagePath: 'assets/images/broccoli.png', isVeg: false, isBestseller: true),
    _FoodCardModel(id: 'r2', name: 'Farmhouse Veg Pizza', restaurant: 'Pizza Hub', rating: '4.5', reviews: '890+', deliveryTime: '22 min', deliveryFee: 'Free Delivery', price: '199', imagePath: 'assets/images/broccoli.png', isVeg: true, isBestseller: false),
    _FoodCardModel(id: 'r3', name: 'Veg Steam Momos', restaurant: 'Momo Corner', rating: '4.6', reviews: '3.4k+', deliveryTime: '18 min', deliveryFee: 'Free Delivery', price: '80', imagePath: 'assets/images/broccoli.png', isVeg: true, isBestseller: true),
  ];

  final List<_FoodCardModel> _trendingFoods = const [
    _FoodCardModel(id: 'r4', name: 'Zinger Chicken Burger', restaurant: 'Burger King', rating: '4.4', reviews: '5k+', deliveryTime: '15 min', deliveryFee: '₹20 Delivery', price: '149', imagePath: 'assets/images/broccoli.png', isVeg: false, isBestseller: true),
    _FoodCardModel(id: 'r5', name: 'Veg Hakka Noodles', restaurant: 'Chowman', rating: '4.2', reviews: '1.2k+', deliveryTime: '30 min', deliveryFee: 'Free Delivery', price: '90', imagePath: 'assets/images/broccoli.png', isVeg: true, isBestseller: false),
    _FoodCardModel(id: 'r6', name: 'Classic Cold Coffee', restaurant: 'Cafe Coffee Day', rating: '4.6', reviews: '2k+', deliveryTime: '20 min', deliveryFee: 'Free Delivery', price: '120', imagePath: 'assets/images/broccoli.png', isVeg: true, isBestseller: true),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (_bannerController.hasClients) {
        _bannerIndex = (_bannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          _bannerIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  // ── convert _FoodCardModel → Map<String,dynamic> ──────────────────────────
  // This is the bridge between the tab's local model and the details screen.
  // Matches the exact keys used in restaurant_data.dart so the details screen
  // reads all fields correctly (name, price, rating, time, image, etc.).
  Map<String, dynamic> _foodCardToMap(_FoodCardModel f) {
    return {
      'id': f.id,
      'name': f.name,
      'restaurant': f.restaurant,
      'brand': f.restaurant,
      'image': f.imagePath,
      'rating': f.rating,
      'time': f.deliveryTime,
      'deliveryTime': f.deliveryTime,
      'deliveryFee': f.deliveryFee,
      'totalSells': f.reviews,
      'isVeg': f.isVeg,
      'price': double.tryParse(f.price) ?? 0.0,
      'isBestseller': f.isBestseller,
      'variants': [
        {'weight': 'Standard', 'price': double.tryParse(f.price) ?? 0.0},
      ],
    };
  }

  List<VendorRestaurant> _getFilteredRestaurants() {
    List<VendorRestaurant> results = List.from(globalRestaurants);

    if (_filterState.vegFilter == 'veg') {
      results = results.where((r) => r.menu.isNotEmpty && r.menu.every((item) => item['isVeg'] == true)).toList();
    } else if (_filterState.vegFilter == 'non_veg') {
      results = results.where((r) => r.menu.isNotEmpty && r.menu.any((item) => item['isVeg'] == false)).toList();
    }

    if (_activeCategoryIndex != -1) {
      final categoryLabel = _categories[_activeCategoryIndex].label.toLowerCase();
      results = results.where((r) {
        return r.categories.toLowerCase().contains(categoryLabel) ||
            r.name.toLowerCase().contains(categoryLabel);
      }).toList();
    }

    switch (_filterState.sortBy) {
      case 'rating':
        results.sort((a, b) {
          final cleanA = a.rating.replaceAll(RegExp(r'[^0-9.]'), '');
          final cleanB = b.rating.replaceAll(RegExp(r'[^0-9.]'), '');
          return (double.tryParse(cleanB) ?? 0).compareTo(double.tryParse(cleanA) ?? 0);
        });
        break;
      case 'popular':
        results.sort((a, b) => _parseSells(b.totalSells).compareTo(_parseSells(a.totalSells)));
        break;
      case 'low_to_high':
        results.sort((a, b) => _getMinPrice(a.menu).compareTo(_getMinPrice(b.menu)));
        break;
      case 'high_to_low':
        results.sort((a, b) => _getMinPrice(b.menu).compareTo(_getMinPrice(a.menu)));
        break;
    }

    if (_filterState.distanceFilter != 'all') {
      final maxKm = double.tryParse(_filterState.distanceFilter.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 100;
      results = results.where((r) {
        return (double.tryParse(r.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0) <= maxKm;
      }).toList();
    }

    if (_filterState.minRating > 0) {
      results = results.where((r) {
        return (double.tryParse(r.rating.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0) >= _filterState.minRating;
      }).toList();
    }

    return results;
  }

  List<_FoodCardModel> _getFilteredFoods(List<_FoodCardModel> sourceList) {
    List<_FoodCardModel> results = List.from(sourceList);

    if (_filterState.vegFilter == 'veg') {
      results = results.where((f) => f.isVeg == true).toList();
    } else if (_filterState.vegFilter == 'non_veg') {
      results = results.where((f) => f.isVeg == false).toList();
    }

    if (_activeCategoryIndex != -1) {
      final categoryLabel = _categories[_activeCategoryIndex].label.toLowerCase();
      results = results.where((f) => f.name.toLowerCase().contains(categoryLabel)).toList();
    }

    if (_filterState.minRating > 0) {
      results = results.where((f) {
        final rating = double.tryParse(f.rating.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        return rating >= _filterState.minRating;
      }).toList();
    }

    switch (_filterState.sortBy) {
      case 'rating':
        results.sort((a, b) {
          final rA = double.tryParse(a.rating.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          final rB = double.tryParse(b.rating.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          return rB.compareTo(rA);
        });
        break;
      case 'low_to_high':
        results.sort((a, b) {
          final pA = double.tryParse(a.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          final pB = double.tryParse(b.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          return pA.compareTo(pB);
        });
        break;
      case 'high_to_low':
        results.sort((a, b) {
          final pA = double.tryParse(a.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          final pB = double.tryParse(b.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          return pB.compareTo(pA);
        });
        break;
      case 'popular':
        results.sort((a, b) {
          final rA = _parseSells(a.reviews);
          final rB = _parseSells(b.reviews);
          return rB.compareTo(rA);
        });
        break;
    }

    return results;
  }

  double _parseSells(String sells) {
    sells = sells.toLowerCase().replaceAll('+', '').replaceAll(' orders', '').trim();
    if (sells.endsWith('k')) return (double.tryParse(sells.replaceAll('k', '')) ?? 0) * 1000;
    if (sells.endsWith('m')) return (double.tryParse(sells.replaceAll('m', '')) ?? 0) * 1000000;
    return double.tryParse(sells) ?? 0;
  }

  double _getMinPrice(List<Map<String, dynamic>> menu) {
    if (menu.isEmpty) return 0;
    double min = double.infinity;
    for (var item in menu) {
      final price = (item['price'] as num? ?? 0).toDouble();
      if (price < min) min = price;
    }
    return min == double.infinity ? 0 : min;
  }

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = _getFilteredRestaurants();
    final filteredTopPicks = _getFilteredFoods(_topPicks);
    final filteredTrending = _getFilteredFoods(_trendingFoods);

    return Scaffold(
      backgroundColor: kBgPage,
      body: ScrollConfiguration(
        behavior: _NoJellyScrollBehavior(),
        child: RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
          color: Colors.red,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildHeroBanner(),
                const SizedBox(height: 16),
                SharedFilterRow(
                  tabIndex: 1,
                  filterState: _filterState,
                  searchResults: const [],
                  onFilterChanged: (newState) {
                    setState(() {
                      _filterState = newState;
                    });
                  },
                ),
                const SizedBox(height: 24),
                _buildCategoryIcons(),
                const SizedBox(height: 30),
                if (filteredTopPicks.isNotEmpty) ...[
                  _buildSectionHeader('Top picks for you™', showSeeAll: true),
                  const SizedBox(height: 14),
                  _buildHorizontalFoodList(filteredTopPicks),
                  const SizedBox(height: 30),
                ],
                if (filteredTrending.isNotEmpty) ...[
                  _buildSectionHeader('Trending / Best Selling Foods', showSeeAll: true),
                  const SizedBox(height: 14),
                  _buildHorizontalFoodList(filteredTrending),
                  const SizedBox(height: 35),
                ],
                _buildNearestRestaurantsHeader(filteredRestaurants.length),
                const SizedBox(height: 16),
                _buildRestaurantList(filteredRestaurants),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemBuilder: (ctx, i) {
              final b = _banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: b.bgColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: b.bgColor.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Positioned(right: -40, top: -40, child: CircleAvatar(radius: 90, backgroundColor: Colors.white.withValues(alpha: 0.05))),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(b.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.15)),
                                  const SizedBox(height: 14),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(b.cta, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 12),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(flex: 2, child: Image.asset(b.imagePath, fit: BoxFit.contain)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _bannerIndex ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == _bannerIndex ? Colors.red : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCategoryIcons() {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final c = _categories[i];
          final isActive = i == _activeCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _activeCategoryIndex = isActive ? -1 : i;
              });
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.red.withValues(alpha: 0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isActive ? Colors.red : Colors.transparent, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 5, offset: const Offset(0, 2))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(c.imagePath, fit: BoxFit.contain, errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 28))),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(c.label, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w800 : FontWeight.w600, color: isActive ? Colors.red : kTextDark)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required bool showSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kTextDark, letterSpacing: -0.3)),
          if (showSeeAll)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: const Text('See all', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.red)),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalFoodList(List<_FoodCardModel> items) {
    return SizedBox(
      height: 275,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, i) => _buildFoodCard(items[i]),
      ),
    );
  }

  // ── FOOD CARD — now tappable, navigates to RestaurantItemDetailsScreen ──────
  Widget _buildFoodCard(_FoodCardModel f) {
    return GestureDetector(
      // Convert the local _FoodCardModel to a Map and push details screen
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantItemDetailsScreen(
              item: _foodCardToMap(f),
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kBorderLight, width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Container(
                    height: 135,
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      f.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 40)),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: WatchlistIcon(itemId: f.id, themeColor: Colors.red, isBgWhite: true),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(f.deliveryTime, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                if (f.isBestseller)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFF9800), borderRadius: BorderRadius.circular(6)),
                      child: const Text('🔥 Bestseller', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(border: Border.all(color: f.isVeg ? Colors.green : Colors.red, width: 1.5)),
                        child: Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(color: f.isVeg ? Colors.green : Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(f.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kTextDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 14),
                      const SizedBox(width: 4),
                      Text('${f.rating} (${f.reviews})', style: const TextStyle(fontSize: 11, color: kTextMedium, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${f.price}', style: const TextStyle(color: kTextDark, fontSize: 16, fontWeight: FontWeight.w900)),
                      // Stop tap from bubbling up to GestureDetector when + is pressed
                      GestureDetector(
                        onTap: () {}, // absorb tap so cart button works independently
                        behavior: HitTestBehavior.opaque,
                        child: SharedCartButton(
                          itemId: '${f.id}|0',
                          themeColor: Colors.red,
                          cartNotifier: restaurantCartNotifier,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearestRestaurantsHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('All Restaurants Nearby', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kTextDark, letterSpacing: -0.3)),
              const SizedBox(height: 2),
              Text('Showing $count restaurants', style: const TextStyle(fontSize: 13, color: kTextGrey, fontWeight: FontWeight.w500)),
            ],
          ),
          if (_filterState.hasActiveFilters || _activeCategoryIndex != -1)
            GestureDetector(
              onTap: () => setState(() {
                _filterState = FilterState();
                _activeCategoryIndex = -1;
              }),
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
    );
  }

  Widget _buildRestaurantList(List<VendorRestaurant> restaurants) {
    if (restaurants.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.restaurant_outlined, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              const Text('No restaurants found', style: TextStyle(color: kTextMedium, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Try adjusting your filters', style: TextStyle(color: kTextGrey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: restaurants.length,
      separatorBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Divider(color: Colors.grey.shade200, height: 1),
      ),
      itemBuilder: (ctx, i) {
        final r = restaurants[i];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantMenuScreen(restaurant: r),
              ),
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(r.imagePath, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 40))),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: kTextDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(r.categories, style: const TextStyle(fontSize: 12, color: kTextGrey, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(Icons.star, color: kTextMedium, size: 14),
                        const SizedBox(width: 4),
                        Text(r.rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kTextMedium)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: kTextGrey, fontSize: 10))),
                        Text(r.time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextMedium)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: kTextGrey, fontSize: 10))),
                        Text(r.distance, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextMedium)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text('📈 ${r.totalSells}', style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
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

// ─── DATA MODELS ──────────────────────────────────────────────────────────────
class _BannerModel {
  final String codeLabel, topText, title, cta, imagePath;
  final Color bgColor;
  const _BannerModel({
    required this.codeLabel,
    required this.topText,
    required this.title,
    required this.cta,
    required this.bgColor,
    required this.imagePath,
  });
}

class _CategoryIconModel {
  final String label, imagePath;
  const _CategoryIconModel(this.label, this.imagePath);
}

class _FoodCardModel {
  final String id, name, restaurant, rating, reviews, deliveryTime, deliveryFee, price, imagePath;
  final bool isVeg, isBestseller;
  const _FoodCardModel({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.rating,
    required this.reviews,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.price,
    required this.imagePath,
    required this.isVeg,
    required this.isBestseller,
  });
}