import 'package:flutter/material.dart';
import 'items_screen.dart'; // Iski zaroorat pad sakti hai navigation ke liye
import 'app_models.dart';   
import '../widgets/item_cards.dart'; // ── MAIN FIX: Naya AdaptiveItemCard yahan se aayega ──

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

// ── Search UI ke liye simple class ──
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

  // ── Single Sky Blue color ──
  final Color _singleSkyBlue = const Color(0xFFE3F2FD); 

  // ==========================================
  // 1. PAST SEARCHES
  // ==========================================
  final List<Map<String, dynamic>> _pastSearches = [
    {'label': 'Paracetamol', 'icon': Icons.medication},
    {'label': 'Vicks', 'icon': Icons.healing},
    {'label': 'Cough Syrup', 'icon': Icons.local_drink},
    {'label': 'Band-Aid', 'icon': Icons.medical_services},
    {'label': 'Vitamin C', 'icon': Icons.health_and_safety},
    {'label': 'Thermometer', 'icon': Icons.thermostat},
    {'label': 'Digene', 'icon': Icons.science},
    {'label': 'ORS', 'icon': Icons.water_drop},
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
  // 3. MASTER DATA FETCHER 
  // ==========================================
  List<Map<String, dynamic>> get _allMedicalItems {
    List<Map<String, dynamic>> allItems = [];
    final medicalMap = globalAllCategoryData[2] ?? {}; // 2 is Medical Tab
    
    medicalMap.forEach((categoryName, items) {
      for (var item in items) {
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

  // =========================================================================
  // 🔥 DEFAULT VIEW (Clinical & Sleek List Layout)
  // =========================================================================
  Widget _buildDefaultView() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildPastSearches(),
          const SizedBox(height: 30),
          ..._buildSearchCategoryRows(),
        ],
      ),
    );
  }

  Widget _buildPastSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Previously Searched', style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: -0.2)),
              Text('CLEAR', style: TextStyle(color: _themeColor, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
            ],
          )
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _pastSearches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (ctx, i) => _buildSearchChip(_pastSearches[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchChip(Map<String, dynamic> search) {
    return GestureDetector(
      onTap: () => _onSearchSubmit(search['label']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Icon(search['icon'], color: _themeColor, size: 14), 
            const SizedBox(width: 6), 
            Text(search['label'], style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchCategoryRows() {
    List<Widget> rows = [];

    for (var section in _searchCategories) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(section.title, style: TextStyle(color: _textPrimary, fontSize: 17, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
            ],
          ),
        )
      );
      rows.add(const SizedBox(height: 12));
      rows.add(
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: section.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (ctx, i) {
            final c = section.items[i];
            return GestureDetector(
              onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => ItemsScreen(categoryTitle: section.title, tabIndex: 2))); },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: _singleSkyBlue, 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(c.imagePath, width: 24, height: 24, fit: BoxFit.contain, errorBuilder: (_,__,___) => Icon(Icons.medical_services, size: 20, color: _themeColor)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(c.label, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 20),
                  ],
                ),
              ),
            );
          },
        )
      );
      rows.add(const SizedBox(height: 28));
    }
    return rows;
  }

  // =========================================================================
  // SEARCH RESULTS VIEW 
  // =========================================================================

  Widget _buildSuggestionsView() {
    final filtered = _allMedicalItems
        .where((item) => item['name'].toString().toLowerCase().contains(_query.toLowerCase()))
        .map((item) => item['name'].toString())
        .toSet() 
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
    final results = _allMedicalItems.where((p) => p['name'].toString().toLowerCase().contains(_query.toLowerCase())).toList();
    
    List<Map<String, dynamic>> related = [];
    if (results.isNotEmpty) {
      String matchedCategory = results.first['category']; 
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
                    mainAxisExtent: 245 
                  ),
                  itemCount: results.length,
                  // ── MAIN FIX: Calling AdaptiveItemCard for Medical Tab (Tab 2) ──
                  itemBuilder: (context, index) => AdaptiveItemCard(
                    item: results[index], 
                    tabIndex: 2, 
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
                    itemBuilder: (context, index) => AdaptiveItemCard(
                      item: related[index], 
                      tabIndex: 2, 
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