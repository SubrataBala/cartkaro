import 'package:flutter/material.dart';

class SharedFilterRow extends StatelessWidget {
  final int tabIndex; // 0: Grocery, 1: Restaurant, 2: Medical
  final String activeSort;
  final Function(String sortType) onSortChanged; // Sort apply karne ke liye callback

  const SharedFilterRow({
    super.key,
    required this.tabIndex,
    required this.activeSort,
    required this.onSortChanged,
  });

  // ── 1. DYNAMIC THEME COLOR ──
  Color get _themeColor {
    if (tabIndex == 1) return const Color(0xFFE53935); // Red for Restaurant
    if (tabIndex == 2) return const Color(0xFF1565C0); // Blue for Medical
    return const Color(0xFF4CAF50); // Green for Grocery
  }

  // ── 2. DYNAMIC CHIPS BASED ON TAB INDEX ──
  List<String> get _filterChips {
    if (tabIndex == 1) return ['Sort', 'Veg/Non-Veg', 'Distance', 'Rating']; // Restaurant
    if (tabIndex == 2) return ['Sort', 'Form', 'Brand', 'Rating']; // Medical
    return ['Sort', 'Quantity', 'Price', 'Brand', 'Rating', 'Discount']; // Grocery
  }

  // ── 3. BOTTOM SHEET FOR "ALL FILTERS" ──
  void _openAllFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All Filters', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx))
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: _filterChips.map((filterName) => ListTile(
                  title: Text(filterName, style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {
                    // Future logic for individual detailed filters
                  },
                )).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _themeColor, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          // ── MAIN "FILTERS" BUTTON ──
          GestureDetector(
            onTap: () => _openAllFiltersSheet(context),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _themeColor.withOpacity(0.1),
                border: Border.all(color: _themeColor),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Row(
                children: [
                  Icon(Icons.tune, size: 14, color: _themeColor),
                  const SizedBox(width: 4),
                  Text('Filters', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _themeColor)),
                ],
              ),
            ),
          ),

          // ── DYNAMIC HORIZONTAL CHIPS ──
          ..._filterChips.map((f) {
            bool isActive = false;
            // Sorting logic example
            if (f == 'Price' && (activeSort == 'Price: Low to High' || activeSort == 'Price: High to Low')) isActive = true;
            if (f == 'Sort' && activeSort != '') isActive = true;

            return GestureDetector(
              onTap: () {
                if (f == 'Price') {
                  onSortChanged(activeSort == 'Price: Low to High' ? 'Price: High to Low' : 'Price: Low to High');
                } else {
                  // Additional simple logic for other chips
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$f filter selected!'), duration: const Duration(milliseconds: 500)));
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? _themeColor.withOpacity(0.1) : Colors.white,
                  border: Border.all(color: isActive ? _themeColor : Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    Text(
                      (f == 'Price' && isActive) ? activeSort : f, 
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isActive ? _themeColor : const Color(0xFF1A1A1A))
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: isActive ? _themeColor : const Color(0xFF757575))
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}