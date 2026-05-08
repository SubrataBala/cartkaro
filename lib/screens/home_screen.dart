import 'dart:async';
import 'package:flutter/material.dart';
import 'search_screen.dart'; 

// ─── SHARED CONSTANTS ─────────────────────────────────────────────────────────
const Color kGroceryGreen    = Color(0xFF4CAF50); 
const Color kRestaurantRed   = Color(0xFFE53935);
const Color kMedicalBlue     = Color(0xFF1565C0);

// ─── HOME SCREEN ──────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedTab = 0; 
  int _bottomNav   = 0;
  int _bannerIndex = 0;

  final String _currentLocation = '7/1, Baharagora';

  late final PageController _bannerController;
  Timer? _bannerTimer;

  final List<TabData> _tabs = const [
    TabData('Grocery',    kGroceryGreen,  Icons.local_grocery_store_rounded),
    TabData('Restaurant', kRestaurantRed, Icons.restaurant_rounded),
    TabData('Medical',    kMedicalBlue,   Icons.medical_services_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startBannerTimer();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_bannerController.hasClients) {
        int nextIndex = (_bannerIndex + 1) % _currentBanners.length;
        _bannerController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  bool get isDark => _selectedTab == 0; 
  
  Color get _activeColor => _tabs[_selectedTab].color;
  Color get _bgColor => isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  Color get _cardBgColor => isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _searchBgColor => isDark ? const Color(0xFF252525) : Colors.white;
  Color get _gridItemBgColor => isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F0F0);
  Color get _textPrimary => isDark ? Colors.white : const Color(0xFF1A1A1A); 
  Color get _textSecondary => isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);
  Color get _borderColor => isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.15);

  void _onTabChanged(int index) {
    setState(() {
      _selectedTab = index;
      _bannerIndex = 0;
    });
    if (_bannerController.hasClients) {
      _bannerController.jumpToPage(0);
    }
    _startBannerTimer();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _bgColor,
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildSearchBar(), // Updated search bar
              const SizedBox(height: 16),
              _buildTabRow(),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildBannerSection(),
                      const SizedBox(height: 28),
                      _buildSectionHeader('Now Spotlight'),
                      const SizedBox(height: 16),
                      _buildNewSpotlightRow(),
                      const SizedBox(height: 32),
                      ..._buildAllGridSections(),
                      const SizedBox(height: 10),
                      _buildSectionHeader('Shop Store', showSeeAll: false),
                      const SizedBox(height: 16),
                      _buildShopStoreRow(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
        extendBody: true,
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        _currentLocation, 
                        style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded, color: _textSecondary, size: 24),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          NotificationBell(color: _textPrimary, cardBg: _searchBgColor, borderColor: _borderColor),
        ],
      ),
    );
  }

  // ── FIX: CLICKABLE SEARCH BAR ──
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(initialTab: _selectedTab),
            ),
          );
        },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _searchBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 1.2),
            boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.search_rounded, color: _textSecondary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true, // IMPORTANT: Prevents keyboard from opening
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(initialTab: _selectedTab),
                      ),
                    );
                  },
                  style: TextStyle(color: _textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'What do you want to order..',
                    hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              Container(width: 1, height: 24, color: isDark ? Colors.grey[800] : Colors.grey[300]),
              const SizedBox(width: 14),
              Icon(Icons.mic_none_rounded, color: _textSecondary, size: 22),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _searchBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final tab     = _tabs[i];
            final active  = _selectedTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => _onTabChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? tab.color : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tab.label,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : _textPrimary),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<BannerData> get _currentBanners {
    if (_selectedTab == 1) { 
      return const [
        BannerData('Flat 50% offer', 'On your first 3 orders', kRestaurantRed, 'assets/images/broccoli.png'),
        BannerData('Spicy Deals', 'Best biryanis in town', Colors.orange, 'assets/images/broccoli.png'),
        BannerData('Midnight Cravings', 'Open till 3 AM', Color(0xFF673AB7), 'assets/images/broccoli.png'),
        BannerData('Healthy Salads', 'Eat fresh, stay fit', Color(0xFF4CAF50), 'assets/images/broccoli.png'),
      ];
    } else if (_selectedTab == 2) { 
      return const [
        BannerData('24/7 Medicines', 'Delivered in 10 mins', kMedicalBlue, 'assets/images/broccoli.png'),
        BannerData('Free Checkups', 'Book a lab test now', Colors.teal, 'assets/images/broccoli.png'),
        BannerData('First Aid Kits', 'Flat 20% off today', Color(0xFF00897B), 'assets/images/broccoli.png'),
        BannerData('Vitamins & Pro', 'Boost your immunity', Color(0xFF0288D1), 'assets/images/broccoli.png'),
      ];
    }
    return const [ 
      BannerData('Up to 30% offer', 'Enjoy our big offer', Color(0xFFD7FFD9), 'assets/images/broccoli.png', isLightBanner: true),
      BannerData('Daily Essentials', 'Get milk & bread fast', Color(0xFFFFF0C2), 'assets/images/broccoli.png', isLightBanner: true),
      BannerData('Super Saver Pack', 'Monthly groceries', Color(0xFFFFD1D1), 'assets/images/broccoli.png', isLightBanner: true),
      BannerData('Farm Fresh', 'Direct from farmers', Color(0xFFE2D1FF), 'assets/images/broccoli.png', isLightBanner: true),
    ];
  }

  Widget _buildBannerSection() {
    final banners = _currentBanners;
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemCount: banners.length,
            itemBuilder: (ctx, i) {
              final b = banners[i];
              final textColor = b.isLightBanner ? Colors.black : Colors.white;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: b.bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 10, 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(b.title, maxLines: 2, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w800, height: 1.1)),
                                  const SizedBox(height: 6),
                                  Text(b.subtitle, maxLines: 1, style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(color: kGroceryGreen, borderRadius: BorderRadius.circular(8)),
                                    child: const Text('Shop Now', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              flex: 3,
                              child: Image.asset(b.imagePath, fit: BoxFit.contain, errorBuilder: (ctx, err, stack) => const Icon(Icons.shopping_basket, size: 60, color: Colors.black26)),
                            ),
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
      ],
    );
  }

  List<SpotlightItem> get _spotlightItems {
    if (_selectedTab == 1) { 
      return [
        SpotlightItem('Biryani &\nPulao', 'assets/images/broccoli.png', const Color(0xFFFFCDD2), Colors.red.shade900),
        SpotlightItem('Pizzas &\nBurgers', 'assets/images/broccoli.png', const Color(0xFFFFF9C4), Colors.orange.shade900),
        SpotlightItem('Noodles &\nMomos', 'assets/images/broccoli.png', const Color(0xFFDCEDC8), Colors.green.shade900),
        SpotlightItem('Desserts &\nIce Creams', 'assets/images/broccoli.png', const Color(0xFFE1BEE7), Colors.purple.shade900),
        SpotlightItem('Healthy &\nSalads', 'assets/images/broccoli.png', const Color(0xFFB2EBF2), Colors.blue.shade900),
      ];
    } else if (_selectedTab == 2) { 
      return [
        SpotlightItem('Daily\nMedicines', 'assets/images/broccoli.png', const Color(0xFFBBDEFB), Colors.blue.shade900),
        SpotlightItem('Vitamins &\nSupplements', 'assets/images/broccoli.png', const Color(0xFFC8E6C9), Colors.green.shade900),
        SpotlightItem('First Aid\nKits', 'assets/images/broccoli.png', const Color(0xFFFFCCBC), Colors.deepOrange.shade900),
        SpotlightItem('Health\nDevices', 'assets/images/broccoli.png', const Color(0xFFD1C4E9), Colors.deepPurple.shade900),
        SpotlightItem('Baby\nCare', 'assets/images/broccoli.png', const Color(0xFFF8BBD0), Colors.pink.shade900),
      ];
    }
    return [
      SpotlightItem('Fruits &\nVegetables', 'assets/images/broccoli.png', const Color(0xFFFCAEAE), const Color(0xFFD32F2F)),
      SpotlightItem('Dairy Bread\n& Eggs', 'assets/images/broccoli.png', const Color(0xFFFFF59D), const Color(0xFFF57F17)),
      SpotlightItem('Munchies &\nCold Drinks', 'assets/images/broccoli.png', const Color(0xFFC5E1A5), const Color(0xFF33691E)),
      SpotlightItem('Cooking\nEssentials', 'assets/images/broccoli.png', const Color(0xFFA5D6A7), const Color(0xFF1B5E20)),
      SpotlightItem('Cleaning\nNeeds', 'assets/images/broccoli.png', const Color(0xFF80CBC4), const Color(0xFF004D40)),
      SpotlightItem('Ice\nCreams', 'assets/images/broccoli.png', const Color(0xFF90CAF9), const Color(0xFF0D47A1)),
      SpotlightItem('Baby\nCare', 'assets/images/broccoli.png', const Color(0xFFB39DDB), const Color(0xFF311B92)),
      SpotlightItem('Beauty &\nPersonal Care', 'assets/images/broccoli.png', const Color(0xFFF48FB1), const Color(0xFF880E4F)),
      SpotlightItem('Home &\nKitchen', 'assets/images/broccoli.png', const Color(0xFFEF9A9A), const Color(0xFFB71C1C)),
      SpotlightItem('Toys &\nGames', 'assets/images/broccoli.png', const Color(0xFFCE93D8), const Color(0xFF4A148C)),
      SpotlightItem('Electronics', 'assets/images/broccoli.png', const Color(0xFFB39DDB), const Color(0xFF311B92)),
    ];
  }

  Widget _buildNewSpotlightRow() {
    return SizedBox(
      height: 165, 
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _spotlightItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (ctx, i) {
          final item = _spotlightItems[i];
          return Container(
            width: 115,
            decoration: BoxDecoration(
              color: item.bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
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
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Image.asset(
                    item.imagePath, 
                    height: 90, 
                    width: 90, 
                    fit: BoxFit.contain, 
                    errorBuilder: (c,e,s) => Icon(Icons.image_not_supported, color: item.textColor.withOpacity(0.3), size: 50)
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<GridSectionData> get _gridSections {
    if (_selectedTab == 1) { 
      return [
        GridSectionData('Top Cuisines', [
          CategoryItem('North Indian', 'assets/images/broccoli.png'), CategoryItem('South Indian', 'assets/images/broccoli.png'),
          CategoryItem('Chinese', 'assets/images/broccoli.png'), CategoryItem('Italian', 'assets/images/broccoli.png'),
        ]),
        GridSectionData('Quick Bites', [
          CategoryItem('Burgers', 'assets/images/broccoli.png'), CategoryItem('Pizzas', 'assets/images/broccoli.png'),
          CategoryItem('Rolls', 'assets/images/broccoli.png'), CategoryItem('Momos', 'assets/images/broccoli.png'),
        ]),
      ];
    } else if (_selectedTab == 2) { 
      return [
        GridSectionData('Top Categories', [
          CategoryItem('Medicines', 'assets/images/broccoli.png'), CategoryItem('Vitamins', 'assets/images/broccoli.png'),
          CategoryItem('Ayurveda', 'assets/images/broccoli.png'), CategoryItem('Homeopathy', 'assets/images/broccoli.png'),
        ]),
        GridSectionData('Personal Care', [
          CategoryItem('Skin Care', 'assets/images/broccoli.png'), CategoryItem('Hair Care', 'assets/images/broccoli.png'),
          CategoryItem('Baby Care', 'assets/images/broccoli.png'), CategoryItem('Women Care', 'assets/images/broccoli.png'),
        ]),
      ];
    }
    return [
      GridSectionData('Grocery & Kitchen', [
        CategoryItem('Vegitables\n& Fruits', 'assets/images/broccoli.png'), CategoryItem('Atta, Rice\n& Dal', 'assets/images/broccoli.png'),
        CategoryItem('Oil, Ghee\n& Masala', 'assets/images/broccoli.png'), CategoryItem('Dairy, Milk\n& Bread', 'assets/images/broccoli.png'),
        CategoryItem('Bakery &\nBiscuits', 'assets/images/broccoli.png'), CategoryItem('Dry Fruits\n& Cereals', 'assets/images/broccoli.png'),
        CategoryItem('Chicken,\nMeat & F...', 'assets/images/broccoli.png'), CategoryItem('Kitchenwa\nre & App...', 'assets/images/broccoli.png'),
      ]),
      GridSectionData('Snacks & Drinks', [
        CategoryItem('Chips &\nNamkeen', 'assets/images/broccoli.png'), CategoryItem('Sweets &\nChocolate', 'assets/images/broccoli.png'),
        CategoryItem('Drinks &\nJuices', 'assets/images/broccoli.png'), CategoryItem('Tea,\nCoffee &...', 'assets/images/broccoli.png'),
        CategoryItem('Instant\nFood', 'assets/images/broccoli.png'), CategoryItem('Sauces &\nSpreads', 'assets/images/broccoli.png'),
        CategoryItem('Paan\nCorner', 'assets/images/broccoli.png'), CategoryItem('Ice\nCreams ...', 'assets/images/broccoli.png'),
      ]),
      GridSectionData('Beauty & Personal care', [
        CategoryItem('Beauty\n& Body', 'assets/images/broccoli.png'), CategoryItem('Hair\n', 'assets/images/broccoli.png'),
        CategoryItem('Skin &\nFace', 'assets/images/broccoli.png'), CategoryItem('Beauty &\nCosmetics', 'assets/images/broccoli.png'),
      ]),
      GridSectionData('Household Essentials', [
        CategoryItem('Home &\nLifestyle', 'assets/images/broccoli.png'), CategoryItem('Cleaners\n& Repell...', 'assets/images/broccoli.png'),
        CategoryItem('Electronics\n', 'assets/images/broccoli.png'), CategoryItem('Stationery\n& Games', 'assets/images/broccoli.png'),
      ]),
    ];
  }

  List<Widget> _buildAllGridSections() {
    List<Widget> sections = [];
    for (var section in _gridSections) {
      sections.add(_buildSectionHeader(section.title, showSeeAll: section.items.length > 4));
      sections.add(const SizedBox(height: 14));
      sections.add(_buildGrid(section.items));
      sections.add(const SizedBox(height: 28));
    }
    return sections;
  }

  Widget _buildGrid(List<CategoryItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, 
          mainAxisSpacing: 16, 
          crossAxisSpacing: 12, 
          childAspectRatio: 0.60, 
        ),
        itemBuilder: (ctx, i) {
          final c = items[i];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 80, 
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _gridItemBgColor,
                  borderRadius: BorderRadius.circular(16), 
                  border: Border.all(color: _borderColor, width: 1),
                  boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 5, offset: const Offset(0, 2))],
                ),
                child: Center(
                  child: Image.asset(c.imagePath, fit: BoxFit.contain, errorBuilder: (ctx,e,s) => Icon(Icons.image, color: _textSecondary)),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                c.label, 
                textAlign: TextAlign.center, 
                maxLines: 2, 
                style: TextStyle(color: _textPrimary, fontSize: 10, fontWeight: FontWeight.w700, height: 1.3)
              ),
            ],
          );
        },
      ),
    );
  }

  List<StoreItem> get _storeItems {
    return [
      StoreItem('Winter\nStore', 'assets/images/broccoli.png', const Color(0xFFBBDEFB)),
      StoreItem('Gourmet\nStore', 'assets/images/broccoli.png', const Color(0xFFFFCCBC)),
      StoreItem('Travel\nStore', 'assets/images/broccoli.png', const Color(0xFFF0F4C3)),
      StoreItem('Puja\nStore', 'assets/images/broccoli.png', const Color(0xFFFFCDD2)),
      StoreItem('Pet\nStore', 'assets/images/broccoli.png', const Color(0xFFB9F6CA)),
      StoreItem('Local\nFavourites', 'assets/images/broccoli.png', const Color(0xFFB388FF)),
    ];
  }

  Widget _buildShopStoreRow() {
    return SizedBox(
      height: 165, 
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _storeItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (ctx, i) {
          final item = _storeItems[i];
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
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(item.imagePath, height: 65, fit: BoxFit.contain, errorBuilder: (c,e,s) => const Icon(Icons.store, color: Colors.black45)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.label, 
                  textAlign: TextAlign.center, 
                  maxLines: 2, 
                  style: TextStyle(color: _textPrimary, fontSize: 11, fontWeight: FontWeight.w700, height: 1.2)
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showSeeAll = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
          if (showSeeAll)
            Text('See all', style: TextStyle(color: kGroceryGreen, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      NavItem(Icons.home_rounded, 'Home'),
      NavItem(Icons.favorite_border_rounded, 'Wishlist'),
      NavItem(Icons.shopping_bag_outlined, 'Cart'),
      NavItem(Icons.person_outline_rounded, 'Profile'),
    ];

    return Container(
      height: 90,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: _searchBgColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.4 : 0.08), blurRadius: 20, offset: const Offset(0, -5))],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final active = _bottomNav == i;
                return GestureDetector(
                  onTap: () => setState(() => _bottomNav = i),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 70,
                    child: active
                        ? Transform.translate(
                            offset: const Offset(0, -22),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: _activeColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: _bgColor, width: 6),
                                    boxShadow: [BoxShadow(color: _activeColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                                  ),
                                  child: Icon(items[i].icon, color: Colors.white, size: 26),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(items[i].icon, color: _textSecondary, size: 25),
                              const SizedBox(height: 4),
                              Text(items[i].label, style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                            ],
                          ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SHARED WIDGETS & DATA MODELS (Now Public) ────────────────────────────────

class NotificationBell extends StatelessWidget {
  final Color color;
  final Color cardBg;
  final Color borderColor;
  const NotificationBell({super.key, required this.color, required this.cardBg, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: cardBg,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Icon(Icons.notifications_outlined, color: color, size: 22),
        ),
        Positioned(
          top: 10,
          right: 12,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, border: Border.all(color: cardBg, width: 2)),
          ),
        ),
      ],
    );
  }
}

class TabData {
  final String label;
  final Color color;
  final IconData icon;
  const TabData(this.label, this.color, this.icon);
}

class BannerData {
  final String title, subtitle;
  final Color bgColor;
  final String imagePath;
  final bool isLightBanner;
  const BannerData(this.title, this.subtitle, this.bgColor, this.imagePath, {this.isLightBanner = false});
}

class SpotlightItem {
  final String title, imagePath;
  final Color bgColor, textColor;
  const SpotlightItem(this.title, this.imagePath, this.bgColor, this.textColor);
}

class GridSectionData {
  final String title;
  final List<CategoryItem> items;
  const GridSectionData(this.title, this.items);
}

class CategoryItem {
  final String label, imagePath;
  const CategoryItem(this.label, this.imagePath);
}

class StoreItem {
  final String label, imagePath;
  final Color bgColor;
  const StoreItem(this.label, this.imagePath, this.bgColor);
}

class DealItem {
  final String name, price, originalPrice, imagePath;
  final Color color;
  const DealItem(this.name, this.price, this.originalPrice, this.imagePath, this.color);
}

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}