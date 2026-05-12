import 'package:flutter/material.dart';
import '../screens/app_models.dart'; 
import 'shared_card_widgets.dart'; 

class GroceryItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const GroceryItemCard({super.key, required this.item});
  @override
  State<GroceryItemCard> createState() => _GroceryItemCardState();
}

class _GroceryItemCardState extends State<GroceryItemCard> {
  int _selectedVariantIndex = 0;
  final Color themeColor = const Color(0xFF4CAF50);

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