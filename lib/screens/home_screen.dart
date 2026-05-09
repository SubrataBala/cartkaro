import 'package:flutter/material.dart';
import 'search_screen.dart'; 
import 'items_screen.dart'; 
import 'app_models.dart';
import 'grocery_tab.dart';     // Naya Import
import 'restaurant_tab.dart';  // Naya Import
import 'medical_tab.dart';     // Naya Import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0; 
  int _bottomNav   = 0; 
  final String _currentLocation = '7/1, Baharagora';

  final List<TabData> _tabs = const [
    TabData('Grocery',    kGroceryGreen,  Icons.local_grocery_store_rounded),
    TabData('Restaurant', kRestaurantRed, Icons.restaurant_rounded),
    TabData('Medical',    kMedicalBlue,   Icons.medical_services_rounded),
  ];

  bool get isDark => _selectedTab == 0; 
  Color get _activeColor => _tabs[_selectedTab].color;
  Color get _bgColor => isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  Color get _cardBgColor => isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _searchBgColor => isDark ? const Color(0xFF252525) : Colors.white;
  Color get _textPrimary => isDark ? Colors.white : const Color(0xFF1A1A1A); 
  Color get _textSecondary => isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);
  Color get _borderColor => isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.15);

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
              _buildSearchBar(), 
              const SizedBox(height: 16),
              _buildTabRow(),
              const SizedBox(height: 8),
              
              // ── THE MAGIC: Clean Component Switching ──
              Expanded(
                child: _bottomNav == 0 
                    ? (_selectedTab == 0 ? const GroceryTab() : _selectedTab == 1 ? const RestaurantTab() : const MedicalTab())
                    : _bottomNav == 1 
                        ? _buildWatchlistTab() 
                        : Center(child: Text("Coming Soon", style: TextStyle(color: _textPrimary, fontSize: 18))),
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
                    Flexible(child: Text(_currentLocation, style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 4), Icon(Icons.keyboard_arrow_down_rounded, color: _textSecondary, size: 24),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: _searchBgColor, shape: BoxShape.circle, border: Border.all(color: _borderColor, width: 1.2)), child: Icon(Icons.notifications_outlined, color: _textPrimary, size: 22)),
              Positioned(top: 10, right: 12, child: Container(width: 10, height: 10, decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle, border: Border.all(color: _searchBgColor, width: 2)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(initialTab: _selectedTab))),
        child: Container(
          height: 52, decoration: BoxDecoration(color: _searchBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor, width: 1.2), boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
          child: Row(
            children: [
              const SizedBox(width: 16), Icon(Icons.search_rounded, color: _textSecondary, size: 22), const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(initialTab: _selectedTab))),
                  style: TextStyle(color: _textPrimary, fontSize: 14), decoration: InputDecoration(hintText: 'What do you want to order..', hintStyle: TextStyle(color: _textSecondary, fontSize: 14), border: InputBorder.none, isDense: true),
                ),
              ),
              Container(width: 1, height: 24, color: isDark ? Colors.grey[800] : Colors.grey[300]), const SizedBox(width: 14), Icon(Icons.mic_none_rounded, color: _textSecondary, size: 22), const SizedBox(width: 16),
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
        padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: _searchBgColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: _borderColor)),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final active = _selectedTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250), padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: active ? _tabs[i].color : Colors.transparent, borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center, child: Text(_tabs[i].label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : _textPrimary)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [NavItem(Icons.home_rounded, 'Home'), NavItem(Icons.favorite_border_rounded, 'Watchlist'), NavItem(Icons.shopping_bag_outlined, 'Cart'), NavItem(Icons.person_outline_rounded, 'Profile')];
    return Container(
      height: 90, color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(height: 70, decoration: BoxDecoration(color: _searchBgColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(28)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.4 : 0.08), blurRadius: 20, offset: const Offset(0, -5))])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (i) {
                final active = _bottomNav == i;
                return GestureDetector(
                  onTap: () => setState(() => _bottomNav = i), behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 70,
                    child: active
                        ? Transform.translate(offset: const Offset(0, -22), child: Column(mainAxisSize: MainAxisSize.min, children: [Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: _activeColor, shape: BoxShape.circle, border: Border.all(color: _bgColor, width: 6), boxShadow: [BoxShadow(color: _activeColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]), child: Icon(items[i].icon, color: Colors.white, size: 26))]))
                        : Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end, children: [Icon(items[i].icon, color: _textSecondary, size: 25), const SizedBox(height: 4), Text(items[i].label, style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w600)), const SizedBox(height: 12)]),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Watchlist Rendering Logic stays here because it changes when tabs change
  Widget _buildWatchlistTab() {
    return ValueListenableBuilder(
      valueListenable: watchlistNotifier,
      builder: (context, Set<String> favorites, _) {
        final currentTabData = globalAllCategoryData[_selectedTab] ?? {};
        List<Map<String, dynamic>> favoriteItemsForThisTab = [];

        for (var categoryItems in currentTabData.values) {
          for (var item in categoryItems) {
            if (favorites.contains(item['id'])) favoriteItemsForThisTab.add(item);
          }
        }

        if (favoriteItemsForThisTab.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.favorite_border_rounded, size: 80, color: _textSecondary.withOpacity(0.3)), const SizedBox(height: 16), Text("Your ${_tabs[_selectedTab].label} Watchlist is empty", style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w600))]));
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 80), physics: const BouncingScrollPhysics(), itemCount: favoriteItemsForThisTab.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.72),
          itemBuilder: (context, index) {
            final item = favoriteItemsForThisTab[index];
            return Container(
              decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(20), border: isDark ? null : Border.all(color: Colors.grey.shade200), boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
              child: Stack(
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: 20), Center(child: Image.asset(item['image'], height: 75)), const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name'], style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis), const SizedBox(height: 2), Text(item['weight'], style: TextStyle(color: _textPrimary.withOpacity(0.5), fontSize: 11)), const SizedBox(height: 8),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('₹${item['price']}', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w800, fontSize: 15)), _WatchlistAddButton(itemId: item['id'], themeColor: _activeColor)]),
                        ],
                      ),
                    )
                  ]),
                  Positioned(top: 10, right: 10, child: GestureDetector(onTap: () { var newFavs = Set<String>.from(watchlistNotifier.value); newFavs.remove(item['id']); watchlistNotifier.value = newFavs; }, child: const Icon(Icons.favorite, color: Colors.red, size: 28))),
                ],
              ),
            );
          },
        );
      }
    );
  }
}

class _WatchlistAddButton extends StatelessWidget {
  final String itemId; final Color themeColor;
  const _WatchlistAddButton({required this.itemId, required this.themeColor});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cartCountNotifier,
      builder: (context, Map<String, int> counts, _) {
        final count = counts[itemId] ?? 0;
        if (count == 0) {
          return GestureDetector(onTap: () { var current = {...cartCountNotifier.value}; current[itemId] = 1; cartCountNotifier.value = current; }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(8)), child: const Text('ADD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))));
        } else {
          return Container(
            decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                GestureDetector(onTap: () { var current = {...cartCountNotifier.value}; current[itemId] = (current[itemId] ?? 0) - 1; if (current[itemId]! <= 0) current.remove(itemId); cartCountNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text('-', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
                Text('$count', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                GestureDetector(onTap: () { var current = {...cartCountNotifier.value}; current[itemId] = (current[itemId] ?? 0) + 1; cartCountNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text('+', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))),
              ],
            ),
          );
        }
      },
    );
  }
}