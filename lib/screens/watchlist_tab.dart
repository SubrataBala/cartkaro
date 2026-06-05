import 'package:flutter/material.dart';
import 'app_models.dart';
import '../widgets/adaptive_item_card.dart';

class WatchlistTab extends StatelessWidget {
  final int selectedTab;
  final bool showHeader; 
  
  const WatchlistTab({
    super.key, 
    required this.selectedTab, 
    this.showHeader = true, 
  });

  String get _tabName {
    if (selectedTab == 1) return 'Restaurant';
    if (selectedTab == 2) return 'Medical';
    return 'Grocery';
  }

  Color get _themeColor {
    if (selectedTab == 1) return kRestaurantRed;
    if (selectedTab == 2) return Colors.blue;
    return Colors.green;
  }

  ValueNotifier<Map<String, int>> get _activeCartNotifier {
    if (selectedTab == 1) return restaurantCartNotifier;
    if (selectedTab == 2) return medicalCartNotifier;
    return groceryCartNotifier;
  }

  void _moveAllToCart(BuildContext context, List<Map<String, dynamic>> favItems, Map<String, int> currentCart) {
    final newCart = Map<String, int>.from(currentCart);
    int addedCount = 0;
    
    for (var item in favItems) {
      String cartKey = "${item['id']}|0"; 
      if (!newCart.containsKey(cartKey)) {
        newCart[cartKey] = 1; 
        addedCount++;
      }
    }

    if (addedCount > 0) {
      _activeCartNotifier.value = newCart; 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$addedCount new items moved to $_tabName Cart!'),
        backgroundColor: _themeColor,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('All items are already in your cart!'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 FIX: SafeArea add kiya taaki status bar ke peeche content na chhup jaye
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 FIX: Proper AppBar style header for Bottom Nav
          if (showHeader)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: Text(
                '$_tabName Watchlist', 
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w800)
              ),
            ),
            
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: watchlistNotifier,
              builder: (context, Set<String> favorites, _) {
                
                return ValueListenableBuilder(
                  valueListenable: _activeCartNotifier,
                  builder: (context, Map<String, int> cart, _) {
                    
                    final currentTabData = globalAllCategoryData[selectedTab] ?? {};
                    List<Map<String, dynamic>> favoriteItemsForThisTab = [];

                    for (var categoryItems in currentTabData.values) {
                      for (var item in categoryItems) {
                        if (favorites.contains(item['id'])) {
                          favoriteItemsForThisTab.add(item);
                        }
                      }
                    }

                    if (favoriteItemsForThisTab.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [
                            Icon(Icons.favorite_border_rounded, size: 80, color: Colors.grey.withOpacity(0.3)), 
                            const SizedBox(height: 16), 
                            Text("Your $_tabName Watchlist is empty", style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.w600))
                          ]
                        )
                      );
                    }

                    return Stack(
                      children: [
                        ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false), 
                          child: selectedTab == 0
                              ? GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 150), 
                                  physics: const ClampingScrollPhysics(), 
                                  itemCount: favoriteItemsForThisTab.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, 
                                    mainAxisSpacing: 16, crossAxisSpacing: 12, 
                                    mainAxisExtent: 245, 
                                  ),
                                  itemBuilder: (context, index) {
                                    return AdaptiveItemCard(item: favoriteItemsForThisTab[index], tabIndex: selectedTab);
                                  },
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 150), 
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: favoriteItemsForThisTab.length,
                                  itemBuilder: (context, index) {
                                    return AdaptiveItemCard(item: favoriteItemsForThisTab[index], tabIndex: selectedTab);
                                  },
                                ),
                        ),

                        Positioned(
                          bottom: 20, left: 20, right: 20,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (favoriteItemsForThisTab.isNotEmpty)
                                GestureDetector(
                                  onTap: () => _moveAllToCart(context, favoriteItemsForThisTab, cart),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: _themeColor, width: 2),
                                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_shopping_cart_rounded, color: _themeColor, size: 18),
                                        const SizedBox(width: 8),
                                        Text('MOVE ALL TO CART', style: TextStyle(color: _themeColor, fontWeight: FontWeight.w900, fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                              
                              const SizedBox(height: 10),

                              if (cart.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    // Add Nav to cart logic here
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: _themeColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [BoxShadow(color: _themeColor.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))]
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${cart.length} Item${cart.length > 1 ? 's' : ''} in Cart', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        const Row(
                                          children: [
                                            Text('VIEW CART', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                                            SizedBox(width: 4),
                                            Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}