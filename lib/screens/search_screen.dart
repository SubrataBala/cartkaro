import 'package:flutter/material.dart';
import 'grocery_search_screen.dart';
import 'restaurant_search_screen.dart';
import 'medical_search_screen.dart';

// --- COMMON MODELS FOR CATEGORIES ---
class SearchCategoryItem {
  final String label;
  final String imagePath;
  SearchCategoryItem(this.label, this.imagePath);
}

class SearchSection {
  final String title;
  final List<SearchCategoryItem> items;
  SearchSection(this.title, this.items);
}

// NO JELLY EFFECT BEHAVIOR
class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class SearchScreen extends StatelessWidget {
  final int initialTab; 
  const SearchScreen({super.key, required this.initialTab});

  @override
  Widget build(BuildContext context) {
    // Tab ke hisaab se sahi file open karega
    if (initialTab == 0) {
      return const GrocerySearchScreen();
    } else if (initialTab == 1) {
      return const RestaurantSearchScreen();
    } else {
      return const MedicalSearchScreen();
    }
  }
}