import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ── DATA FILES IMPORT ──
import 'grocery_data.dart';
import 'restaurant_data.dart';
import 'medical_data.dart';

// ==========================================
// 1. COLORS & UI MODELS
// ==========================================
const Color kGroceryGreen  = Color(0xFF4CAF50); 
const Color kRestaurantRed = Color(0xFFE53935);
const Color kMedicalBlue   = Color(0xFF1565C0);

class TabData { 
  final String label; 
  final Color color; 
  final IconData icon; 
  const TabData(this.label, this.color, this.icon); 
}

class BannerData { 
  final String title, subtitle; 
  final Color bgColor; 
  final String imagePath; 
  final bool isLightBanner; 
  const BannerData(this.title, this.subtitle, this.bgColor, this.imagePath, {this.isLightBanner = false}); 
}

class SpotlightItem { 
  final String title, imagePath; 
  final Color bgColor, textColor; 
  const SpotlightItem(this.title, this.imagePath, this.bgColor, this.textColor); 
}

class GridSectionData { 
  final String title; 
  final List<CategoryItem> items; 
  const GridSectionData(this.title, this.items); 
}

class CategoryItem { 
  final String label, imagePath; 
  const CategoryItem(this.label, this.imagePath); 
}

class StoreItem { 
  final String label, imagePath; 
  final Color bgColor; 
  const StoreItem(this.label, this.imagePath, this.bgColor); 
}

class NavItem { 
  final IconData icon; 
  final String label; 
  const NavItem(this.icon, this.label); 
}

// ==========================================
// 2. CART & WATCHLIST STATE NOTIFIERS
// ==========================================
ValueNotifier<Map<String, int>> groceryCartNotifier = ValueNotifier<Map<String, int>>({});
ValueNotifier<Map<String, int>> restaurantCartNotifier = ValueNotifier<Map<String, int>>({});
ValueNotifier<Map<String, int>> medicalCartNotifier = ValueNotifier<Map<String, int>>({});
ValueNotifier<Set<String>> watchlistNotifier = ValueNotifier<Set<String>>({});

// ==========================================
// 3. GLOBAL PRODUCT DATA DICTIONARY
// ==========================================
Map<int, Map<String, List<Map<String, dynamic>>>> globalAllCategoryData = {
  0: groceryData,     // Data coming from grocery_data.dart
  1: restaurantData,  // Data coming from restaurant_data.dart
  2: medicalData,     // Data coming from medical_data.dart
};

// ==========================================
// 4. REAL-TIME DATA PERSISTENCE (MEMORY SAVE/LOAD)
// ==========================================
Future<void> loadAppData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // Load Carts
  String? gCart = prefs.getString('groceryCart');
  if (gCart != null) groceryCartNotifier.value = Map<String, int>.from(jsonDecode(gCart));
  
  String? rCart = prefs.getString('restaurantCart');
  if (rCart != null) restaurantCartNotifier.value = Map<String, int>.from(jsonDecode(rCart));
  
  String? mCart = prefs.getString('medicalCart');
  if (mCart != null) medicalCartNotifier.value = Map<String, int>.from(jsonDecode(mCart));
  
  // Load Watchlist
  String? wList = prefs.getString('watchlist');
  if (wList != null) {
    watchlistNotifier.value = (jsonDecode(wList) as List).map((e) => e.toString()).toSet();
  }

  // Auto-Save Listeners
  groceryCartNotifier.addListener(() { prefs.setString('groceryCart', jsonEncode(groceryCartNotifier.value)); });
  restaurantCartNotifier.addListener(() { prefs.setString('restaurantCart', jsonEncode(restaurantCartNotifier.value)); });
  medicalCartNotifier.addListener(() { prefs.setString('medicalCart', jsonEncode(medicalCartNotifier.value)); });
  watchlistNotifier.addListener(() { prefs.setString('watchlist', jsonEncode(watchlistNotifier.value.toList())); });
}

// ==========================================
// 5. VENDOR RESTAURANT LOGIC
// ==========================================

// Data passing model for Restaurants
class VendorRestaurant {
  final String id;
  final String name;
  final String categories;
  final String rating;
  final String time;
  final String distance;
  final String totalSells;
  final String imagePath;
  final List<Map<String, dynamic>> menu; 

  VendorRestaurant({
    required this.id, 
    required this.name, 
    required this.categories,
    required this.rating, 
    required this.time, 
    required this.distance,
    required this.totalSells, 
    required this.imagePath, 
    required this.menu,
  });
}

// Smart Global Restaurants getter
// Automatically parses restaurantData and groups items into menus per restaurant
List<VendorRestaurant> get globalRestaurants {
  List<VendorRestaurant> resList = [];
  Set<String> addedRes = {};

  restaurantData.forEach((category, items) {
    for (var item in items) {
      String resName = item['restaurant'] ?? 'Unknown Restaurant';
      
      if (!addedRes.contains(resName)) {
        addedRes.add(resName);
        
        // Find all items belonging to this specific restaurant across all categories
        List<Map<String, dynamic>> resMenu = [];
        restaurantData.forEach((cat, itms) {
          resMenu.addAll(itms.where((i) => i['restaurant'] == resName));
        });

        resList.add(VendorRestaurant(
          id: resName, 
          name: resName,
          categories: category, // You could also dynamically map categories based on menu items here
          rating: item['rating'] ?? '4.5',
          time: item['time'] ?? '30 Mins',
          distance: item['distance'] ?? '2.0 km',
          totalSells: item['totalSells'] ?? '1K+ orders',
          imagePath: item['image'] ?? 'assets/images/broccoli.png', // Fallback image
          menu: resMenu, 
        ));
      }
    }
  });
  
  return resList;
}