import 'package:flutter/material.dart';
import '../screens/app_models.dart';
import '../screens/medical_item_details_screen.dart';
import '../widgets/medical_item_details_widgets.dart';
import 'shared_card_widgets.dart';

class MedicalItemCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final int initialVariantIndex;

  const MedicalItemCard({
    super.key,
    required this.item,
    this.initialVariantIndex = 0,
  });

  @override
  State<MedicalItemCard> createState() => _MedicalItemCardState();
}

class _MedicalItemCardState extends State<MedicalItemCard> {
  late int _selectedVariantIndex;

  final Color themeColor = const Color(0xFF1565C0);

  @override
  void initState() {
    super.initState();
    _selectedVariantIndex = widget.initialVariantIndex;
  }

  void _openDetails() {
    final item = widget.item;

    final variants = item['variants'] as List? ?? [];

final firstVariant =
    variants.isNotEmpty
        ? variants.first as Map<String, dynamic>
        : <String, dynamic>{};

final double price =
    double.tryParse(firstVariant['price']?.toString() ?? '0') ?? 0;

final double mrp =
    double.tryParse(
          firstVariant['originalPrice']?.toString() ??
              price.toString(),
        ) ??
        price;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicalItemDetailsScreen(
          medicine: MedicineModel(
            id: item['id'].toString(),
            name: item['name'] ?? 'Medicine',
            manufacturer:
                item['manufacturer'] ?? 'Generic Pharma',
            description: item['description'] ??
                'No description available.',
            price: price,
            mrp: mrp, 
            discountPercent: item['discount'] ?? 0,
            imagePaths: [
              item['image'] ??
                  'assets/images/broccoli.png'
            ],
            prescriptionRequired:
                item['prescriptionRequired'] ?? false,
            composition:
                item['composition'] ?? '',
            uses: List<String>.from(item['uses'] ?? []),
            sideEffects:
                List<String>.from(item['sideEffects'] ?? []),
            safetyAdvice:
                item['safetyAdvice'] ?? '',
            dosageInstructions:
                item['dosageInstructions'] ?? '',
            storageInformation:
                item['storageInformation'] ?? '',
            manufacturerInfo:
                item['manufacturerInfo'] ?? '',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    double basePrice =
        double.tryParse(item['price']?.toString() ?? '0') ??
            0.0;

    final List variants = item['variants'] ??
        [
          {
            'weight': item['weight'] ?? '1 Strip',
            'price': basePrice
          }
        ];

    final currentVariant = variants[_selectedVariantIndex];

    final String cartItemId =
        "${item['id']}|$_selectedVariantIndex";

    final int discountPrice =
        (double.tryParse(
                    currentVariant['price'].toString()) ??
                basePrice)
            .toInt();

    int originalPrice = discountPrice;

    if (currentVariant.containsKey('originalPrice') &&
        currentVariant['originalPrice'] != null) {
      originalPrice = (double.tryParse(
                  currentVariant['originalPrice']
                      .toString()) ??
              discountPrice)
          .toInt();
    }

    if (originalPrice <= discountPrice) {
      originalPrice =
          discountPrice + (discountPrice ~/ 5);
    }

    final int savedAmount =
        originalPrice - discountPrice;

    final bool hasVariants = variants.length > 1;

    final String subtitle = item['subtitle'] ??
        'Fast Relief • Clinically Tested';

    final String rating =
        item['rating']?.toString() ?? '4.6';

    final String bought =
        item['totalSells'] ?? '2.1k+ bought';

    return GestureDetector(
      onTap: _openDetails,
      child: Container(
        margin:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            Hero(
              tag: 'medicine_${item['id']}',
              child: Container(
                width: 85,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF3FB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    item['image'] ??
                        'assets/images/broccoli.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item['name'] ?? 'Medicine',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EEFF),
                          borderRadius:
                              BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: themeColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              rating,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.bold,
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        bought,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        '₹$originalPrice',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          decoration:
                              TextDecoration.lineThrough,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        '₹$discountPrice',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EEFF),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Save ₹$savedAmount',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ACTIONS
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                WatchlistIcon(
                  itemId: item['id'].toString(),
                  themeColor: themeColor,
                ),

                const SizedBox(height: 8),

                if (hasVariants)
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: themeColor, width: 1),
                      borderRadius:
                          BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedVariantIndex,
                        isDense: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: themeColor,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() =>
                                _selectedVariantIndex =
                                    val);
                          }
                        },
                        items: List.generate(
                          variants.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(
                                variants[index]['weight']),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 30),

                const SizedBox(height: 8),

                SharedCartButton(
                  itemId: cartItemId,
                  themeColor: themeColor,
                  cartNotifier: medicalCartNotifier,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}