import 'dart:async';
import 'package:flutter/material.dart';
import 'app_models.dart';

class MedicalTab extends StatefulWidget {
  const MedicalTab({super.key});
  @override
  State<MedicalTab> createState() => _MedicalTabState();
}

class _MedicalTabState extends State<MedicalTab> {
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _bannerIndex = 0;

  final Color _textColor = const Color(0xFF1A1A1A);
  final Color _gridItemBgColor = const Color(0xFFF0F0F0);
  final Color _borderColor = Colors.grey.withOpacity(0.15);

  final List<BannerData> _banners = const [
    BannerData(
      '24/7 Medicines',
      'Delivered in 10 mins',
      kMedicalBlue,
      'assets/images/broccoli.png',
    ),
    BannerData(
      'Free Checkups',
      'Book a lab test now',
      Colors.teal,
      'assets/images/broccoli.png',
    ),
    BannerData(
      'First Aid Kits',
      'Flat 20% off today',
      Color(0xFF00897B),
      'assets/images/broccoli.png',
    ),
  ];

  final List<SpotlightItem> _spotlights = [
    SpotlightItem(
      'Daily\nMedicines',
      'assets/images/broccoli.png',
      const Color(0xFFBBDEFB),
      Color(0xFF0D47A1),
    ),
    SpotlightItem(
      'Vitamins &\nSupplements',
      'assets/images/broccoli.png',
      const Color(0xFFC8E6C9),
      Color(0xFF1B5E20),
    ),
    SpotlightItem(
      'Diabetes\nCare',
      'assets/images/broccoli.png',
      const Color(0xFFFFF9C4),
      Color(0xFFE65100),
    ),
    SpotlightItem(
      'First Aid\nKits',
      'assets/images/broccoli.png',
      const Color(0xFFFFCCBC),
      Color(0xFFBF360C),
    ),
    SpotlightItem(
      'Health\nDevices',
      'assets/images/broccoli.png',
      const Color(0xFFD1C4E9),
      Color(0xFF4A148C),
    ),
    SpotlightItem(
      'Lab\nTests',
      'assets/images/broccoli.png',
      const Color(0xFFE1F5FE),
      Color(0xFF01579B),
    ),
  ];

  final List<GridSectionData> _grids = const [
    GridSectionData('Top Categories', [
      CategoryItem('Medicines', 'assets/images/broccoli.png'),
      CategoryItem('Vitamins', 'assets/images/broccoli.png'),
      CategoryItem('Ayurveda', 'assets/images/broccoli.png'),
      CategoryItem('Homeopathy', 'assets/images/broccoli.png'),
      CategoryItem('Sexual Wellness', 'assets/images/broccoli.png'),
      CategoryItem('Elderly Care', 'assets/images/broccoli.png'),
      CategoryItem('Nutrition', 'assets/images/broccoli.png'),
      CategoryItem('Fitness', 'assets/images/broccoli.png'),
    ]),
    GridSectionData('Personal Care', [
      CategoryItem('Skin Care', 'assets/images/broccoli.png'),
      CategoryItem('Hair Care', 'assets/images/broccoli.png'),
      CategoryItem('Oral Care', 'assets/images/broccoli.png'),
      CategoryItem('Bath & Body', 'assets/images/broccoli.png'),
      CategoryItem('Baby Care', 'assets/images/broccoli.png'),
      CategoryItem('Women Care', 'assets/images/broccoli.png'),
      CategoryItem('Face Masks', 'assets/images/broccoli.png'),
      CategoryItem('Sanitizers', 'assets/images/broccoli.png'),
    ]),
    GridSectionData('Health Monitoring', [
      CategoryItem('BP Monitor', 'assets/images/broccoli.png'),
      CategoryItem('Sugar Test', 'assets/images/broccoli.png'),
      CategoryItem('Oximeter', 'assets/images/broccoli.png'),
      CategoryItem('Thermometer', 'assets/images/broccoli.png'),
    ]),
  ];

  final List<StoreItem> _stores = const [
    StoreItem(
      'Pharmacy\nStore',
      'assets/images/broccoli.png',
      Color(0xFFBBDEFB),
    ),
    StoreItem(
      'Organic\nStore',
      'assets/images/broccoli.png',
      Color(0xFFC8E6C9),
    ),
    StoreItem(
      'Surgical\nStore',
      'assets/images/broccoli.png',
      Color(0xFFE1BEE7),
    ),
    StoreItem(
      'Wellness\nStore',
      'assets/images/broccoli.png',
      Color(0xFFFFCCBC),
    ),
    StoreItem('Baby\nStore', 'assets/images/broccoli.png', Color(0xFFF8BBD0)),
    StoreItem('Homeo\nStore', 'assets/images/broccoli.png', Color(0xFFB2DFDB)),
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
        color: kMedicalBlue,
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
              _buildHeader('Now Spotlight', true, kMedicalBlue),
              const SizedBox(height: 14),
              _buildSpotlights(),
              const SizedBox(height: 30),
              ..._buildGridSections(kMedicalBlue),
              _buildHeader('Shop Store', true, kMedicalBlue),
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
                            height: 1.1,
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
                            color: kMedicalBlue,
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
                  Expanded(
                    flex: 2,
                    child: Image.asset(b.imagePath, fit: BoxFit.contain),
                  ),
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
                      height: 1.2,
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
