import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Color _gridItemBgColor = const Color(0xFFF5F7FA); // Light clinical grey
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
    SpotlightItem('Daily\nMedicines', 'assets/images/broccoli.png', const Color(0xFFE3F2FD), Color(0xFF0D47A1)),
    SpotlightItem('Vitamins &\nSupplements', 'assets/images/broccoli.png', const Color(0xFFE8F5E9), Color(0xFF1B5E20)),
    SpotlightItem('Diabetes\nCare', 'assets/images/broccoli.png', const Color(0xFFFFFDE7), Color(0xFFE65100)),
    SpotlightItem('First Aid\nKits', 'assets/images/broccoli.png', const Color(0xFFFBE9E7), Color(0xFFBF360C)),
    SpotlightItem('Health\nDevices', 'assets/images/broccoli.png', const Color(0xFFEDE7F6), Color(0xFF4A148C)),
    SpotlightItem('Lab\nTests', 'assets/images/broccoli.png', const Color(0xFFE1F5FE), Color(0xFF01579B)),
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
    StoreItem('Pharmacy\nStore', 'assets/images/broccoli.png', Color(0xFFBBDEFB)),
    StoreItem('Organic\nStore', 'assets/images/broccoli.png', Color(0xFFC8E6C9)),
    StoreItem('Surgical\nStore', 'assets/images/broccoli.png', Color(0xFFE1BEE7)),
    StoreItem('Wellness\nStore', 'assets/images/broccoli.png', Color(0xFFFFCCBC)),
    StoreItem('Baby\nStore', 'assets/images/broccoli.png', Color(0xFFF8BBD0)),
    StoreItem('Homeo\nStore', 'assets/images/broccoli.png', Color(0xFFB2DFDB)),
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
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
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
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: NoJellyScrollBehavior(),
        child: RefreshIndicator(
          onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
          color: kMedicalBlue,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16), // ── MAIN FIX: Removed Search Bar, added top spacing ──
                _buildBanners(),
                const SizedBox(height: 32),
                _buildHeader('Shop by Concern', true, kMedicalBlue),
                const SizedBox(height: 16),
                _buildSpotlights(),
                const SizedBox(height: 35),
                ..._buildGridSections(kMedicalBlue),
                _buildHeader('Partner Pharmacies', true, kMedicalBlue),
                const SizedBox(height: 16),
                _buildStores(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── REDESIGNED PREMIUM BANNERS ───
  Widget _buildBanners() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (index) => setState(() => _bannerIndex = index),
            itemBuilder: (ctx, i) {
              final b = _banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [b.bgColor.withOpacity(0.9), b.bgColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: b.bgColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      Positioned(right: -30, top: -30, child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.1))),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(4)), child: const Text('PROMO', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1))),
                                  const SizedBox(height: 8),
                                  Text(b.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.1)),
                                  const SizedBox(height: 6),
                                  Text(b.subtitle, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 14),
                                  Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Text('Order Now', style: TextStyle(color: b.bgColor, fontSize: 11, fontWeight: FontWeight.w800))),
                                ],
                              ),
                            ),
                            Expanded(flex: 4, child: Image.asset(b.imagePath, fit: BoxFit.contain)),
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
              width: i == _bannerIndex ? 24 : 8, height: 6,
              decoration: BoxDecoration(color: i == _bannerIndex ? kMedicalBlue : Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
            );
          }),
        ),
      ],
    );
  }

  // ─── REDESIGNED SPOTLIGHTS (Vertical Cards) ───
  Widget _buildSpotlights() {
    return SizedBox(
      height: 135,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _spotlights.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final item = _spotlights[i];
          return Container(
            width: 100,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))]),
            child: Column(
              children: [
                Container(height: 75, decoration: BoxDecoration(color: item.bgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))), child: Center(child: Image.asset(item.imagePath, height: 50))),
                Expanded(child: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(item.title, textAlign: TextAlign.center, style: TextStyle(color: _textColor, fontSize: 10, fontWeight: FontWeight.w800, height: 1.1))))),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── REDESIGNED GRIDS (3-Column Clean Layout) ───
  List<Widget> _buildGridSections(Color themeColor) {
    return _grids.map((section) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(section.title, section.items.length >= 6, themeColor),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: section.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, 
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (ctx, i) {
              final c = section.items[i];
              return Column(
                children: [
                  Container(
                    height: 80, width: double.infinity,
                    decoration: BoxDecoration(color: _gridItemBgColor, borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Image.asset(c.imagePath, height: 50)),
                  ),
                  const SizedBox(height: 10),
                  Text(c.label, textAlign: TextAlign.center, maxLines: 2, style: TextStyle(color: _textColor, fontSize: 11, fontWeight: FontWeight.w700, height: 1.1)),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 35),
      ],
    )).toList();
  }

  // ─── REDESIGNED STORES (Wide Premium Cards) ───
  Widget _buildStores() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, i) {
          final item = _stores[i];
          return Container(
            width: 240, // Wide card format
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: item.bgColor.withOpacity(0.3), borderRadius: BorderRadius.circular(16), border: Border.all(color: item.bgColor)),
            child: Row(
              children: [
                Container(width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Center(child: Image.asset(item.imagePath, height: 50))),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.label.replaceAll('\n', ' '), style: TextStyle(color: _textColor, fontSize: 14, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Explore Store', style: TextStyle(color: kMedicalBlue, fontSize: 10, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, color: kMedicalBlue, size: 12)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── REDESIGNED HEADER ───
  Widget _buildHeader(String title, bool showSeeAll, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 4, height: 16, decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            ],
          ),
          if (showSeeAll)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Text('See all', style: TextStyle(color: themeColor, fontSize: 11, fontWeight: FontWeight.w800)),
            ),
        ],
      ),
    );
  }
}

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}