import 'dart:async';
import 'package:flutter/material.dart';
import 'app_models.dart';

class RestaurantTab extends StatefulWidget {
  const RestaurantTab({super.key});
  @override
  State<RestaurantTab> createState() => _RestaurantTabState();
}

class _RestaurantTabState extends State<RestaurantTab> {
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  final Color _textColor = const Color(0xFF1A1A1A);
  final Color _gridItemBgColor = const Color(0xFFF0F0F0);
  final Color _borderColor = Colors.grey.withOpacity(0.15);

  final List<BannerData> _banners = const [
    BannerData(
      'Flat 50% offer',
      'On your first 3 orders',
      kRestaurantRed,
      'assets/images/broccoli.png',
    ),
    BannerData(
      'Spicy Deals',
      'Best biryanis in town',
      Colors.orange,
      'assets/images/broccoli.png',
    ),
    BannerData(
      'Midnight Cravings',
      'Open till 3 AM',
      Color(0xFF673AB7),
      'assets/images/broccoli.png',
    ),
  ];

  final List<SpotlightItem> _spotlights = [
    SpotlightItem(
      'Biryani &\nPulao',
      'assets/images/broccoli.png',
      Color(0xFFFFCDD2),
      Color(0xFFB71C1C),
    ),
    SpotlightItem(
      'Pizzas &\nBurgers',
      'assets/images/broccoli.png',
      Color(0xFFFFF9C4),
      Color(0xFFE65100),
    ),
    SpotlightItem(
      'Thalis &\nMeals',
      'assets/images/broccoli.png',
      Color(0xFFE0F2F1),
      Color(0xFF004D40),
    ),
    SpotlightItem(
      'Noodles &\nMomos',
      'assets/images/broccoli.png',
      Color(0xFFDCEDC8),
      Color(0xFF1B5E20),
    ),
    SpotlightItem(
      'Desserts &\nIce Cream',
      'assets/images/broccoli.png',
      Color(0xFFE1BEE7),
      Color(0xFF4A148C),
    ),
  ];

  final List<GridSectionData> _grids = const [
    GridSectionData('Top Cuisines', [
      CategoryItem('North Indian', 'assets/images/broccoli.png'),
      CategoryItem('South Indian', 'assets/images/broccoli.png'),
      CategoryItem('Chinese', 'assets/images/broccoli.png'),
      CategoryItem('Italian', 'assets/images/broccoli.png'),
      CategoryItem('Mexican', 'assets/images/broccoli.png'),
      CategoryItem('Thai Food', 'assets/images/broccoli.png'),
      CategoryItem('Continental', 'assets/images/broccoli.png'),
      CategoryItem('Beverages', 'assets/images/broccoli.png'),
    ]),
    GridSectionData('Quick Bites', [
      CategoryItem('Burgers', 'assets/images/broccoli.png'),
      CategoryItem('Pizzas', 'assets/images/broccoli.png'),
      CategoryItem('Rolls', 'assets/images/broccoli.png'),
      CategoryItem('Momos', 'assets/images/broccoli.png'),
      CategoryItem('Sandwiches', 'assets/images/broccoli.png'),
      CategoryItem('Street Food', 'assets/images/broccoli.png'),
      CategoryItem('Samosas', 'assets/images/broccoli.png'),
      CategoryItem('French Fries', 'assets/images/broccoli.png'),
    ]),
    GridSectionData('Sweet Tooth', [
      CategoryItem('Cakes', 'assets/images/broccoli.png'),
      CategoryItem('Pastries', 'assets/images/broccoli.png'),
      CategoryItem('Ice Cream', 'assets/images/broccoli.png'),
      CategoryItem('Waffles', 'assets/images/broccoli.png'),
    ]),
  ];

  final List<StoreItem> _stores = const [
    StoreItem('Local\nFavs', 'assets/images/broccoli.png', Color(0xFFFFCDD2)),
    StoreItem(
      'Premium\nDining',
      'assets/images/broccoli.png',
      Color(0xFFFFF9C4),
    ),
    StoreItem('Healthy\nEats', 'assets/images/broccoli.png', Color(0xFFB2EBF2)),
    StoreItem(
      'Pocket\nFriendly',
      'assets/images/broccoli.png',
      Color(0xFFDCEDC8),
    ),
    StoreItem('Bakery\nFresh', 'assets/images/broccoli.png', Color(0xFFF8BBD0)),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (t) {
      if (_bannerController.hasClients) {
        _bannerIndex = (_bannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          _bannerIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
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
    return ScrollConfiguration(
      behavior: NoJellyScrollBehavior(),
      child: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        color: kRestaurantRed,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildBanners(),
              const SizedBox(height: 25),
              _buildHeader('Now Spotlight', true, kRestaurantRed),
              const SizedBox(height: 14),
              _buildSpotlights(),
              const SizedBox(height: 30),
              ..._buildGridSections(kRestaurantRed),
              _buildHeader('Explore Stores', true, kRestaurantRed),
              const SizedBox(height: 16),
              _buildStores(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanners() {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: _banners.length,
        itemBuilder: (ctx, i) {
          final b = _banners[i];
          final color = b.isLightBanner ? Colors.black : Colors.white;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: b.bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          b.title,
                          style: TextStyle(
                            color: color,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          b.subtitle,
                          style: TextStyle(
                            color: color.withOpacity(0.7),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: kRestaurantRed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Order Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 2, child: Image.asset(b.imagePath)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpotlights() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _spotlights.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final item = _spotlights[i];
          return Container(
            width: 110,
            decoration: BoxDecoration(
              color: item.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: item.textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: Image.asset(item.imagePath, height: 75),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildGridSections(Color themeColor) {
    return _grids
        .map(
          (section) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(
                section.title,
                section.items.length >= 4,
                themeColor,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: section.items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (ctx, i) {
                    final c = section.items[i];
                    return Column(
                      children: [
                        Container(
                          height: 75,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _gridItemBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _borderColor),
                          ),
                          child: Center(
                            child: Image.asset(c.imagePath, height: 45),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          c.label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        )
        .toList();
  }

  Widget _buildStores() {
    return SizedBox(
      height: 155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, i) {
          final item = _stores[i];
          return SizedBox(
            width: 90,
            child: Column(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(45),
                      bottom: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(item.imagePath, height: 60),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String title, bool showSeeAll, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _textColor,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (showSeeAll)
            Text(
              'See all',
              style: TextStyle(
                color: themeColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
