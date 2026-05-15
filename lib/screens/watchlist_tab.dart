import 'package:flutter/material.dart';
import 'app_models.dart';
import '../widgets/adaptive_item_card.dart';

class WatchlistTab extends StatelessWidget {
  final int selectedTab;
  const WatchlistTab({super.key, required this.selectedTab});

  String get _tabName {
    if (selectedTab == 1) return 'Restaurant';
    if (selectedTab == 2) return 'Medical';
    return 'Grocery';
  }

  // 🔥 Helper to get the correct cart notifier based on tab
  ValueNotifier<Map<String, int>> get _activeCartNotifier {
    if (selectedTab == 1) return restaurantCartNotifier;
    if (selectedTab == 2) return medicalCartNotifier;
    return groceryCartNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text('$_tabName Watchlist', style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 22, fontWeight: FontWeight.w800)),
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
                      // ── MAIN FIX: Using GridView for Grocery, ListView for Medical/Restaurant ──
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false), // Jelly effect disabled
                        child: selectedTab == 0
                            ? GridView.builder(
                                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), 
                                physics: const ClampingScrollPhysics(), 
                                itemCount: favoriteItemsForThisTab.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, 
                                  mainAxisSpacing: 16, crossAxisSpacing: 12, 
                                  mainAxisExtent: 245, 
                                ),
                                itemBuilder: (context, index) {
                                  return AdaptiveItemCard(
                                    item: favoriteItemsForThisTab[index], 
                                    tabIndex: selectedTab
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 100), // Zero horizontal padding for wide cards
                                physics: const ClampingScrollPhysics(),
                                itemCount: favoriteItemsForThisTab.length,
                                itemBuilder: (context, index) {
                                  return AdaptiveItemCard(
                                    item: favoriteItemsForThisTab[index], 
                                    tabIndex: selectedTab
                                  );
                                },
                              ),
                      ),

                      // Add a "View Cart" button that appears when cart is not empty
                      if (cart.isNotEmpty)
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () {
                              // Action to open cart
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: selectedTab == 1 ? kRestaurantRed : (selectedTab == 2 ? Colors.blue : Colors.green),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${cart.length} Item${cart.length > 1 ? 's' : ''} Added',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
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
                        ),
                    ],
                  );
                }
              );
            }
          ),
        ),
      ],
    );
  }
}