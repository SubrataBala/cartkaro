import 'package:flutter/material.dart';
import '../screens/app_models.dart';
import 'shared_card_widgets.dart';

class MedicalItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  const MedicalItemCard({super.key, required this.item});
  @override
  State<MedicalItemCard> createState() => _MedicalItemCardState();
}

class _MedicalItemCardState extends State<MedicalItemCard> {
  int _selectedVariantIndex = 0;
  final Color themeColor = const Color(0xFF1565C0);

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
            height: 90, decoration: const BoxDecoration(color: Color(0xFFE3F2FD)), 
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
                  Text('By HealthCorp', style: TextStyle(color: Colors.grey.shade500, fontSize: 7, fontWeight: FontWeight.w600)),
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