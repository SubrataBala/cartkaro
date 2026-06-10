import 'dart:async';
import 'package:flutter/material.dart';
import 'app_models.dart';
import '../widgets/adaptive_item_card.dart';

class RestaurantMenuScreen extends StatefulWidget {
  final VendorRestaurant restaurant;
  const RestaurantMenuScreen({super.key, required this.restaurant});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Filter States
  String _searchQuery         = '';
  bool   _isVegActive         = false;
  bool   _isNonVegActive      = false;
  bool   _isFavorite          = false;
  bool   _isBestsellerActive  = false;
  bool   _isRating4PlusActive = false;
  bool   _isDiscountActive    = false;

  final PageController _offerPageCtrl = PageController();
  int    _currentOfferPage = 0;
  Timer? _offerTimer;

  // The rich, deep dark color for the top section
  final Color _topDarkBgColor = const Color(0xFF0F1014);

  final List<Map<String, String>> _offers = [
    {'code': 'ICICIAPAY', 'label': 'FLAT 5% OFF',      'sub': 'USE ICICIAPAY | ABOVE ₹299'},
    {'code': 'NEWUSER',   'label': '10% OFF UPTO ₹40', 'sub': 'FOR NEW USERS'},
    {'code': 'FREEDEL',   'label': 'FREE DELIVERY',    'sub': 'ON ORDERS ABOVE ₹49'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });
    _offerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_offerPageCtrl.hasClients || _offers.isEmpty) return;
      _offerPageCtrl.animateToPage(
        (_currentOfferPage + 1) % _offers.length,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _offerTimer?.cancel();
    _searchController.dispose();
    _offerPageCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredMenu() {
    return widget.restaurant.menu.where((item) {
      // 1. Search Query Match
      final name = (item['name']        as String? ?? '').toLowerCase();
      final desc = (item['description'] as String? ?? '').toLowerCase();
      final matchSearch = _searchQuery.isEmpty ||
          name.contains(_searchQuery) ||
          desc.contains(_searchQuery);

      // 2. Dietary Match
      final isVeg = item['isVeg'] as bool? ?? false;
      bool matchDiet = true;
      if (_isVegActive && !_isNonVegActive)  matchDiet = isVeg;
      if (_isNonVegActive && !_isVegActive)  matchDiet = !isVeg;

      // 3. Bestseller Match
      bool matchBestseller = true;
      if (_isBestsellerActive) {
        matchBestseller = item['isBestseller'] == true;
      }

      // 4. Rating 4.0+ Match (Checks item rating, falls back to restaurant rating)
      bool matchRating = true;
      if (_isRating4PlusActive) {
        final itemRating = double.tryParse(item['rating']?.toString() ?? '0') ?? 0.0;
        final resRating  = double.tryParse(widget.restaurant.rating) ?? 0.0;
        matchRating = (itemRating > 0 ? itemRating : resRating) >= 4.0;
      }

      // 5. 50% OFF Match
      bool matchDiscount = true;
      if (_isDiscountActive) {
        matchDiscount = item['hasDiscount'] == true || (item['discount']?.toString().contains('50') ?? false);
      }

      return matchSearch && matchDiet && matchBestseller && matchRating && matchDiscount;
    }).map((item) {
      final copy = Map<String, dynamic>.from(item);
      copy['restaurant'] = widget.restaurant.name;
      return copy;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredMenu();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7), 
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _topDarkBgColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            padding: const EdgeInsets.only(bottom: 20), 
            child: _buildHeaderCard(),
          ),
          const SizedBox(height: 4), 
          _buildSearchAndFilters(),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: AdaptiveItemCard(item: filtered[i], tabIndex: 1),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _topDarkBgColor,
      elevation: 0,
      scrolledUnderElevation: 0, 
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
          icon: Icon(
            _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: _isFavorite ? Colors.redAccent : Colors.white,
            size: 22,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 22),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'info', child: Text('Restaurant Info')),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name.toUpperCase(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -0.2),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.restaurant.categories,
                          style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F7941),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.restaurant.rating, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
                        const SizedBox(width: 2),
                        const Icon(Icons.star, color: Colors.white, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time_filled, color: Colors.grey.shade700, size: 14),
                  const SizedBox(width: 4),
                  Text(widget.restaurant.time, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('|', style: TextStyle(color: Colors.grey))),
                  Icon(Icons.location_on_rounded, color: Colors.grey.shade700, size: 14),
                  const SizedBox(width: 4),
                  Text(widget.restaurant.distance, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 12),
              
              SizedBox(
                height: 44,
                child: PageView.builder(
                  controller: _offerPageCtrl,
                  itemCount: _offers.length,
                  onPageChanged: (i) => setState(() => _currentOfferPage = i),
                  itemBuilder: (_, i) {
                    final o = _offers[i];
                    return Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.local_offer_rounded, size: 14, color: Colors.orange),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(o['label'] ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.black)),
                              const SizedBox(height: 1),
                              Text(o['sub'] ?? '', style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.transparent, 
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Search for dishes',
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, size: 20, color: Colors.grey.shade500),
              suffixIcon: Icon(Icons.mic_none_rounded, size: 20, color: Colors.orange.shade800),
              filled: true,
              fillColor: Colors.white, 
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          
          // HORIZONTAL SCROLLING FILTER ROW
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterSwitch(
                  label: 'Veg',
                  isActive: _isVegActive,
                  activeColor: const Color(0xFF0F7941),
                  onToggle: (val) => setState(() {
                    _isVegActive = val;
                    if (val) _isNonVegActive = false;
                  }),
                ),
                const SizedBox(width: 8),
                _buildFilterSwitch(
                  label: 'Non-Veg',
                  isActive: _isNonVegActive,
                  activeColor: const Color(0xFFC82333),
                  onToggle: (val) => setState(() {
                    _isNonVegActive = val;
                    if (val) _isVegActive = false;
                  }),
                ),
                const SizedBox(width: 8),
                _buildFilterSwitch(
                  label: 'Bestseller',
                  isActive: _isBestsellerActive,
                  activeColor: Colors.orange.shade800,
                  icon: Icons.local_fire_department_rounded,
                  onToggle: (val) => setState(() => _isBestsellerActive = val),
                ),
                const SizedBox(width: 8),
                _buildFilterSwitch(
                  label: 'Rating 4.0+',
                  isActive: _isRating4PlusActive,
                  activeColor: Colors.blue.shade700,
                  icon: Icons.star_rounded,
                  onToggle: (val) => setState(() => _isRating4PlusActive = val),
                ),
                const SizedBox(width: 8),
                _buildFilterSwitch(
                  label: '50% OFF',
                  isActive: _isDiscountActive,
                  activeColor: Colors.purple.shade600,
                  icon: Icons.local_offer_rounded,
                  onToggle: (val) => setState(() => _isDiscountActive = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Updated Filter Switch to support custom icons
  Widget _buildFilterSwitch({
    required String label,
    required bool isActive,
    required Color activeColor,
    required ValueChanged<bool> onToggle,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: () => onToggle(!isActive),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.08) : Colors.white,
          border: Border.all(color: isActive ? activeColor : Colors.grey.shade300, width: 1.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isActive ? activeColor : Colors.grey.shade600),
            ] else ...[
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  border: Border.all(color: activeColor, width: 1.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isActive ? activeColor : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isActive ? activeColor : Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          const Text('No items match your search & filters', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
        ],
      ),
    );
  }
}