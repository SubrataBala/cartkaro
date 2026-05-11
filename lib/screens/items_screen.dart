import 'package:flutter/material.dart';
import 'app_models.dart'; 
// ── NAYI FILE YAHAN SE IMPORT HOGI ──
import '../widgets/item_cards.dart'; 

class ItemsScreen extends StatefulWidget {
  final String categoryTitle;
  final int tabIndex;

  const ItemsScreen({super.key, required this.categoryTitle, required this.tabIndex});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  bool get _isDark => false; 
  Color get _bgColor => const Color(0xFFF8F9FA); 
  Color get _textColor => const Color(0xFF1A1A1A);
  Color get _iconColor => Colors.black;

  Color get _themeColor {
    if (widget.tabIndex == 1) return const Color(0xFFE53935); // Restaurant Red
    if (widget.tabIndex == 2) return const Color(0xFF1565C0); // Medical Blue
    return const Color(0xFF4CAF50); // Grocery Green
  }

  // Notifiers ab direct item_cards.dart me handle ho rahe hain, 
  // isliye yahan se cartNotifier nikal diya hai.

  List<Map<String, dynamic>> get _filteredItems {
    final tabData = globalAllCategoryData[widget.tabIndex] ?? {};
    List<Map<String, dynamic>> categoryItems = tabData[widget.categoryTitle] ?? [];
    
    if (_searchQuery.isEmpty) return categoryItems;
    return categoryItems.where((item) => item['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5, 
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: _iconColor, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text(widget.categoryTitle, style: TextStyle(color: _textColor, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 50, 
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: TextStyle(color: _textColor, fontSize: 14),
                textAlignVertical: TextAlignVertical.center, 
                decoration: InputDecoration(
                  isDense: true, contentPadding: EdgeInsets.zero, 
                  hintText: "Search in ${widget.categoryTitle}...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search_rounded, color: _themeColor, size: 22),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          
          Expanded(
            child: _filteredItems.isEmpty 
              ? Center(child: Text("No items available", style: TextStyle(color: _textColor.withOpacity(0.5), fontSize: 16)))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  physics: const ClampingScrollPhysics(), 
                  itemCount: _filteredItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, 
                    mainAxisSpacing: 16, 
                    crossAxisSpacing: 12, 
                    mainAxisExtent: 245, 
                  ),
                  itemBuilder: (context, index) {
                    
                    // ── YAHAN SMART SWITCHER KAAM KAREGA ──
                    return AdaptiveItemCard(
                      item: _filteredItems[index], 
                      tabIndex: widget.tabIndex,
                    );
                    
                  },
                ),
          ),
        ],
      ),
    );
  }
}