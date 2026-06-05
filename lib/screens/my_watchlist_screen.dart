import 'package:flutter/material.dart';
import 'watchlist_tab.dart'; 

class MyWatchlistScreen extends StatelessWidget {
  final Color themeColor;
  final int selectedTab; // 0 for Grocery, 1 for Restaurant, 2 for Medical

  const MyWatchlistScreen({
    super.key, 
    required this.themeColor,
    required this.selectedTab, 
  });

  // Dynamic heading based on the selected tab
  String get _tabName {
    if (selectedTab == 1) return 'Restaurant';
    if (selectedTab == 2) return 'Medical';
    return 'Grocery';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        // Title ab dynamic ho gaya
        title: Text('$_tabName Watchlist', style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      // Seedha wahi tab dikhayenge jo profile se open hua hai
      body: WatchlistTab(selectedTab: selectedTab), 
    );
  }
}