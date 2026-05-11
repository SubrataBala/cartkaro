import 'package:flutter/material.dart';
// Dhyan de: app_models screens folder me hai, isliye '../screens/' use kiya hai
import '../screens/app_models.dart'; 

// ============================================================================
// 1. THE SWITCHER (Ye decide karega kaunsa card dikhana hai)
// ============================================================================
class AdaptiveItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final int tabIndex; // 0 = Grocery, 1 = Restaurant, 2 = Medical

  const AdaptiveItemCard({super.key, required this.item, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    if (tabIndex == 1) {
      return RestaurantItemCard(item: item);
    } else if (tabIndex == 2) {
      return MedicalItemCard(item: item);
    } else {
      return GroceryItemCard(item: item);
    }
  }
}

// ============================================================================
// 2. GROCERY CARD (Green Theme - Zepto/Blinkit Style)
// ============================================================================
class GroceryItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const GroceryItemCard({super.key, required this.item});
  @override
  State<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends State<GroceryItemCard> {
  int _selectedVariantIndex = 0;
  final Color themeColor = const Color(0xFF4CAF50); // Green

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final List variants = item.containsKey('variants') ? item['variants'] : [{'weight': item['weight'], 'price': item['price']}];
    final currentVariant = variants[_selectedVariantIndex];
    final String cartItemId = "${item['id']}|$_selectedVariantIndex";
    int price = (double.tryParse(currentVariant['price'].toString()) ?? 0.0).toInt();

    return Container(
      clipBehavior: Clip.antiAlias, 
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90, decoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
            child: Stack(
              children: [
                Center(child: Padding(padding: const EdgeInsets.all(12), child: Image.asset(item['image'], errorBuilder: (_,__,___)=> const Text('🥦', style: TextStyle(fontSize: 30))))),
                Positioned(top: 6, left: 6, child: WatchlistIcon(itemId: item['id'], themeColor: themeColor)),
                if (item['isBestseller'] == true) Positioned(bottom: 0, left: 0, right: 0, child: Container(padding: const EdgeInsets.symmetric(vertical: 2), decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.9)), child: const Text('Bestseller', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Text(item['name'], style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w700, fontSize: 10, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                  _buildDropdown(variants),
                  Row(children: [Text('10 MINS', style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 7, fontWeight: FontWeight.w700)), const Spacer(), const Icon(Icons.star, color: Colors.green, size: 8), Text(' 4.6', style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 8, fontWeight: FontWeight.w600))]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹$price', style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w900, fontSize: 13)),
                      SharedCartButton(itemId: cartItemId, themeColor: themeColor, cartNotifier: groceryCartNotifier),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List variants) {
    return Container(height: 24, padding: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey.shade300)), child: DropdownButtonHideUnderline(child: DropdownButton<int>(isExpanded: true, value: _selectedVariantIndex, icon: const Icon(Icons.keyboard_arrow_down, size: 12, color: Colors.black54), dropdownColor: Colors.white, style: const TextStyle(color: Colors.black87, fontSize: 9, fontWeight: FontWeight.w600), items: variants.asMap().entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value['weight'].toString()))).toList(), onChanged: (val) => setState(() => _selectedVariantIndex = val!))));
  }
}

// ============================================================================
// 3. RESTAURANT CARD (Red Theme - Zomato/Swiggy Style)
// ============================================================================
class RestaurantItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const RestaurantItemCard({super.key, required this.item});
  @override
  State<RestaurantItemCard> createState() => _RestaurantItemCardState();
}

class _RestaurantItemCardState extends State<RestaurantItemCard> {
  int _selectedVariantIndex = 0;
  final Color themeColor = const Color(0xFFE53935); // Red

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final List variants = item.containsKey('variants') ? item['variants'] : [{'weight': item['weight'], 'price': item['price']}];
    final currentVariant = variants[_selectedVariantIndex];
    final String cartItemId = "${item['id']}|$_selectedVariantIndex";
    int price = (double.tryParse(currentVariant['price'].toString()) ?? 0.0).toInt();

    return Container(
      clipBehavior: Clip.antiAlias, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 6))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100, decoration: const BoxDecoration(color: Color(0xFFFFF3E0)),
            child: Stack(
              children: [
                Center(child: Padding(padding: const EdgeInsets.all(8), child: Image.asset(item['image'], fit: BoxFit.cover, errorBuilder: (_,__,___)=> const Text('🍔', style: TextStyle(fontSize: 40))))),
                Positioned(top: 8, right: 8, child: WatchlistIcon(itemId: item['id'], themeColor: themeColor, isBgWhite: true)),
                if (item['isBestseller'] == true) Positioned(top: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: themeColor, borderRadius: BorderRadius.circular(4)), child: const Text('MUST TRY', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 0.5)))),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Text(item['name'], style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w800, fontSize: 11, height: 1.1), maxLines: 2, overflow: TextOverflow.ellipsis),
                  _buildDropdown(variants),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [const Icon(Icons.star, color: Colors.orange, size: 10), const SizedBox(width: 2), Text('4.5', style: TextStyle(color: Colors.grey.shade700, fontSize: 9, fontWeight: FontWeight.bold))]),
                      const SizedBox(height: 4),
                      Text('₹$price', style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w900, fontSize: 14)),
                    ]),
                    SharedCartButton(itemId: cartItemId, themeColor: themeColor, cartNotifier: restaurantCartNotifier),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List variants) {
    return Container(height: 22, padding: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade300)), child: DropdownButtonHideUnderline(child: DropdownButton<int>(isExpanded: true, value: _selectedVariantIndex, icon: const Icon(Icons.keyboard_arrow_down, size: 12, color: Colors.black54), dropdownColor: Colors.white, style: const TextStyle(color: Colors.black87, fontSize: 9, fontWeight: FontWeight.w600), items: variants.asMap().entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value['weight'].toString()))).toList(), onChanged: (val) => setState(() => _selectedVariantIndex = val!))));
  }
}

// ============================================================================
// 4. MEDICAL CARD (Blue Theme - 1mg/Apollo Style)
// ============================================================================
class MedicalItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const MedicalItemCard({super.key, required this.item});
  @override
  State<MedicalItemCard> createState() => _MedicalItemCardState();
}

class _MedicalItemCardState extends State<MedicalItemCard> {
  int _selectedVariantIndex = 0;
  final Color themeColor = const Color(0xFF1565C0); // Clinical Blue

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final List variants = item.containsKey('variants') ? item['variants'] : [{'weight': item['weight'], 'price': item['price']}];
    final currentVariant = variants[_selectedVariantIndex];
    final String cartItemId = "${item['id']}|$_selectedVariantIndex";
    int price = (double.tryParse(currentVariant['price'].toString()) ?? 0.0).toInt();

    return Container(
      clipBehavior: Clip.antiAlias, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade50), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90, decoration: const BoxDecoration(color: Color(0xFFE3F2FD)), // Very Light Blue
            child: Stack(
              children: [
                Center(child: Padding(padding: const EdgeInsets.all(12), child: Image.asset(item['image'], errorBuilder: (_,__,___)=> const Text('💊', style: TextStyle(fontSize: 30))))),
                Positioned(top: 6, right: 6, child: WatchlistIcon(itemId: item['id'], themeColor: themeColor)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Text(item['name'], style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w700, fontSize: 10, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Text('By HealthCorp', style: TextStyle(color: Colors.grey.shade500, fontSize: 7, fontWeight: FontWeight.w600)), // Fake brand name for realism
                  _buildDropdown(variants),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹$price', style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w900, fontSize: 14)),
                      SharedCartButton(itemId: cartItemId, themeColor: themeColor, cartNotifier: medicalCartNotifier),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(List variants) {
    return Container(height: 24, padding: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: themeColor.withOpacity(0.3))), child: DropdownButtonHideUnderline(child: DropdownButton<int>(isExpanded: true, value: _selectedVariantIndex, icon: Icon(Icons.arrow_drop_down, size: 14, color: themeColor), dropdownColor: Colors.white, style: const TextStyle(color: Colors.black87, fontSize: 9, fontWeight: FontWeight.w600), items: variants.asMap().entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value['weight'].toString()))).toList(), onChanged: (val) => setState(() => _selectedVariantIndex = val!))));
  }
}

// ============================================================================
// 5. SHARED LOGIC COMPONENTS (Cart Button & Watchlist Heart)
// ============================================================================
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
  final bool isBgWhite; // For restaurant cards where we might want a circular white background

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