import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'address_screen.dart';
import 'app_models.dart';

import 'grocery_tab.dart';
import 'restaurant_tab.dart';
import 'medical_tab.dart';

import 'watchlist_tab.dart';
import 'cart_grocery.dart';
import 'cart_restaurant.dart';
import 'cart_medical.dart';
import 'profile_screen.dart'; // 🔥 IMPORT ADDED HERE

class HomeScreen extends StatefulWidget {
  final VoidCallback? onGuestLogout;
  const HomeScreen({super.key, this.onGuestLogout});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  int _bottomNav = 0;

  final List<TabData> _tabs = const [
    TabData('Grocery', kGroceryGreen, Icons.local_grocery_store_rounded),
    TabData('Restaurant', kRestaurantRed, Icons.restaurant_rounded),
    TabData('Medical', kMedicalBlue, Icons.medical_services_rounded),
  ];

  bool get isDark => false;
  Color get _activeColor => _tabs[_selectedTab].color;
  Color get _bgColor => const Color(0xFFF8F9FA);
  Color get _searchBgColor => Colors.white;
  Color get _textPrimary => const Color(0xFF1A1A1A);
  Color get _textSecondary => const Color(0xFF757575);
  Color get _borderColor => Colors.grey.withOpacity(0.15);

  ValueNotifier<Map<String, int>> get _activeCartNotifier {
    if (_selectedTab == 1) return restaurantCartNotifier;
    if (_selectedTab == 2) return medicalCartNotifier;
    return groceryCartNotifier;
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
              if (_bottomNav == 0) ...[
                _buildTopBar(),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildTabRow(),
                const SizedBox(height: 8),
              ],

              Expanded(
                child: _bottomNav == 0
                    ? (_selectedTab == 0
                          ? const GroceryTab()
                          : _selectedTab == 1
                          ? const RestaurantTab()
                          : const MedicalTab())
                    : _bottomNav == 1
                    ? WatchlistTab(selectedTab: _selectedTab)
                    : _bottomNav == 2
                    ? (_selectedTab == 0
                          ? const CartGrocery()
                          : _selectedTab == 1
                          ? const CartRestaurant()
                          : const CartMedical())
                    // 🔥 ROUTES TO OUR NEW PROFILE SCREEN
                    : ProfileScreen(activeThemeColor: _activeColor, onGuestLogout: widget.onGuestLogout),
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
            child: ValueListenableBuilder<int>(
              valueListenable: selectedAddressNotifier,
              builder: (context, selectedIndex, _) {
                bool hasAddress =
                    selectedIndex >= 0 &&
                    selectedIndex < globalSavedAddresses.length;
                String displayAddress = hasAddress
                    ? globalSavedAddresses[selectedIndex].shortAddress
                    : "Set your delivery address";
                String title = hasAddress
                    ? "Delivering to ${globalSavedAddresses[selectedIndex].type}"
                    : "Welcome";

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddressScreen(
                        isDark: isDark,
                        themeColor: _activeColor,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              displayAddress,
                              style: TextStyle(
                                color: _activeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: _activeColor,
                            size: 24,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _searchBgColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: _borderColor, width: 1.2),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: _textPrimary,
                  size: 22,
                ),
              ),
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: _searchBgColor, width: 2),
                  ),
                ),
              ),
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(initialTab: _selectedTab),
          ),
        ),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _searchBgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.search_rounded, color: _textSecondary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  readOnly: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SearchScreen(initialTab: _selectedTab),
                    ),
                  ),
                  style: TextStyle(color: _textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'What do you want to order..',
                    hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              Container(width: 1, height: 24, color: Colors.grey[300]),
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
            final active = _selectedTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? _tabs[i].color : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _tabs[i].label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : _textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      NavItem(Icons.home_rounded, 'Home'),
      NavItem(Icons.favorite_border_rounded, 'Watchlist'),
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
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
                                    border: Border.all(
                                      color: _bgColor,
                                      width: 6,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _activeColor.withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: _buildNavIcon(
                                    i,
                                    Colors.white,
                                    26,
                                    true,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildNavIcon(i, _textSecondary, 25, false),
                              const SizedBox(height: 4),
                              Text(
                                items[i].label,
                                style: TextStyle(
                                  color: _textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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

  Widget _buildNavIcon(int index, Color iconColor, double size, bool isActive) {
    if (index == 2) {
      return ValueListenableBuilder(
        valueListenable: _activeCartNotifier,
        builder: (context, Map<String, int> cart, _) {
          int totalItems = cart.values.fold(0, (sum, count) => sum + count);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.shopping_bag_outlined, color: iconColor, size: size),
              if (totalItems > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$totalItems',
                      style: TextStyle(
                        color: isActive ? _activeColor : Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }
    return Icon(
      [
        Icons.home_rounded,
        Icons.favorite_border_rounded,
        Icons.shopping_bag_outlined,
        Icons.person_outline_rounded,
      ][index],
      color: iconColor,
      size: size,
    );
  }
}