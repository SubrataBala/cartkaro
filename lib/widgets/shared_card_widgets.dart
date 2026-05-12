import 'package:flutter/material.dart';
import '../screens/app_models.dart'; 

class SharedCartButton extends StatelessWidget {
  final String itemId;
  final Color themeColor;
  final ValueNotifier<Map<String, int>> cartNotifier;

  const SharedCartButton({super.key, required this.itemId, required this.themeColor, required this.cartNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cartNotifier,
      builder: (context, Map<String, int> counts, _) {
        final count = counts[itemId] ?? 0;
        if (count == 0) {
          return GestureDetector(
            onTap: () { var current = {...cartNotifier.value}; current[itemId] = 1; cartNotifier.value = current; },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: themeColor, width: 1.2), boxShadow: [BoxShadow(color: themeColor.withOpacity(0.1), blurRadius: 4)]),
              child: Text('ADD', style: TextStyle(color: themeColor, fontWeight: FontWeight.w900, fontSize: 9)),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 4)]),
            child: Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                GestureDetector(onTap: () { var current = {...cartNotifier.value}; current[itemId] = (current[itemId] ?? 0) - 1; if (current[itemId]! <= 0) current.remove(itemId); cartNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Text('-', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
                Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                GestureDetector(onTap: () { var current = {...cartNotifier.value}; current[itemId] = (current[itemId] ?? 0) + 1; cartNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Text('+', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))),
              ],
            ),
          );
        }
      },
    );
  }
}

class WatchlistIcon extends StatelessWidget {
  final String itemId;
  final Color themeColor;
  final bool isBgWhite; 

  const WatchlistIcon({super.key, required this.itemId, required this.themeColor, this.isBgWhite = false});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: watchlistNotifier,
      builder: (context, Set<String> favs, _) {
        final isFav = favs.contains(itemId);
        Widget icon = Icon(isFav ? Icons.favorite : Icons.favorite_border_rounded, color: isFav ? themeColor : Colors.grey.shade400, size: 16);
        
        return GestureDetector(
          onTap: () {
            var newFavs = Set<String>.from(favs);
            isFav ? newFavs.remove(itemId) : newFavs.add(itemId);
            watchlistNotifier.value = newFavs;
          },
          child: isBgWhite 
              ? Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]), child: icon)
              : icon,
        );
      }
    );
  }
}