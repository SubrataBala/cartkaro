import 'dart:async';
import 'package:flutter/material.dart';
import 'app_models.dart';

// Removes the stretch/glow effect globally for this page
class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class GroceryTab extends StatefulWidget {
  const GroceryTab({super.key});
  @override
  State<GroceryTab> createState() => _GroceryTabState();
}

class _GroceryTabState extends State<GroceryTab> {
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  // Styling Constants (Dark theme style for Grocery)
  final Color _textColor = Colors.white;
  final Color _gridItemBgColor = const Color(0xFF1E1E1E);
  final Color _borderColor = Colors.white.withOpacity(0.05);

  // --- DATA LISTS (Easy to update) ---

  final List<BannerData> _banners = const [
    BannerData('Up to 30% offer', 'Enjoy our big offer', Color(0xFFD7FFD9), 'assets/images/broccoli.png', isLightBanner: true),
    BannerData('Daily Essentials', 'Get milk & bread fast', Color(0xFFFFF0C2), 'assets/images/broccoli.png', isLightBanner: true),
    BannerData('Super Saver Pack', 'Monthly groceries', Color(0xFFFFD1D1), 'assets/images/broccoli.png', isLightBanner: true),
  ];

  final List<SpotlightItem> _spotlights = [
    SpotlightItem('Fruits &\nVegetables', 'assets/images/broccoli.png', const Color(0xFFFCAEAE), const Color(0xFFD32F2F)),
    SpotlightItem('Dairy Bread\n& Eggs', 'assets/images/broccoli.png', const Color(0xFFFFF59D), const Color(0xFFF57F17)),
    SpotlightItem('Meat &\nSeafood', 'assets/images/broccoli.png', const Color(0xFFFFCCBC), const Color(0xFFBF360C)),
    SpotlightItem('Munchies &\nCold Drinks', 'assets/images/broccoli.png', const Color(0xFFC5E1A5), const Color(0xFF33691E)),
    SpotlightItem('Cooking\nEssentials', 'assets/images/broccoli.png', const Color(0xFFA5D6A7), const Color(0xFF1B5E20)),
  ];

  final List<GridSectionData> _grids = const [
    GridSectionData('Grocery & Kitchen', [
      CategoryItem('Vegetables\n& Fruits', 'assets/images/broccoli.png'),
      CategoryItem('Atta, Rice\n& Dal', 'assets/images/broccoli.png'),
      CategoryItem('Oil, Ghee\n& Masala', 'assets/images/broccoli.png'),
      CategoryItem('Dairy, Milk\n& Bread', 'assets/images/broccoli.png'),
      CategoryItem('Dry Fruits\n& Seeds', 'assets/images/broccoli.png'),
      CategoryItem('Organic\nGrains', 'assets/images/broccoli.png'),
      CategoryItem('Spices &\nHerbs', 'assets/images/broccoli.png'),
      CategoryItem('Bakery\nItems', 'assets/images/broccoli.png'),
    ]),
    // New Section added in between
    GridSectionData('Household & Pet Care', [
      CategoryItem('Cleaning\nEssentials', 'assets/images/broccoli.png'),
      CategoryItem('Pooja\nNeeds', 'assets/images/broccoli.png'),
      CategoryItem('Pet Food\n& Toys', 'assets/images/broccoli.png'),
      CategoryItem('Home &\nKitchen', 'assets/images/broccoli.png'),
    ]),
    GridSectionData('Snacks & Drinks', [
      CategoryItem('Chips &\nNamkeen', 'assets/images/broccoli.png'),
      CategoryItem('Sweets &\nChocolate', 'assets/images/broccoli.png'),
      CategoryItem('Drinks &\nJuices', 'assets/images/broccoli.png'),
      CategoryItem('Tea,\nCoffee', 'assets/images/broccoli.png'),
      CategoryItem('Frozen\nSnacks', 'assets/images/broccoli.png'),
      CategoryItem('Biscuits &\nCookies', 'assets/images/broccoli.png'),
      CategoryItem('Breakfast\nCereals', 'assets/images/broccoli.png'),
      CategoryItem('Ice Cream\n& Curd', 'assets/images/broccoli.png'),
    ]),
  ];

  final List<StoreItem> _stores = const [
    StoreItem('Winter\nStore', 'assets/images/broccoli.png', Color(0xFFBBDEFB)),
    StoreItem('Gourmet\nStore', 'assets/images/broccoli.png', Color(0xFFFFCCBC)),
    StoreItem('Health\nStore', 'assets/images/broccoli.png', Color(0xFFE1BEE7)),
    StoreItem('Travel\nStore', 'assets/images/broccoli.png', Color(0xFFF0F4C3)),
    StoreItem('Puja\nStore', 'assets/images/broccoli.png', Color(0xFFFFCDD2)),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients) {
        _bannerIndex = (_bannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(_bannerIndex,
            duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      }
    });
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoJellyScrollBehavior(),
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: kGroceryGreen,
        backgroundColor: const Color(0xFF2C2C2C),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildBanners(),
              const SizedBox(height: 28),
              _buildHeader('Now Spotlight', true),
              const SizedBox(height: 16),
              _buildSpotlights(),
              const SizedBox(height: 32),
              // Dynamic Grid Sections
              ..._buildGridSections(),
              _buildHeader('Explore Stores', true),
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
      height: 180,
      child: PageView.builder(
        controller: _bannerController,
        onPageChanged: (i) => _bannerIndex = i,
        itemCount: _banners.length,
        itemBuilder: (ctx, i) {
          final b = _banners[i];
          final color = b.isLightBanner ? Colors.black : Colors.white;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(color: b.bgColor, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.fromLTRB(20, 25, 10, 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(b.title, maxLines: 2, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800, height: 1.1)),
                        const SizedBox(height: 6),
                        Text(b.subtitle, maxLines: 1, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(color: kGroceryGreen, borderRadius: BorderRadius.circular(8)),
                          child: const Text('Shop Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 3, child: Image.asset(b.imagePath, fit: BoxFit.contain)),
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
      height: 165,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _spotlights.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, i) {
          final item = _spotlights[i];
          return Container(
            width: 115,
            decoration: BoxDecoration(color: item.bgColor, borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FEATURED', style: TextStyle(color: item.textColor.withOpacity(0.6), fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      Text(item.title, style: TextStyle(color: item.textColor, fontSize: 11, fontWeight: FontWeight.w800, height: 1.2)),
                    ],
                  ),
                ),
                Positioned(bottom: -10, right: -10, child: Image.asset(item.imagePath, height: 90, width: 90, fit: BoxFit.contain)),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildGridSections() {
    return _grids.map((section) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(section.title, section.items.length >= 4),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: section.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.60,
              ),
              itemBuilder: (ctx, i) {
                final c = section.items[i];
                return Column(
                  children: [
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _gridItemBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _borderColor),
                      ),
                      child: Center(child: Image.asset(c.imagePath, fit: BoxFit.contain)),
                    ),
                    const SizedBox(height: 6),
                    Text(c.label, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(color: _textColor, fontSize: 10, fontWeight: FontWeight.w700, height: 1.3)),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 28),
        ],
      );
    }).toList();
  }

  Widget _buildStores() {
    return SizedBox(
      height: 165,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final item = _stores[i];
          return SizedBox(
            width: 95,
            child: Column(
              children: [
                Container(
                  height: 110,
                  width: 95,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(50), bottom: Radius.circular(16)),
                  ),
                  child: Align(alignment: Alignment.bottomCenter, child: Image.asset(item.imagePath, height: 65)),
                ),
                const SizedBox(height: 10),
                Text(item.label, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(color: _textColor, fontSize: 11, fontWeight: FontWeight.w700, height: 1.2)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String title, bool showSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.w800)),
          if (showSeeAll)
            InkWell(
              onTap: () {},
              child: const Text('See all', style: TextStyle(color: kGroceryGreen, fontSize: 13, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}