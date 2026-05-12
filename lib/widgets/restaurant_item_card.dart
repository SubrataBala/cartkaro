import 'package:flutter/material.dart';
import '../screens/app_models.dart';
import 'shared_card_widgets.dart';

class RestaurantItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const RestaurantItemCard({super.key, required this.item});
  @override
  State<RestaurantItemCard> createState() => _RestaurantItemCardState();
}

class _RestaurantItemCardState extends State<RestaurantItemCard> {
  int _selectedVariantIndex = 0;
  final Color themeColor = const Color(0xFFE53935);

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