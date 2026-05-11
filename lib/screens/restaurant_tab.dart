import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_models.dart';
import 'items_screen.dart'; // ── INCLUDES 'CartAddButton' ──

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
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
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
  int _activeCategoryIndex = 0;

  bool _isPureVeg = false;
  bool _isNonVeg = false;
  String _activeFilter = '';

  final List<String> _filters = [
    'Near & Fast', 'New Arrivals', 'No Packaging Charge', 'Under ₹200', 'Rating 4.0+',
  ];

  final List<_BannerModel> _banners = const [
    _BannerModel(
      codeLabel: 'FIRST50', topText: 'Use code FIRST50 at checkout.', title: 'Get 50% Off\nYour First Order!',
      cta: 'Order Now', bgColor: Color(0xFFFF6B35), imagePath: 'assets/images/broccoli.png', 
    ),
    _BannerModel(
      codeLabel: 'BIRYANI30', topText: 'Use code BIRYANI30 at checkout.', title: 'Biryani Fest\nIs Back!',
      cta: 'Explore Now', bgColor: Color(0xFFB71C1C), imagePath: 'assets/images/broccoli.png',
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

  // ── MAIN FIX: IDs exactly matched with restaurant_data.dart ──
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

  final List<_RestaurantModel> _restaurants = const [
    _RestaurantModel(
      id: 'res1', name: "Rock N' Roll Subs.", categories: "Desserts, Beverages",
      rating: "4.6", time: "30-45 Mins", costForTwo: "₹40 for two", offerText: "15% off on all items", imagePath: 'assets/images/broccoli.png',
    ),
    _RestaurantModel(
      id: 'res2', name: "Sandwich All-the-Way.", categories: "Snacks, Salads, American, Fast Food",
      rating: "4.6", time: "30-45 Mins", costForTwo: "₹40 for two", offerText: "", imagePath: 'assets/images/broccoli.png',
    ),
    _RestaurantModel(
      id: 'res3', name: "Smokin' Burger", categories: "Fast Food",
      rating: "4.6", time: "30-45 Mins", costForTwo: "₹40 for two", offerText: "10% off on all items", imagePath: 'assets/images/broccoli.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (_bannerController.hasClients) {
        _bannerIndex = (_bannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          _bannerIndex, duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgPage,
      body: ScrollConfiguration(
        behavior: _NoJellyScrollBehavior(),
        child: RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
          color: kRestaurantRed,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildHeroBanner(),
                const SizedBox(height: 16),
                _buildDietaryToggles(), 
                const SizedBox(height: 12),
                _buildFiltersRow(),     
                const SizedBox(height: 24),
                _buildCategoryIcons(),  
                const SizedBox(height: 30),
                
                _buildSectionHeader('Top picks for you™', showSeeAll: true),
                const SizedBox(height: 14),
                _buildHorizontalFoodList(_topPicks), 
                const SizedBox(height: 30),

                _buildSectionHeader('Trending / Best Selling Foods', showSeeAll: true),
                const SizedBox(height: 14),
                _buildHorizontalFoodList(_trendingFoods), 
                const SizedBox(height: 35),

                _buildNearestRestaurantsHeader(),
                const SizedBox(height: 16),
                _buildRestaurantList(),

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
                    color: b.bgColor, borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: b.bgColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Positioned(right: -40, top: -40, child: CircleAvatar(radius: 90, backgroundColor: Colors.white.withOpacity(0.05))),
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
              duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _bannerIndex ? 20 : 6, height: 6,
              decoration: BoxDecoration(color: i == _bannerIndex ? kRestaurantRed : Colors.grey.shade300, borderRadius: BorderRadius.circular(3)),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDietaryToggles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildSwitchTile(
            label: 'Pure Veg', iconColor: Colors.green, value: _isPureVeg,
            onChanged: (val) => setState(() { _isPureVeg = val; if (val) _isNonVeg = false; }),
          ),
          const SizedBox(width: 12),
          _buildSwitchTile(
            label: 'Non-Veg', iconColor: Colors.red, value: _isNonVeg,
            onChanged: (val) => setState(() { _isNonVeg = val; if (val) _isPureVeg = false; }),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({required String label, required Color iconColor, required bool value, required Function(bool) onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value ? iconColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: value ? iconColor : kBorderLight, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 12, height: 12,
              decoration: BoxDecoration(border: Border.all(color: iconColor, width: 1.5), borderRadius: BorderRadius.circular(2)),
              child: Center(child: Container(width: 6, height: 6, decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle))),
            ),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: value ? iconColor : kTextDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12), margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: kBorderLight)),
            child: const Row(
              children: [
                Icon(Icons.tune_rounded, size: 16, color: kTextDark), SizedBox(width: 6),
                Text('Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kTextDark)),
                Icon(Icons.arrow_drop_down, size: 18, color: kTextDark),
              ],
            ),
          ),
          ..._filters.map((filter) {
            final isSelected = _activeFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _activeFilter = isSelected ? '' : filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 14), margin: const EdgeInsets.only(right: 8), alignment: Alignment.center,
                decoration: BoxDecoration(color: isSelected ? kTextDark : Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: isSelected ? kTextDark : kBorderLight)),
                child: Text(filter, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600, color: isSelected ? Colors.white : kTextMedium)),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length, separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final c = _categories[i];
          final isActive = i == _activeCategoryIndex;
          return GestureDetector(
            onTap: () => setState(() => _activeCategoryIndex = i),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200), width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: isActive ? kRestaurantRed.withOpacity(0.1) : Colors.white, borderRadius: BorderRadius.circular(20), 
                    border: Border.all(color: isActive ? kRestaurantRed : Colors.transparent, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 5, offset: const Offset(0, 2))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(c.imagePath, fit: BoxFit.cover, errorBuilder: (ctx, err, stack) => const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 28))),
                  ),
                ),
                const SizedBox(height: 8),
                Text(c.label, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w800 : FontWeight.w600, color: isActive ? kRestaurantRed : kTextDark)),
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
              decoration: BoxDecoration(color: kRestaurantRed.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: const Text('See all', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kRestaurantRed)),
            ),
        ],
      ),
    );
  }

  Widget _buildHorizontalFoodList(List<_FoodCardModel> items) {
    return SizedBox(
      height: 275,
      child: ListView.separated(
        scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length, separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, i) => _buildFoodCard(items[i]),
      ),
    );
  }

  Widget _buildFoodCard(_FoodCardModel f) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: kBorderLight, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Container(
                  height: 135, width: double.infinity, color: Colors.grey.shade100, 
                  child: Image.asset(f.imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 40))),
                ),
              ),
              Positioned(
                top: 10, right: 10,
                child: ValueListenableBuilder<Set<String>>(
                  valueListenable: watchlistNotifier,
                  builder: (context, favorites, _) {
                    bool isWatchlisted = favorites.contains(f.id);
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        final newFavs = Set<String>.from(favorites);
                        if (isWatchlisted) newFavs.remove(f.id); else newFavs.add(f.id);
                        watchlistNotifier.value = newFavs; 
                      }, 
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300), padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)]),
                        child: Icon(isWatchlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 18, color: isWatchlisted ? kRestaurantRed : kTextDark),
                      ),
                    );
                  }
                ),
              ),
              Positioned(
                bottom: 10, left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: Colors.white, size: 12), const SizedBox(width: 4),
                      Text(f.deliveryTime, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              if (f.isBestseller)
                Positioned(
                  top: 10, left: 10,
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
                      width: 14, height: 14, decoration: BoxDecoration(border: Border.all(color: f.isVeg ? Colors.green : Colors.red, width: 1.5)),
                      child: Center(child: Container(width: 6, height: 6, decoration: BoxDecoration(color: f.isVeg ? Colors.green : Colors.red, shape: BoxShape.circle))),
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: Text(f.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kTextDark), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 14), const SizedBox(width: 4),
                    Text('${f.rating} (${f.reviews})', style: const TextStyle(fontSize: 11, color: kTextMedium, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${f.price}', style: const TextStyle(color: kTextDark, fontSize: 16, fontWeight: FontWeight.w900)),
                    // ── MAIN FIX: cartItemId with "|0" to sync exactly like ItemsScreen ──
                    CartAddButton(itemId: "${f.id}|0", themeColor: kRestaurantRed, cartNotifier: restaurantCartNotifier),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearestRestaurantsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('All Restaurants Nearby', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kTextDark, letterSpacing: -0.3)),
              SizedBox(height: 2),
              Text('Discover unique tastes near you', style: TextStyle(fontSize: 13, color: kTextGrey, fontWeight: FontWeight.w500)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: kTextDark, width: 1)),
            child: Row(
              children: const [
                Icon(Icons.tune_rounded, size: 14, color: kTextDark),
                SizedBox(width: 4),
                Text('Sort/Filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kTextDark)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRestaurantList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _restaurants.length,
      separatorBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Divider(color: Colors.grey.shade200, height: 1),
      ),
      itemBuilder: (ctx, i) {
        final r = _restaurants[i];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 100, height: 100, color: Colors.grey.shade100,
                child: Image.asset(r.imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.fastfood, color: Colors.grey, size: 40))),
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
                  Row(
                    children: [
                      const Icon(Icons.star, color: kTextMedium, size: 14),
                      const SizedBox(width: 4),
                      Text(r.rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kTextMedium)),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: kTextGrey, fontSize: 10))),
                      Text(r.time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextMedium)),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('•', style: TextStyle(color: kTextGrey, fontSize: 10))),
                      Text(r.costForTwo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kTextMedium)),
                    ],
                  ),
                  if (r.offerText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(r.offerText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.red.shade300)),
                  ]
                ],
              ),
            )
          ],
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
    required this.codeLabel, required this.topText, required this.title,
    required this.cta, required this.bgColor, required this.imagePath,
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
    required this.id, required this.name, required this.restaurant, required this.rating,
    required this.reviews, required this.deliveryTime, required this.deliveryFee,
    required this.price, required this.imagePath, required this.isVeg, required this.isBestseller,
  });
}

class _RestaurantModel {
  final String id, name, categories, rating, time, costForTwo, offerText, imagePath;
  const _RestaurantModel({
    required this.id, required this.name, required this.categories, required this.rating,
    required this.time, required this.costForTwo, required this.offerText, required this.imagePath,
  });
}