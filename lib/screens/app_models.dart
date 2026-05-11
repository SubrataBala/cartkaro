import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ── NAYI DATA FILES KA LINK ──
import 'grocery_data.dart';
import 'restaurant_data.dart';
import 'medical_data.dart';

// ── 1. COLORS & UI MODELS ──
const Color kGroceryGreen  = Color(0xFF4CAF50); 
const Color kRestaurantRed = Color(0xFFE53935);
const Color kMedicalBlue   = Color(0xFF1565C0);

class TabData { final String label; final Color color; final IconData icon; const TabData(this.label, this.color, this.icon); }
class BannerData { final String title, subtitle; final Color bgColor; final String imagePath; final bool isLightBanner; const BannerData(this.title, this.subtitle, this.bgColor, this.imagePath, {this.isLightBanner = false}); }
class SpotlightItem { final String title, imagePath; final Color bgColor, textColor; const SpotlightItem(this.title, this.imagePath, this.bgColor, this.textColor); }
class GridSectionData { final String title; final List<CategoryItem> items; const GridSectionData(this.title, this.items); }
class CategoryItem { final String label, imagePath; const CategoryItem(this.label, this.imagePath); }
class StoreItem { final String label, imagePath; final Color bgColor; const StoreItem(this.label, this.imagePath, this.bgColor); }
class NavItem { final IconData icon; final String label; const NavItem(this.icon, this.label); }

// ── 2. CART & WATCHLIST STATE NOTIFIERS (YEHI DELETE HO GAYE THE!) ──
ValueNotifier<Map<String, int>> groceryCartNotifier = ValueNotifier<Map<String, int>>({});
ValueNotifier<Map<String, int>> restaurantCartNotifier = ValueNotifier<Map<String, int>>({});
ValueNotifier<Map<String, int>> medicalCartNotifier = ValueNotifier<Map<String, int>>({});
ValueNotifier<Set<String>> watchlistNotifier = ValueNotifier<Set<String>>({});

// ── 3. PRODUCT DATA DICTIONARY ──
Map<int, Map<String, List<Map<String, dynamic>>>> globalAllCategoryData = {
  0: groceryData,     // Data coming from grocery_data.dart
  1: restaurantData,  // Data coming from restaurant_data.dart
  2: medicalData,     // Data coming from medical_data.dart
};

// ── 4. REAL-TIME DATA PERSISTENCE LOGIC (MEMORY SAVE/LOAD) ──
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