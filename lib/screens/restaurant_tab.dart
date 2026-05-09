import 'dart:async';
import 'package:flutter/material.dart';
import 'app_models.dart';

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

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
    BannerData('Flat 50% offer', 'On your first 3 orders', kRestaurantRed, 'assets/images/broccoli.png'),
    BannerData('Spicy Deals', 'Best biryanis in town', Colors.orange, 'assets/images/broccoli.png'),
    BannerData('Midnight Cravings', 'Open till 3 AM', Color(0xFF673AB7), 'assets/images/broccoli.png'),
  ];

  final List<SpotlightItem> _spotlights = [
    SpotlightItem('Biryani &\nPulao', 'assets/images/broccoli.png', const Color(0xFFFFCDD2), Colors.red.shade900),
    SpotlightItem('Pizzas &\nBurgers', 'assets/images/broccoli.png', const Color(0xFFFFF9C4), Colors.orange.shade900),
    SpotlightItem('Noodles &\nMomos', 'assets/images/broccoli.png', const Color(0xFFDCEDC8), Colors.green.shade900),
    SpotlightItem('Desserts &\nIce Creams', 'assets/images/broccoli.png', const Color(0xFFE1BEE7), Colors.purple.shade900),
  ];

  final List<GridSectionData> _grids = const [
    GridSectionData('Top Cuisines', [
      CategoryItem('North Indian', 'assets/images/broccoli.png'), CategoryItem('South Indian', 'assets/images/broccoli.png'),
      CategoryItem('Chinese', 'assets/images/broccoli.png'), CategoryItem('Italian', 'assets/images/broccoli.png'),
    ]),
    GridSectionData('Quick Bites', [
      CategoryItem('Burgers', 'assets/images/broccoli.png'), CategoryItem('Pizzas', 'assets/images/broccoli.png'),
      CategoryItem('Rolls', 'assets/images/broccoli.png'), CategoryItem('Momos', 'assets/images/broccoli.png'),
    ]),
  ];

  final List<StoreItem> _stores = const [
    StoreItem('Local\nFavourites', 'assets/images/broccoli.png', Color(0xFFFFCDD2)), 
    StoreItem('Premium\nDining', 'assets/images/broccoli.png', Color(0xFFFFF9C4)),
    StoreItem('Pocket\nFriendly', 'assets/images/broccoli.png', Color(0xFFDCEDC8)),
    StoreItem('Healthy\nEats', 'assets/images/broccoli.png', Color(0xFFB2EBF2)),
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
    _bannerTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_bannerController.hasClients) {
        _bannerController.animateToPage((_bannerIndex + 1) % _banners.length, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    });
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoJellyScrollBehavior(),
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: kRestaurantRed, 
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16), _buildBanners(), const SizedBox(height: 28),
              _buildHeader('Now Spotlight', true), const SizedBox(height: 16), _buildSpotlights(), const SizedBox(height: 32),
              ..._buildGrids(), const SizedBox(height: 10),
              _buildHeader('Shop Store', false), const SizedBox(height: 16), _buildStores(),
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
        controller: _bannerController, onPageChanged: (i) => setState(() => _bannerIndex = i), itemCount: _banners.length,
        itemBuilder: (ctx, i) {
          final b = _banners[i];
          final color = b.isLightBanner ? Colors.black : Colors.white;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(color: b.bgColor, borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.fromLTRB(20, 25, 10, 20),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(b.title, maxLines: 2, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w800, height: 1.1)), const SizedBox(height: 6),
                    Text(b.subtitle, maxLines: 1, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w600)), const SizedBox(height: 16),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), decoration: BoxDecoration(color: kRestaurantRed, borderRadius: BorderRadius.circular(8)), child: const Text('Shop Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                  ])),
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
        itemCount: _spotlights.length, separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, i) {
          final item = _spotlights[i];
          return Container(
            width: 115, decoration: BoxDecoration(color: item.bgColor, borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                Positioned(top: 12, left: 12, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('FEATURED', style: TextStyle(color: item.textColor.withOpacity(0.6), fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.5)), const SizedBox(height: 4), Text(item.title, style: TextStyle(color: item.textColor, fontSize: 11, fontWeight: FontWeight.w800, height: 1.2)),
                ])),
                Positioned(bottom: -10, right: -10, child: Image.asset(item.imagePath, height: 90, width: 90, fit: BoxFit.contain)),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildGrids() {
    return _grids.map((section) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(section.title, section.items.length > 4), const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: section.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 16, crossAxisSpacing: 12, childAspectRatio: 0.60),
            itemBuilder: (ctx, i) {
              final c = section.items[i];
              return Column(
                children: [
                  Container(height: 80, width: double.infinity, padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _gridItemBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)), child: Center(child: Image.asset(c.imagePath, fit: BoxFit.contain))),
                  const SizedBox(height: 6), Text(c.label, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(color: _textColor, fontSize: 10, fontWeight: FontWeight.w700, height: 1.3)),
                ],
              );
            },
          ),
        ), const SizedBox(height: 28),
      ],
    )).toList();
  }

  Widget _buildStores() {
    return SizedBox(
      height: 165,
      child: ListView.separated(
        scrollDirection: Axis.horizontal, 
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _stores.length, separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final item = _stores[i];
          return SizedBox(
            width: 95,
            child: Column(
              children: [
                Container(height: 110, width: 95, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: item.bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(50), bottom: Radius.circular(16))), child: Align(alignment: Alignment.bottomCenter, child: Image.asset(item.imagePath, height: 65))),
                const SizedBox(height: 10), Text(item.label, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(color: _textColor, fontSize: 11, fontWeight: FontWeight.w700, height: 1.2)),
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.w800)),
        if (showSeeAll) const Text('See all', style: TextStyle(color: kRestaurantRed, fontSize: 13, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}