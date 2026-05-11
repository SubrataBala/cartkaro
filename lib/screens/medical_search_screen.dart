import 'package:flutter/material.dart';
import 'search_screen.dart'; 
import 'items_screen.dart';

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}

// --- MEDICAL PRODUCT MODEL ---
class MedicalProduct {
  final String id;
  final String name;
  final String category;
  final String deliveryTime;
  final double rating;
  final String ratingCount;
  final String image;
  final bool isBestseller;
  final List<Map<String, dynamic>> variants;

  MedicalProduct({
    required this.id, required this.name, required this.category, required this.deliveryTime,
    required this.rating, required this.ratingCount, required this.image, required this.variants,
    this.isBestseller = false,
  });
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
  // FULL MEDICAL DATA
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

  final List<SearchSection> _searchCategories = [
    SearchSection('Daily Medicines', [SearchCategoryItem('Fever & Pain', 'assets/images/broccoli.png'), SearchCategoryItem('Cold & Cough', 'assets/images/broccoli.png'), SearchCategoryItem('Digestion', 'assets/images/broccoli.png')]),
    SearchSection('Vitamins & Supplements', [SearchCategoryItem('Vitamin C', 'assets/images/broccoli.png'), SearchCategoryItem('Omega 3', 'assets/images/broccoli.png'), SearchCategoryItem('Multivitamins', 'assets/images/broccoli.png')]),
    SearchSection('First Aid Kits', [SearchCategoryItem('Bandages', 'assets/images/broccoli.png'), SearchCategoryItem('Antiseptics', 'assets/images/broccoli.png'), SearchCategoryItem('Cotton', 'assets/images/broccoli.png')]),
    SearchSection('Personal Care', [SearchCategoryItem('Skin Care', 'assets/images/broccoli.png'), SearchCategoryItem('Hair Care', 'assets/images/broccoli.png'), SearchCategoryItem('Baby Care', 'assets/images/broccoli.png')]),
  ];

  final List<String> _allSuggestions = ["Paracetamol", "Dolo 650", "Crocin", "Vicks", "Cough Syrup", "Band-Aid", "Vitamin C", "Thermometer", "Digene", "ORS", "Dettol", "Cotton", "Volini"];
  
  final List<MedicalProduct> _allProducts = [
    MedicalProduct(id: 'm_m1', name: 'Dolo 650 Tablet', category: 'Daily Medicines', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.9, ratingCount: '5k', isBestseller: true, variants: [{'weight': '15 Tabs', 'price': 30, 'mrp': 34, 'discount': 12}, {'weight': '30 Tabs', 'price': 58, 'mrp': 68, 'discount': 15}]),
    MedicalProduct(id: 'm_m2', name: 'Paracetamol 500mg', category: 'Daily Medicines', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.6, ratingCount: '12k', isBestseller: true, variants: [{'weight': '10 Tabs', 'price': 15, 'mrp': 18, 'discount': 16}, {'weight': '15 Tabs', 'price': 20, 'mrp': 25, 'discount': 20}]),
    MedicalProduct(id: 'm_m3', name: 'Crocin Advance', category: 'Daily Medicines', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.8, ratingCount: '8k', variants: [{'weight': '15 Tabs', 'price': 25, 'mrp': 28, 'discount': 10}]),
    MedicalProduct(id: 'm_m4', name: 'Vicks VapoRub', category: 'Daily Medicines', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.7, ratingCount: '9k', isBestseller: true, variants: [{'weight': '25g', 'price': 45, 'mrp': 50, 'discount': 10}, {'weight': '50g', 'price': 85, 'mrp': 100, 'discount': 15}]),
    MedicalProduct(id: 'm_m5', name: 'Honitus Cough Syrup', category: 'Daily Medicines', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.5, ratingCount: '4k', variants: [{'weight': '100ml', 'price': 90, 'mrp': 105, 'discount': 14}]),
    MedicalProduct(id: 'm_m6', name: 'Benadryl Syrup', category: 'Daily Medicines', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.6, ratingCount: '6k', variants: [{'weight': '150ml', 'price': 110, 'mrp': 130, 'discount': 15}]),
    MedicalProduct(id: 'm_m7', name: 'Digene Antacid', category: 'Daily Medicines', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.5, ratingCount: '7k', isBestseller: true, variants: [{'weight': '15 Tabs', 'price': 18, 'mrp': 22, 'discount': 18}, {'weight': '200ml Liquid', 'price': 115, 'mrp': 135, 'discount': 15}]),
    
    MedicalProduct(id: 'm_v1', name: 'Vitamin C Limcee', category: 'Vitamins & Supplements', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.8, ratingCount: '15k', isBestseller: true, variants: [{'weight': '15 Tabs', 'price': 22, 'mrp': 26, 'discount': 15}]),
    MedicalProduct(id: 'm_v2', name: 'Revital H', category: 'Vitamins & Supplements', image: 'assets/images/broccoli.png', deliveryTime: '25 MINS', rating: 4.6, ratingCount: '5k', variants: [{'weight': '30 Caps', 'price': 299, 'mrp': 350, 'discount': 14}]),
    MedicalProduct(id: 'm_v3', name: 'Shelcal 500', category: 'Vitamins & Supplements', image: 'assets/images/broccoli.png', deliveryTime: '25 MINS', rating: 4.7, ratingCount: '8k', variants: [{'weight': '15 Tabs', 'price': 110, 'mrp': 130, 'discount': 15}]),
    MedicalProduct(id: 'm_v4', name: 'ORS Sachet (Orange)', category: 'Vitamins & Supplements', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.8, ratingCount: '4k', isBestseller: true, variants: [{'weight': '5 Sachets', 'price': 100, 'mrp': 110, 'discount': 9}]),
    
    MedicalProduct(id: 'm_f1', name: 'Band-Aid Washproof', category: 'First Aid Kits', image: 'assets/images/broccoli.png', deliveryTime: '10 MINS', rating: 4.8, ratingCount: '10k', isBestseller: true, variants: [{'weight': '10 Strips', 'price': 20, 'mrp': 25, 'discount': 20}]),
    MedicalProduct(id: 'm_f2', name: 'Surgical Cotton', category: 'First Aid Kits', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.5, ratingCount: '3k', variants: [{'weight': '100g', 'price': 50, 'mrp': 60, 'discount': 16}]),
    MedicalProduct(id: 'm_f3', name: 'Dettol Liquid', category: 'First Aid Kits', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.9, ratingCount: '20k', isBestseller: true, variants: [{'weight': '125ml', 'price': 65, 'mrp': 75, 'discount': 13}, {'weight': '250ml', 'price': 110, 'mrp': 130, 'discount': 15}]),
    MedicalProduct(id: 'm_f4', name: 'Savlon Liquid', category: 'First Aid Kits', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.7, ratingCount: '6k', variants: [{'weight': '200ml', 'price': 95, 'mrp': 115, 'discount': 17}]),
    MedicalProduct(id: 'm_f5', name: 'Digital Thermometer', category: 'First Aid Kits', image: 'assets/images/broccoli.png', deliveryTime: '25 MINS', rating: 4.5, ratingCount: '5k', variants: [{'weight': '1 pc', 'price': 180, 'mrp': 250, 'discount': 28}]),
    
    MedicalProduct(id: 'm_p1', name: 'Volini Pain Relief Gel', category: 'Personal Care', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.6, ratingCount: '11k', isBestseller: true, variants: [{'weight': '30g', 'price': 115, 'mrp': 135, 'discount': 14}, {'weight': '50g', 'price': 160, 'mrp': 190, 'discount': 15}]),
    MedicalProduct(id: 'm_p2', name: 'Moov Pain Relief Spray', category: 'Personal Care', image: 'assets/images/broccoli.png', deliveryTime: '20 MINS', rating: 4.5, ratingCount: '8k', variants: [{'weight': '50g', 'price': 145, 'mrp': 170, 'discount': 14}]),
    MedicalProduct(id: 'm_p3', name: 'Cetirizine 10mg', category: 'Personal Care', image: 'assets/images/broccoli.png', deliveryTime: '15 MINS', rating: 4.6, ratingCount: '6k', variants: [{'weight': '10 Tabs', 'price': 18, 'mrp': 22, 'discount': 18}]),
  ];

  void _onSearchSubmit(String val) {
    if (val.isEmpty) return;
    setState(() { _query = val; _searchController.text = val; _showResults = true; });
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
              Expanded(child: _searchController.text.isEmpty ? _buildDefaultView() : _showResults ? _buildResultsView() : _buildSuggestionsView()),
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
    final filtered = _allSuggestions.where((item) => item.toLowerCase().contains(_query.toLowerCase())).toList();
    if(filtered.isEmpty) return Center(child: Text("No items found", style: TextStyle(color: _textSecondary)));
    return ListView.builder(itemCount: filtered.length, itemBuilder: (context, index) => ListTile(leading: const Icon(Icons.search, color: Colors.grey, size: 20), title: Text(filtered[index], style: const TextStyle(fontWeight: FontWeight.w600)), onTap: () => _onSearchSubmit(filtered[index])));
  }

  Widget _buildResultsView() {
    final results = _allProducts.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();
    List<MedicalProduct> related = [];
    if (results.isNotEmpty) {
      String matchedCat = results.first.category;
      related = _allProducts.where((p) => p.category == matchedCat && !results.contains(p)).take(6).toList();
    } else {
      related = _allProducts.take(6).toList();
    }

    return Column(
      children: [
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(20, 8, 20, 16), child: Row(children: ['Filters', 'Sort', 'Brand', 'Price'].map((f) => Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)), child: Row(children: [Text(f, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const SizedBox(width: 4), const Icon(Icons.keyboard_arrow_down, size: 16)]))).toList())),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16), shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 12, mainAxisExtent: 260),
                  itemCount: results.length, itemBuilder: (context, index) => SearchMedicalCard(product: results[index], themeColor: _themeColor), 
                ),
                if (related.isNotEmpty) ...[
                  const Padding(padding: EdgeInsets.fromLTRB(20, 30, 20, 16), child: Text("Frequently bought together", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 12, mainAxisExtent: 260),
                    itemCount: related.length, itemBuilder: (context, index) => SearchMedicalCard(product: related[index], themeColor: _themeColor),
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

// MEDICAL CARD WIDGET
class SearchMedicalCard extends StatefulWidget {
  final MedicalProduct product;
  final Color themeColor;
  const SearchMedicalCard({super.key, required this.product, required this.themeColor});

  @override
  State<SearchMedicalCard> createState() => _SearchMedicalCardState();
}

class _SearchMedicalCardState extends State<SearchMedicalCard> {
  int _selectedVariantIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final currentVariant = product.variants[_selectedVariantIndex];
    final String cartItemId = "${product.id}|$_selectedVariantIndex";

    int price = int.parse(currentVariant['price'].toString());
    int mrp = int.parse(currentVariant['mrp'].toString());
    int discount = int.parse(currentVariant['discount'].toString());

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(height: 90, decoration: const BoxDecoration(color: Color(0xFFE3F2FD), borderRadius: BorderRadius.vertical(top: Radius.circular(12))), child: Center(child: Image.asset(product.image, height: 60, errorBuilder: (_,__,___) => Text('💊', style: TextStyle(fontSize: 40))))),
              Positioned(top: 6, left: 6, child: ValueListenableBuilder(valueListenable: watchlistNotifier, builder: (context, Set<String> favs, _) { final isFav = favs.contains(product.id); return GestureDetector(onTap: () { var newFavs = Set<String>.from(favs); isFav ? newFavs.remove(product.id) : newFavs.add(product.id); watchlistNotifier.value = newFavs; }, child: Icon(isFav ? Icons.bookmark : Icons.bookmark_border_rounded, color: isFav ? widget.themeColor : Colors.grey, size: 20)); })),
              if (product.isBestseller) Positioned(bottom: 0, left: 0, right: 0, child: Container(color: widget.themeColor, padding: const EdgeInsets.symmetric(vertical: 2), child: const Center(child: Text('Bestseller', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Container(height: 24, padding: const EdgeInsets.symmetric(horizontal: 4), decoration: BoxDecoration(color: const Color(0xFFF8F9FA), border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)), child: DropdownButtonHideUnderline(child: DropdownButton<int>(isExpanded: true, value: _selectedVariantIndex, icon: Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.grey.shade600), dropdownColor: Colors.white, style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w600), items: product.variants.asMap().entries.map((e) => DropdownMenuItem<int>(value: e.key, child: Text(e.value['weight']))).toList(), onChanged: (val) => setState(() => _selectedVariantIndex = val!)))),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(product.deliveryTime, style: TextStyle(fontSize: 8, color: Colors.grey.shade500, fontWeight: FontWeight.w800)), Row(children: [Icon(Icons.star, size: 10, color: Colors.green.shade600), const SizedBox(width: 2), Text('${product.rating} (${product.ratingCount})', style: const TextStyle(fontSize: 8, color: Colors.black87, fontWeight: FontWeight.bold))])]),
                  if (discount > 0) Text('$discount% OFF', style: TextStyle(color: widget.themeColor, fontSize: 9, fontWeight: FontWeight.bold)) else const Text('', style: TextStyle(fontSize: 9)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('₹$price', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)), if (discount > 0) Text('₹$mrp', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 9))]),
                      ValueListenableBuilder(
                        valueListenable: medicalCartNotifier,
                        builder: (context, Map<String, int> counts, _) {
                          final count = counts[cartItemId] ?? 0;
                          if (count == 0) return GestureDetector(onTap: () { var current = {...medicalCartNotifier.value}; current[cartItemId] = 1; medicalCartNotifier.value = current; }, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: widget.themeColor, width: 1.2), borderRadius: BorderRadius.circular(6)), child: Text('ADD', style: TextStyle(color: widget.themeColor, fontWeight: FontWeight.w900, fontSize: 10))));
                          return Container(decoration: BoxDecoration(color: widget.themeColor, borderRadius: BorderRadius.circular(6)), child: Row(mainAxisSize: MainAxisSize.min, children: [GestureDetector(onTap: () { var current = {...medicalCartNotifier.value}; current[cartItemId] = (current[cartItemId] ?? 0) - 1; if (current[cartItemId]! <= 0) current.remove(cartItemId); medicalCartNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4), child: Text('-', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))), Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)), GestureDetector(onTap: () { var current = {...medicalCartNotifier.value}; current[cartItemId] = (current[cartItemId] ?? 0) + 1; medicalCartNotifier.value = current; }, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4), child: Text('+', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))))]));
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}