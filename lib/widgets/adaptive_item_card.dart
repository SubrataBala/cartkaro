import 'package:flutter/material.dart';
import 'grocery_item_card.dart';
import 'restaurant_item_card.dart';
import 'medical_item_card.dart';

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