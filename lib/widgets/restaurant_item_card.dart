import 'package:flutter/material.dart';
import '../screens/app_models.dart';
import 'shared_card_widgets.dart';
import '../screens/restaurant_item_details_screen.dart';

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

    // ── veg / non-veg ────────────────────────────────────────
    bool isVeg = true;
    if (item.containsKey('isVeg')) {
      isVeg =
          item['isVeg'] == true ||
          item['isVeg'].toString().toLowerCase() == 'true';
    }
    final Color vegColor =
        isVeg ? const Color(0xFF2E7D32) : const Color(0xFFB71C1C);

    // ── price / variants ─────────────────────────────────────
    final double basePrice =
        double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;
    final List variants = item['variants'] ??
        [
          {'weight': 'Standard', 'price': basePrice}
        ];
    final currentVariant = variants[_selectedVariantIndex];
    final String cartItemId = '${item['id']}|$_selectedVariantIndex';

    final int discountPrice =
        (double.tryParse(currentVariant['price'].toString()) ?? basePrice)
            .toInt();
    int originalPrice = discountPrice;
    if (currentVariant.containsKey('originalPrice') &&
        currentVariant['originalPrice'] != null) {
      originalPrice =
          (double.tryParse(currentVariant['originalPrice'].toString()) ??
                  discountPrice)
              .toInt();
    }
    if (originalPrice <= discountPrice) originalPrice = discountPrice + 40;
    final bool hasDiscount  = originalPrice > discountPrice;
    final bool hasVariants  = variants.length > 1;
    final String deliveryTime = item['deliveryTime'] ?? item['time'] ?? '35–40 Mins';
    final String distance     = item['distance'] ?? '3.5 km';

    const double imgSize    = 90;
    const double imgOverhang = 30;

    return GestureDetector(
      onTap: () {
        // Pass the raw Map directly — no model conversion needed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RestaurantItemDetailsScreen(item: item),
          ),
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── CARD ─────────────────────────────────────────
          Container(
            margin: const EdgeInsets.only(
                left: imgOverhang, top: 6, bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                imgSize - imgOverhang + 10,
                12,
                12,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name + watchlist
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            border: Border.all(color: vegColor, width: 1.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: vegColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item['name'] ?? 'Item Name',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      WatchlistIcon(
                        itemId: item['id'].toString(),
                        themeColor: themeColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹$discountPrice',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 5),
                        Text(
                          '₹$originalPrice',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // time + distance
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_filled_rounded,
                        size: 11,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          '$deliveryTime  •  $distance',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // variants + ADD button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (hasVariants)
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  List.generate(variants.length, (i) {
                                final bool sel =
                                    i == _selectedVariantIndex;
                                final String label =
                                    variants[i]['weight']
                                            ?.toString() ??
                                        'Option $i';
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(right: 5),
                                  child: GestureDetector(
                                    onTap: () => setState(
                                        () => _selectedVariantIndex = i),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 180),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 9, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: sel
                                            ? themeColor
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border: Border.all(
                                          color: sel
                                              ? themeColor
                                              : Colors.grey.shade300,
                                          width: 1.1,
                                        ),
                                      ),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: sel
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
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

          // ── IMAGE (overhangs left edge, Hero animation) ──
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: Hero(
                tag: 'restaurant_item_${item['id']}',
                child: Container(
                  width: imgSize,
                  height: imgSize,
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    item['image'] ?? 'assets/images/broccoli.png',
                    width: imgSize,
                    height: imgSize,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      width: imgSize,
                      height: imgSize,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.fastfood,
                          color: Colors.grey, size: 32),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}