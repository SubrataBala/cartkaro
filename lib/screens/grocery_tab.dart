import 'dart:async';
import 'package:flutter/material.dart';
import 'grocery_data.dart';
import 'items_screen.dart';

class GroceryTab extends StatefulWidget {
  const GroceryTab({super.key});
  @override
  State<GroceryTab> createState() => _GroceryTabState();
}

class _GroceryTabState extends State<GroceryTab> {
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  final Color _textColor = const Color(0xFF1A1A1A);
  final Color _gridItemBgColor = const Color(0xFFEDF6FF);
  final Color _borderColor = Colors.grey.withOpacity(0.15);

  final List<BannerData> _banners = const [
    BannerData(
      'Up to 30% offer',
      'Enjoy our big offer',
      Color(0xFFD7FFD9),
      'assets/images/broccoli.png',
      isLightBanner: true,
    ),
    BannerData(
      'Daily Essentials',
      'Get milk & bread fast',
      Color(0xFFFFF0C2),
      'assets/images/broccoli.png',
      isLightBanner: true,
    ),
    BannerData(
      'Super Saver Pack',
      'Monthly groceries',
      Color(0xFFFFD1D1),
      'assets/images/broccoli.png',
      isLightBanner: true,
    ),
  ];

  final List<SpotlightItem> _spotlights = const [
    SpotlightItem(
      'Fruits &\nVegetables',
      'assets/images/carrot.png',
      Color(0xFFFCAEAE),
      Color(0xFFD32F2F),
    ),
    SpotlightItem(
      'Dairy Bread\n& Eggs',
      'assets/images/eggs.png',
      Color.fromARGB(255, 170, 169, 162),
      Color(0xFFF57F17),
    ),
    SpotlightItem(
      'Meat &\nSeafood',
      'assets/images/fish.png',
      Color(0xFFFFCCBC),
      Color(0xFFBF360C),
    ),
    SpotlightItem(
      'Munchies &\nCold Drinks',
      'assets/images/sprite.png',
      Color(0xFFC5E1A5),
      Color(0xFF33691E),
    ),
    SpotlightItem(
      'Cooking\nEssentials',
      'assets/images/cooker.png',
      Color(0xFFA5D6A7),
      Color(0xFF1B5E20),
    ),
  ];

  final List<GridSectionData> _grids = const [
    GridSectionData('Grocery & Kitchen', [
      CategoryItem('Vegetables', 'assets/images/vegetables.png'),
      CategoryItem('Fruits', 'assets/images/fruit.png'),
      CategoryItem('Grocery', 'assets/images/oil.png'),
      CategoryItem('Dairy, Milk\n& Bread', 'assets/images/braed.png'),
      CategoryItem('Dry Fruits\n& Seeds', 'assets/images/cashew.png'),
      CategoryItem('Bakery\nItems', 'assets/images/cake.png'),
      CategoryItem('Organic\nGrains', 'assets/images/seeds.png'),
      CategoryItem('Spices &\nHerbs', 'assets/images/spices.png'),
    ]),
    GridSectionData('Household & Pet', [
      CategoryItem('Cleaning\nEssentials', 'assets/images/surf.png'),
      CategoryItem('Pooja\nNeeds', 'assets/images/agarbatti.png'),
      CategoryItem('Toys\n& Pet Food', 'assets/images/Toys.png'),
      CategoryItem('Home &\nKitchen', 'assets/images/kitchen.png'),
    ]),
    GridSectionData('Snacks & Drinks', [
      CategoryItem('Snacks & Drinks', 'assets/images/lays.png'),
      CategoryItem('Sweets &\nChocolate', 'assets/images/chocolate.png'),
      CategoryItem('Drinks &\nJuices', 'assets/images/colddrinks.png'),
      CategoryItem('Tea,\nCoffee', 'assets/images/tea.png'),
      CategoryItem('Biscuits &\nCookies', 'assets/images/biscuits.png'),
      CategoryItem('Frozen\nSnacks', 'assets/images/frozen_snaks.png'),
      CategoryItem('Breakfast\nCereals', 'assets/images/chocos.png'),
      CategoryItem('Instant\nFood', 'assets/images/noodles.png'),
    ]),
  ];

  final List<StoreItem> _stores = const [
    StoreItem('Summer\nStore', 'assets/images/summer.png', Color(0xFFBBDEFB)),
    StoreItem('Gourmet\nStore', 'assets/images/gourmet.png', Color(0xFFFFCCBC)),
    StoreItem('Health\nStore', 'assets/images/health.png', Color(0xFFE1BEE7)),
    StoreItem('Travel\nStore', 'assets/images/travel.png', Color(0xFFF0F4C3)),
    StoreItem('Puja\nStore', 'assets/images/puja.png', Color(0xFFFFCDD2)),
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

  void _navigateToCategory(BuildContext context, String rawCategoryName) {
    String cleanName = rawCategoryName.replaceAll('\n', ' ');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ItemsScreen(categoryTitle: cleanName, tabIndex: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoJellyScrollBehavior(),
      child: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        color: Colors.green,
        backgroundColor: const Color(0xFF2C2C2C),
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
              _buildHeader('Now Spotlight', true, Colors.green),
              const SizedBox(height: 14),
              _buildSpotlights(),
              const SizedBox(height: 30),
              ..._buildGridSections(Colors.green),
              _buildHeader('Shop Store', true, Colors.green),
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
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Shop Now',
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
          return GestureDetector(
            onTap: () => _navigateToCategory(context, item.title),
            child: Container(
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
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -5,
                    right: -5,
                    child: Image.asset(item.imagePath, height: 95),
                  ),
                ],
              ),
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
                    return GestureDetector(
                      onTap: () => _navigateToCategory(context, c.label),
                      child: Column(
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
                              child: Image.asset(c.imagePath, height: 65),
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
                      ),
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
          return GestureDetector(
            onTap: () => _navigateToCategory(context, item.label),
            child: SizedBox(
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
                      child: Image.asset(item.imagePath, height: 80),
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
