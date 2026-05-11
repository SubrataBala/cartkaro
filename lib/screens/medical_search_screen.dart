import 'package:flutter/material.dart';
import 'items_screen.dart'; // ── Yahan se PremiumItemCard aayega ──
import 'app_models.dart';   // ── Yahan se Notifiers aur Data aayega ──

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

// ── Search UI ke liye simple class (sirf pastel boxes ke liye) ──
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

class MedicalSearchScreen extends StatefulWidget {
  const MedicalSearchScreen({super.key});

  @override
  State<MedicalSearchScreen> createState() => _MedicalSearchScreenState();
}

class _MedicalSearchScreenState extends State<MedicalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _showResults = false;

  bool get isDark => false; 
  Color get _bgColor => const Color(0xFFF8F9FA); 
  Color get _searchBgColor => Colors.white;
  Color get _textPrimary => const Color(0xFF1A1A1A); 
  Color get _textSecondary => const Color(0xFF757575);
  Color get _borderColor => Colors.grey.withOpacity(0.15);
  final Color _themeColor = const Color(0xFF1565C0); // Medical Blue

  final List<Color> _pastelColors = [
    const Color(0xFFBBDEFB), const Color(0xFFC8E6C9), const Color(0xFFFFCCBC),
    const Color(0xFFD1C4E9), const Color(0xFFF8BBD0), const Color(0xFFFFF9C4),
  ];

  // ==========================================
  // 1. PAST SEARCHES
  // ==========================================
  final List<Map<String, dynamic>> _pastSearches = [
    {'label': 'Paracetamol', 'icon': Icons.medication, 'color': const Color(0xFFBBDEFB)},
    {'label': 'Vicks', 'icon': Icons.healing, 'color': const Color(0xFFC8E6C9)},
    {'label': 'Cough Syrup', 'icon': Icons.local_drink, 'color': const Color(0xFFFFCCBC)},
    {'label': 'Band-Aid', 'icon': Icons.medical_services, 'color': const Color(0xFFD1C4E9)},
    {'label': 'Vitamin C', 'icon': Icons.health_and_safety, 'color': const Color(0xFFF8BBD0)},
    {'label': 'Thermometer', 'icon': Icons.thermostat, 'color': const Color(0xFFFFF9C4)},
    {'label': 'Digene', 'icon': Icons.science, 'color': const Color(0xFFFFE082)},
    {'label': 'ORS', 'icon': Icons.water_drop, 'color': const Color(0xFFE1BEE7)},
  ];

  // ==========================================
  // 2. CATEGORY BOXES UI
  // ==========================================
  final List<SearchSection> _searchCategories = [
    SearchSection('Daily Medicines', [SearchCategoryItem('Fever & Pain', 'assets/images/broccoli.png'), SearchCategoryItem('Cold & Cough', 'assets/images/broccoli.png'), SearchCategoryItem('Digestion', 'assets/images/broccoli.png')]),
    SearchSection('Vitamins & Supplements', [SearchCategoryItem('Vitamin C', 'assets/images/broccoli.png'), SearchCategoryItem('Omega 3', 'assets/images/broccoli.png'), SearchCategoryItem('Multivitamins', 'assets/images/broccoli.png')]),
    SearchSection('First Aid Kits', [SearchCategoryItem('Bandages', 'assets/images/broccoli.png'), SearchCategoryItem('Antiseptics', 'assets/images/broccoli.png'), SearchCategoryItem('Cotton', 'assets/images/broccoli.png')]),
    SearchSection('Personal Care', [SearchCategoryItem('Skin Care', 'assets/images/broccoli.png'), SearchCategoryItem('Hair Care', 'assets/images/broccoli.png'), SearchCategoryItem('Baby Care', 'assets/images/broccoli.png')]),
  ];

  // ==========================================
  // 3. MASTER DATA FETCHER (Reads directly from medical_data.dart via app_models)
  // ==========================================
  List<Map<String, dynamic>> get _allMedicalItems {
    List<Map<String, dynamic>> allItems = [];
    final medicalMap = globalAllCategoryData[2] ?? {}; // 2 is Medical Tab
    
    medicalMap.forEach((categoryName, items) {
      for (var item in items) {
        // Create a copy and inject the category name for 'Related Products' logic
        var itemCopy = Map<String, dynamic>.from(item);
        itemCopy['category'] = categoryName; 
        allItems.add(itemCopy);
      }
    });
    return allItems;
  }

  void _onSearchSubmit(String val) {
    if (val.isEmpty) return;
    setState(() {
      _query = val;
      _searchController.text = val;
      _showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: NoJellyScrollBehavior(),
          child: Column(
            children: [
              _buildSearchHeader(),
              Expanded(
                child: _searchController.text.isEmpty
                    ? _buildDefaultView()      
                    : _showResults 
                        ? _buildResultsView()  
                        : _buildSuggestionsView(), 
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _searchBgColor, shape: BoxShape.circle, border: Border.all(color: _borderColor)), child: Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 20))),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50, decoration: BoxDecoration(color: _searchBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(child: TextField(controller: _searchController, autofocus: true, onChanged: (v) { setState(() { _query = v; _showResults = false; }); }, onSubmitted: _onSearchSubmit, style: TextStyle(color: _textPrimary, fontSize: 15), decoration: InputDecoration(hintText: 'Search medicines...', hintStyle: TextStyle(color: _textSecondary, fontSize: 14), border: InputBorder.none))),
                  if (_searchController.text.isNotEmpty) GestureDetector(onTap: () { _searchController.clear(); setState(() { _query = ''; _showResults = false; }); }, child: Icon(Icons.close_rounded, color: _textSecondary, size: 22)) else Icon(Icons.mic_none_rounded, color: _textSecondary, size: 22),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultView() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('YOUR PAST SEARCHES', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2))),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, physics: const ClampingScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: _pastSearches.sublist(0, 4).map((search) => _buildSearchChip(search)).toList()), const SizedBox(height: 10), Row(children: _pastSearches.sublist(4).map((search) => _buildSearchChip(search)).toList())]),
          ),
          const SizedBox(height: 30),
          ..._searchCategories.map((section) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(section.title, style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)), GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ItemsScreen(categoryTitle: section.title, tabIndex: 2))), child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle), child: const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.black, size: 20)))])),
              const SizedBox(height: 16),
              SizedBox(height: 110, child: ListView.separated(scrollDirection: Axis.horizontal, physics: const ClampingScrollPhysics(), padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: section.items.length, separatorBuilder: (_, __) => const SizedBox(width: 14), itemBuilder: (ctx, i) => GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ItemsScreen(categoryTitle: section.title, tabIndex: 2))), child: Container(width: 115, decoration: BoxDecoration(color: _pastelColors[i % _pastelColors.length], borderRadius: BorderRadius.circular(16)), child: Stack(children: [Positioned(top: 10, left: 12, child: Text(section.items[i].label, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w800))), Positioned(bottom: -5, right: -5, child: Image.asset(section.items[i].imagePath, height: 80, width: 80, fit: BoxFit.contain, errorBuilder: (_,__,___) => const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.medical_services, size: 40, color: Colors.black26))))]))))),
              const SizedBox(height: 32),
            ]
          )),
        ],
      ),
    );
  }

  Widget _buildSearchChip(Map<String, dynamic> search) {
    return GestureDetector(onTap: () => _onSearchSubmit(search['label']), child: Container(margin: const EdgeInsets.only(right: 10), height: 38, padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: search['color'], borderRadius: BorderRadius.circular(20)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(search['icon'], color: Colors.black87, size: 16), const SizedBox(width: 6), Text(search['label'], style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w700))])));
  }

  Widget _buildSuggestionsView() {
    // Dynamic suggestions based on actual global data
    final filtered = _allMedicalItems
        .where((item) => item['name'].toString().toLowerCase().contains(_query.toLowerCase()))
        .map((item) => item['name'].toString())
        .toSet() // Removes duplicates
        .toList();

    if(filtered.isEmpty) return Center(child: Text("No items found", style: TextStyle(color: _textSecondary)));
    
    return ListView.builder(
      itemCount: filtered.length, 
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.search, color: Colors.grey, size: 20), 
        title: Text(filtered[index], style: const TextStyle(fontWeight: FontWeight.w600)), 
        onTap: () => _onSearchSubmit(filtered[index])
      )
    );
  }

  Widget _buildResultsView() {
    // Fetch actual matching products from global data
    final results = _allMedicalItems.where((p) => p['name'].toString().toLowerCase().contains(_query.toLowerCase())).toList();
    
    // --- SMART RELATED PRODUCTS LOGIC ---
    List<Map<String, dynamic>> related = [];
    if (results.isNotEmpty) {
      String matchedCategory = results.first['category']; // E.g., 'Daily Medicines'
      related = _allMedicalItems.where((p) => p['category'] == matchedCategory && p['id'] != results.first['id']).take(6).toList();
    } else {
      related = _allMedicalItems.take(6).toList();
    }

    return Column(
      children: [
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(20, 8, 20, 16), child: Row(children: ['Filters', 'Sort', 'Quantity', 'Price'].map((f) => Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)), child: Row(children: [Text(f, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const SizedBox(width: 4), const Icon(Icons.keyboard_arrow_down, size: 16)]))).toList())),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, 
                    mainAxisSpacing: 16, 
                    crossAxisSpacing: 12, 
                    mainAxisExtent: 245 // Match with PremiumItemCard height
                  ),
                  itemCount: results.length,
                  // ── MAIN FIX: Reusing the same PremiumItemCard here ──
                  itemBuilder: (context, index) => PremiumItemCard(
                    item: results[index], 
                    isDark: false, 
                    themeColor: _themeColor, 
                    cartNotifier: medicalCartNotifier // Passing medical cart
                  ), 
                ),
                
                if (related.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 16), child: Text("Frequently bought together", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 12, mainAxisExtent: 245, 
                    ),
                    itemCount: related.length,
                    itemBuilder: (context, index) => PremiumItemCard(
                      item: related[index], 
                      isDark: false, 
                      themeColor: _themeColor, 
                      cartNotifier: medicalCartNotifier // Passing medical cart
                    ),
                  ),
                  const SizedBox(height: 30),
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}