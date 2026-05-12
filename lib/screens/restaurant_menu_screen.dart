import 'package:flutter/material.dart';
import 'app_models.dart';
import '../widgets/adaptive_item_card.dart';

class RestaurantMenuScreen extends StatelessWidget {
  final VendorRestaurant restaurant;

  const RestaurantMenuScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: Text(restaurant.name, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── RESTAURANT HEADER ──
          Container(
            padding: const EdgeInsets.all(16), 
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      restaurant.imagePath, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.storefront_rounded, color: Colors.grey, size: 40)),
                    )
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant.name, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(restaurant.categories, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      // ── MAIN FIX: Added Distance ──
                      Text('${restaurant.rating} ⭐ • ${restaurant.time} • ${restaurant.distance}', style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      // ── MAIN FIX: Added Total Sells ──
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text('📈 ${restaurant.totalSells}', style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── MENU ITEMS ──
          // ── MENU ITEMS ──
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              itemCount: restaurant.menu.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                // Taaki Cart me item ka restaurant name bhi jaye
                var menuItem = Map<String, dynamic>.from(restaurant.menu[index]);
                menuItem['restaurant'] = restaurant.name; 
                
                return AdaptiveItemCard(
                  item: menuItem, 
                  tabIndex: 1, 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}