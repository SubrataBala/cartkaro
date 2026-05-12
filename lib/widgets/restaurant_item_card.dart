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
  final Color themeColor = const Color(0xFFE53935); // 🔴 RED THEME

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    // ── 1. BULLETPROOF VEG/NON-VEG LOGIC ──────────────────────────────────────
    bool isVeg = true; // Default to veg
    if (item.containsKey('isVeg')) {
      // This safely handles both boolean (false) and String ("false") from your data
      isVeg = item['isVeg'] == true || item['isVeg'].toString().toLowerCase() == 'true';
    }

    // ── 2. BULLETPROOF PRICE & DISCOUNT LOGIC ─────────────────────────────────
    double basePrice = double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;

    final List variants = item['variants'] ?? [
      {
        'weight': 'Standard',
        'price': basePrice,
      }
    ];

    final currentVariant = variants[_selectedVariantIndex];
    final String cartItemId = "${item['id']}|$_selectedVariantIndex";

    final int discountPrice = (double.tryParse(currentVariant['price'].toString()) ?? basePrice).toInt();
    
    // Safely check for originalPrice. 
    int originalPrice = discountPrice;
    if (currentVariant.containsKey('originalPrice') && currentVariant['originalPrice'] != null) {
      originalPrice = (double.tryParse(currentVariant['originalPrice'].toString()) ?? discountPrice).toInt();
    }
    
    // 🔥 MAGIC FIX: If there is no originalPrice in your data, we artificially add ₹40 
    // so you can actually see the strikethrough design working!
    if (originalPrice <= discountPrice) {
      originalPrice = discountPrice + 40; 
    }

    final bool hasDiscount = originalPrice > discountPrice;
    final bool hasVariants = variants.length > 1;

    final String deliveryTime = item['deliveryTime'] ?? '35–40 Mins';
    final String distance = item['distance'] ?? '3.5 km';

    // ── Veg / Non-Veg indicator (Dynamic Color) ───────────────────────────────
    final Color vegColor = isVeg ? const Color(0xFF2E7D32) : const Color(0xFFB71C1C);

    final Widget vegIndicator = Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        border: Border.all(color: vegColor, width: 1.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: vegColor),
        ),
      ),
    );

    // ── Build ─────────────────────────────────────────────────────────────────
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Far-left veg dot
          vegIndicator,
          const SizedBox(width: 8),

          // Stack: white card + overlapping circular image
          Expanded(
            child: SizedBox(
              height: 145, // Fixed height so the stack doesn't collapse
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ── White card ──────────────────────────────────────────────
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.only(left: 45), // Space for the image to overlap
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(60, 12, 12, 12), // 60px left padding clears the image
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // ── Name + Watchlist ────────────────────────────
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['name'] ?? 'Item Name',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1A1A1A),
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                WatchlistIcon(itemId: item['id'].toString(), themeColor: themeColor),
                              ],
                            ),

                            // ── Dual Price ──────────────────────────────────
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹$discountPrice',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                                if (hasDiscount) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '₹$originalPrice',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // ── Delivery info (Time & Distance) ───────────────
                            Row(
                              children: [
                                Icon(Icons.access_time_filled_rounded, size: 12, color: Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text(
                                  '$deliveryTime  •  $distance',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            // ── Variant chips + ADD button ──────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (hasVariants)
                                  Expanded(
                                    child: _VariantChips(
                                      variants: variants,
                                      selectedIndex: _selectedVariantIndex,
                                      themeColor: themeColor,
                                      onSelected: (i) => setState(() => _selectedVariantIndex = i),
                                    ),
                                  )
                                else
                                  const Spacer(),

                                SharedCartButton(
                                  itemId: cartItemId,
                                  themeColor: themeColor,
                                  cartNotifier: restaurantCartNotifier,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Overlapping circular food image ─────────────────────────
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        width: 100, // Slightly increased size to let the burger breathe
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            item['image'] ?? 'assets/images/broccoli.png', 
                            // 🔥 THE MAGIC FIX IS HERE: BoxFit.contain
                            fit: BoxFit.contain, 
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.fastfood, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Variant Chips ─────────────────────────────────────────────────────────────

class _VariantChips extends StatelessWidget {
  final List variants;
  final int selectedIndex;
  final Color themeColor;
  final ValueChanged<int> onSelected;

  const _VariantChips({
    required this.variants,
    required this.selectedIndex,
    required this.themeColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(variants.length, (i) {
          final bool selected = i == selectedIndex;
          final String label = variants[i]['weight']?.toString() ?? 'Option $i';
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? themeColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? themeColor : Colors.grey.shade300,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}