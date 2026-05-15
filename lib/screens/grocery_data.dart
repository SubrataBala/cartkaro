import 'package:flutter/material.dart';

// ==========================================
// 1. UI MODELS
// ==========================================
class BannerData {
  final String title;
  final String subtitle;
  final Color bgColor;
  final String imagePath;
  final bool isLightBanner;

  const BannerData(this.title, this.subtitle, this.bgColor, this.imagePath, {this.isLightBanner = false});
}

class SpotlightItem {
  final String title;
  final String imagePath;
  final Color bgColor;
  final Color textColor;

  const SpotlightItem(this.title, this.imagePath, this.bgColor, this.textColor);
}

class CategoryItem {
  final String label;
  final String imagePath;

  const CategoryItem(this.label, this.imagePath);
}

class GridSectionData {
  final String title;
  final List<CategoryItem> items;

  const GridSectionData(this.title, this.items);
}

class StoreItem {
  final String label;
  final String imagePath;
  final Color bgColor;

  const StoreItem(this.label, this.imagePath, this.bgColor);
}

// ==========================================
// 2. GROCERY DATA MAP
// ==========================================
final Map<String, List<Map<String, dynamic>>> groceryData = {
  'Vegetables': [
    {'id': 'g1', 'name': 'Potato', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '500g', 'price': 18.0, 'originalPrice': 25.0}, {'weight': '1kg', 'price': 34.0, 'originalPrice': 45.0}, {'weight': '2kg', 'price': 65.0, 'originalPrice': 80.0}]},
    {'id': 'g2', 'name': 'Broccoli', 'brand': 'Nature Fresh', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1 pc', 'price': 45.0, 'originalPrice': 55.0}, {'weight': '2 pcs', 'price': 85.0, 'originalPrice': 100.0}]},
    {'id': 'g3', 'name': 'Carrot', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '250g', 'price': 22.0, 'originalPrice': 30.0}, {'weight': '500g', 'price': 40.0, 'originalPrice': 50.0}, {'weight': '1kg', 'price': 75.0, 'originalPrice': 90.0}]},
    {'id': 'g4', 'name': 'Onion', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '1kg', 'price': 35.0, 'originalPrice': 45.0}, {'weight': '5kg', 'price': 160.0, 'originalPrice': 200.0}]},
    {'id': 'g5', 'name': 'Cabbage', 'brand': 'Nature Fresh', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1 pc', 'price': 45.0, 'originalPrice': 50.0}]},
    {'id': 'g21', 'name': 'Tomato (Desi)', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '500g', 'price': 20.0, 'originalPrice': 28.0}, {'weight': '1kg', 'price': 38.0, 'originalPrice': 50.0}]},
    {'id': 'g25', 'name': 'Green Chilli', 'brand': 'Local', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '100g', 'price': 12.0, 'originalPrice': 15.0}, {'weight': '250g', 'price': 25.0, 'originalPrice': 35.0}]},
    {'id': 'g26', 'name': 'Garlic', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '200g', 'price': 45.0, 'originalPrice': 60.0}]},
    {'id': 'g27', 'name': 'Capsicum (Green)', 'brand': 'Nature Fresh', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '250g', 'price': 25.0, 'originalPrice': 35.0}, {'weight': '500g', 'price': 45.0, 'originalPrice': 60.0}]},
    {'id': 'g42', 'name': 'Sweet Potato', 'brand': 'Nature Fresh', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '500g', 'price': 20.0, 'originalPrice': 25.0}, {'weight': '1kg', 'price': 40.0, 'originalPrice': 45.0}, {'weight': '2kg', 'price': 70.0, 'originalPrice': 80.0}]},

  ],
  'Fruits': [
    {'id': 'g6', 'name': 'Kashmiri Apple', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '4 pcs', 'price': 80.0, 'originalPrice': 100.0}, {'weight': '1kg', 'price': 150.0, 'originalPrice': 180.0}]},
    {'id': 'g7', 'name': 'Banana (Robusta)', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '6 pcs', 'price': 35.0, 'originalPrice': 45.0}, {'weight': '1 Dozen', 'price': 65.0, 'originalPrice': 80.0}]},
    {'id': 'g8', 'name': 'Papaya (Semi-Ripe)', 'brand': 'Nature Fresh', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1 pc', 'price': 60.0, 'originalPrice': 75.0}, {'weight': '1.5kg', 'price': 85.0, 'originalPrice': 100.0}]},
    {'id': 'g9', 'name': 'Nagpur Orange', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '500g', 'price': 50.0, 'originalPrice': 65.0}, {'weight': '1kg', 'price': 95.0, 'originalPrice': 120.0}]},
    {'id': 'g10', 'name': 'Green Guava', 'brand': 'Nature Fresh', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '500g', 'price': 40.0, 'originalPrice': 55.0}, {'weight': '1kg', 'price': 75.0, 'originalPrice': 100.0}]},
    {'id': 'g22', 'name': 'Pomegranate', 'brand': 'Nature Fresh', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1 pc', 'price': 70.0, 'originalPrice': 90.0}]},
    {'id': 'g28', 'name': 'Watermelon', 'brand': 'Fresh Farms', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1 pc (2-3 kg)', 'price': 80.0, 'originalPrice': 120.0}]},
    {'id': 'g29', 'name': 'Green Grapes', 'brand': 'Nature Fresh', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '500g', 'price': 65.0, 'originalPrice': 90.0}]},
    {'id': 'g30', 'name': 'Alphonso Mango', 'brand': 'Fresh Farms', 'isBestseller': true, 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1 Dozen', 'price': 450.0, 'originalPrice': 550.0}]},
  ],
  'Dairy & Eggs': [
    {'id': 'g31', 'name': 'Amul Taaza Milk', 'brand': 'Amul', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '500ml', 'price': 26.0, 'originalPrice': 26.0}, {'weight': '1 L', 'price': 52.0, 'originalPrice': 52.0}]},
    {'id': 'g32', 'name': 'Farm Fresh White Eggs', 'brand': 'Eggoz', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '6 pcs', 'price': 45.0, 'originalPrice': 55.0}, {'weight': '30 pcs', 'price': 210.0, 'originalPrice': 250.0}]},
    {'id': 'g33', 'name': 'Mother Dairy Paneer', 'brand': 'Mother Dairy', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '200g', 'price': 85.0, 'originalPrice': 90.0}]},
    {'id': 'g34', 'name': 'Amul Butter', 'brand': 'Amul', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '100g', 'price': 58.0, 'originalPrice': 58.0}, {'weight': '500g', 'price': 285.0, 'originalPrice': 290.0}]},
    {'id': 'g35', 'name': 'Britannia Cheese Slices', 'brand': 'Britannia', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '200g (10 Slices)', 'price': 135.0, 'originalPrice': 150.0}]},
  ],
  'Grocery': [
    {'id': 'g11', 'name': 'India Gate Basmati Rice', 'brand': 'India Gate', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '1kg', 'price': 110.0, 'originalPrice': 140.0}, {'weight': '5kg', 'price': 520.0, 'originalPrice': 650.0}]},
    {'id': 'g12', 'name': 'Aashirvaad Shudh Chakki Atta', 'brand': 'Aashirvaad', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '1kg', 'price': 55.0, 'originalPrice': 65.0}, {'weight': '5kg', 'price': 240.0, 'originalPrice': 280.0}, {'weight': '10kg', 'price': 450.0, 'originalPrice': 520.0}]},
    {'id': 'g13', 'name': 'Tata Sampann Arhar Dal', 'brand': 'Tata Sampann', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '500g', 'price': 85.0, 'originalPrice': 100.0}, {'weight': '1kg', 'price': 160.0, 'originalPrice': 190.0}]},
    {'id': 'g14', 'name': 'Fortune Mustard Oil', 'brand': 'Fortune', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1 L', 'price': 145.0, 'originalPrice': 175.0}, {'weight': '5 L', 'price': 700.0, 'originalPrice': 850.0}]},
    {'id': 'g15', 'name': 'Madhur Pure & Hygienic Sugar', 'brand': 'Madhur', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1kg', 'price': 48.0, 'originalPrice': 55.0}, {'weight': '5kg', 'price': 230.0, 'originalPrice': 260.0}]},
    {'id': 'g23', 'name': 'Premium Chana Sattu', 'brand': 'Ganga', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '500g', 'price': 75.0, 'originalPrice': 90.0}, {'weight': '1kg', 'price': 140.0, 'originalPrice': 170.0}]},
    {'id': 'g36', 'name': 'Tata Salt', 'brand': 'Tata', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '1kg', 'price': 25.0, 'originalPrice': 28.0}]},
    {'id': 'g37', 'name': 'Maggi 2-Minute Noodles', 'brand': 'Nestlé', 'isBestseller': true, 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '70g', 'price': 14.0, 'originalPrice': 14.0}, {'weight': 'Pack of 4', 'price': 54.0, 'originalPrice': 56.0}]},
    {'id': 'g38', 'name': 'Everest Garam Masala', 'brand': 'Everest', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '100g', 'price': 75.0, 'originalPrice': 85.0}]},
  ],
  'Snacks & Drinks': [
    {'id': 'g16', 'name': 'Lay\'s Classic Salted Chips', 'brand': 'Lay\'s', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '50g', 'price': 20.0, 'originalPrice': 20.0}, {'weight': '100g', 'price': 40.0, 'originalPrice': 40.0}]},
    {'id': 'g17', 'name': 'Haldiram\'s Bhujia Sev', 'brand': 'Haldiram\'s', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '200g', 'price': 55.0, 'originalPrice': 60.0}, {'weight': '400g', 'price': 105.0, 'originalPrice': 115.0}]},
    {'id': 'g18', 'name': 'Coca Cola Soft Drink', 'brand': 'Coca Cola', 'image': 'assets/images/broccoli.png', 'isBestseller': true, 'variants': [{'weight': '750ml', 'price': 40.0, 'originalPrice': 45.0}, {'weight': '1.25 L', 'price': 65.0, 'originalPrice': 75.0}, {'weight': '2 L', 'price': 95.0, 'originalPrice': 110.0}]},
    {'id': 'g19', 'name': 'Oreo Chocolate Cookies', 'brand': 'Oreo', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '120g', 'price': 30.0, 'originalPrice': 35.0}, {'weight': '300g (Family Pack)', 'price': 80.0, 'originalPrice': 100.0}]},
    {'id': 'g20', 'name': 'Real Mixed Fruit Juice', 'brand': 'Real', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '200ml', 'price': 25.0, 'originalPrice': 30.0}, {'weight': '1 L', 'price': 110.0, 'originalPrice': 130.0}]},
    {'id': 'g39', 'name': 'Red Bull Energy Drink', 'brand': 'Red Bull', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '250ml', 'price': 125.0, 'originalPrice': 125.0}]},
    {'id': 'g40', 'name': 'Kurkure Masala Munch', 'brand': 'Kurkure', 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '90g', 'price': 20.0, 'originalPrice': 20.0}]},
    {'id': 'g41', 'name': 'Dairy Milk Silk', 'brand': 'Cadbury', 'isBestseller': true, 'image': 'assets/images/broccoli.png', 'variants': [{'weight': '60g', 'price': 80.0, 'originalPrice': 85.0}, {'weight': '150g', 'price': 175.0, 'originalPrice': 195.0}]},
  ]
};