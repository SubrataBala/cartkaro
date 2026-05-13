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
            // 🔥 FIXED: Now properly uses your single global watchlistNotifier
            valueListenable: watchlistNotifier,
            builder: (context, Set<String> favorites, _) {
              
              // Smart Filtering: It only looks inside the data of the currently selected tab!
              final currentTabData = globalAllCategoryData[selectedTab] ?? {};
              List<Map<String, dynamic>> favoriteItemsForThisTab = [];

              for (var categoryItems in currentTabData.values) {
                for (var item in categoryItems) {
                  // If it's saved AND it belongs to this tab, add it to the list
                  if (favorites.contains(item['id'])) {
                    favoriteItemsForThisTab.add(item);
                  }
                }
              }

              // Empty State
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

              // Populated Grid State
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 80), 
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
              );
            }
          ),
        ),
      ],
    );
  }
}