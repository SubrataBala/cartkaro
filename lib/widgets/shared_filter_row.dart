import 'package:flutter/material.dart';

// ══════════════════════════════════════════════════════════════════════════════
// FILTER STATE MODEL
// ══════════════════════════════════════════════════════════════════════════════
class FilterState {
  String sortBy;
  List<String> selectedQuantities;
  RangeValues priceRange;
  List<String> selectedBrands;
  double minRating;
  List<String> selectedDiscounts;

  String vegFilter;
  String distanceFilter;

  List<String> selectedForms;

  FilterState({
    this.sortBy = '',
    List<String>? selectedQuantities,
    RangeValues? priceRange,
    List<String>? selectedBrands,
    this.minRating = 0.0,
    List<String>? selectedDiscounts,
    this.vegFilter = 'all',
    this.distanceFilter = 'all',
    List<String>? selectedForms,
  })  : selectedQuantities = selectedQuantities ?? [],
        priceRange = priceRange ?? const RangeValues(0, 1000),
        selectedBrands = selectedBrands ?? [],
        selectedDiscounts = selectedDiscounts ?? [],
        selectedForms = selectedForms ?? [];

  FilterState copyWith({
    String? sortBy,
    List<String>? selectedQuantities,
    RangeValues? priceRange,
    List<String>? selectedBrands,
    double? minRating,
    List<String>? selectedDiscounts,
    String? vegFilter,
    String? distanceFilter,
    List<String>? selectedForms,
  }) {
    return FilterState(
      sortBy: sortBy ?? this.sortBy,
      selectedQuantities: selectedQuantities ?? List.from(this.selectedQuantities),
      priceRange: priceRange ?? this.priceRange,
      selectedBrands: selectedBrands ?? List.from(this.selectedBrands),
      minRating: minRating ?? this.minRating,
      selectedDiscounts: selectedDiscounts ?? List.from(this.selectedDiscounts),
      vegFilter: vegFilter ?? this.vegFilter,
      distanceFilter: distanceFilter ?? this.distanceFilter,
      selectedForms: selectedForms ?? List.from(this.selectedForms),
    );
  }

  bool get hasActiveFilters =>
      sortBy.isNotEmpty ||
      selectedQuantities.isNotEmpty ||
      selectedBrands.isNotEmpty ||
      selectedDiscounts.isNotEmpty ||
      selectedForms.isNotEmpty ||
      minRating > 0 ||
      priceRange.start > 0 ||
      priceRange.end < 1000 ||
      vegFilter != 'all' ||
      distanceFilter != 'all';

  int get activeFilterCount {
    int count = 0;
    if (sortBy.isNotEmpty) count++;
    if (selectedQuantities.isNotEmpty) count++;
    if (selectedBrands.isNotEmpty) count++;
    if (selectedDiscounts.isNotEmpty) count++;
    if (selectedForms.isNotEmpty) count++;
    if (minRating > 0) count++;
    if (priceRange.start > 0 || priceRange.end < 1000) count++;
    if (vegFilter != 'all') count++;
    if (distanceFilter != 'all') count++;
    return count;
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MAIN SHARED FILTER ROW WIDGET
// ══════════════════════════════════════════════════════════════════════════════
class SharedFilterRow extends StatelessWidget {
  final int tabIndex;
  final FilterState filterState;
  final Function(FilterState) onFilterChanged;
  // 🔥 NAYA: Search results pass karne ke liye
  final List<Map<String, dynamic>> searchResults; 

  const SharedFilterRow({
    super.key,
    required this.tabIndex,
    required this.filterState,
    required this.onFilterChanged,
    required this.searchResults, 
  });

  Color get _themeColor {
    if (tabIndex == 1) return const Color(0xFFE53935);
    if (tabIndex == 2) return const Color(0xFF1565C0);
    return const Color(0xFF4CAF50);
  }

  List<Map<String, dynamic>> get _chipConfigs {
    if (tabIndex == 1) {
      return [
        {'key': 'sort', 'label': _sortLabel, 'icon': Icons.swap_vert_rounded, 'isActive': filterState.sortBy.isNotEmpty},
        {'key': 'veg', 'label': _vegLabel, 'icon': Icons.eco_rounded, 'isActive': filterState.vegFilter != 'all'},
        {'key': 'distance', 'label': _distanceLabel, 'icon': Icons.location_on_rounded, 'isActive': filterState.distanceFilter != 'all'},
        {'key': 'rating', 'label': filterState.minRating > 0 ? '${filterState.minRating}★+' : 'Rating', 'icon': Icons.star_rounded, 'isActive': filterState.minRating > 0},
      ];
    } else if (tabIndex == 2) {
      return [
        {'key': 'sort', 'label': _sortLabel, 'icon': Icons.swap_vert_rounded, 'isActive': filterState.sortBy.isNotEmpty},
        {'key': 'form', 'label': filterState.selectedForms.isNotEmpty ? filterState.selectedForms.first : 'Form', 'icon': Icons.medication_rounded, 'isActive': filterState.selectedForms.isNotEmpty},
        {'key': 'brand', 'label': filterState.selectedBrands.isNotEmpty ? '${filterState.selectedBrands.length} Brand' : 'Brand', 'icon': Icons.business_rounded, 'isActive': filterState.selectedBrands.isNotEmpty},
        {'key': 'rating', 'label': filterState.minRating > 0 ? '${filterState.minRating}★+' : 'Rating', 'icon': Icons.star_rounded, 'isActive': filterState.minRating > 0},
      ];
    } else {
      return [
        {'key': 'sort', 'label': _sortLabel, 'icon': Icons.swap_vert_rounded, 'isActive': filterState.sortBy.isNotEmpty},
        {'key': 'quantity', 'label': filterState.selectedQuantities.isNotEmpty ? filterState.selectedQuantities.first : 'Quantity', 'icon': Icons.scale_rounded, 'isActive': filterState.selectedQuantities.isNotEmpty},
        {'key': 'price', 'label': (filterState.priceRange.start > 0 || filterState.priceRange.end < 1000) ? '₹${filterState.priceRange.start.toInt()}-${filterState.priceRange.end.toInt()}' : 'Price', 'icon': Icons.currency_rupee_rounded, 'isActive': filterState.priceRange.start > 0 || filterState.priceRange.end < 1000},
        {'key': 'brand', 'label': filterState.selectedBrands.isNotEmpty ? '${filterState.selectedBrands.length} Brand' : 'Brand', 'icon': Icons.business_rounded, 'isActive': filterState.selectedBrands.isNotEmpty},
        {'key': 'rating', 'label': filterState.minRating > 0 ? '${filterState.minRating}★+' : 'Rating', 'icon': Icons.star_rounded, 'isActive': filterState.minRating > 0},
        {'key': 'discount', 'label': filterState.selectedDiscounts.isNotEmpty ? filterState.selectedDiscounts.first : 'Discount', 'icon': Icons.local_offer_rounded, 'isActive': filterState.selectedDiscounts.isNotEmpty},
      ];
    }
  }

  String get _sortLabel {
    switch (filterState.sortBy) {
      case 'low_to_high': return 'Price ↑';
      case 'high_to_low': return 'Price ↓';
      case 'rating': return 'Top Rated';
      case 'newest': return 'Newest';
      case 'popular': return 'Popular';
      default: return 'Sort';
    }
  }

  String get _vegLabel {
    switch (filterState.vegFilter) {
      case 'veg': return '🟢 Veg';
      case 'non_veg': return '🔴 Non-Veg';
      default: return 'Veg/Non-Veg';
    }
  }

  String get _distanceLabel {
    if (filterState.distanceFilter == 'all') return 'Distance';
    return filterState.distanceFilter;
  }

  void _onChipTap(BuildContext context, String key) {
    _showSubFilterSheet(context, key, filterState, (newState) {
      onFilterChanged(newState);
    }, tabIndex, _themeColor, searchResults);
  }

  void _showAllFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AllFiltersSheet(
        tabIndex: tabIndex,
        themeColor: _themeColor,
        filterState: filterState,
        searchResults: searchResults,
        onFilterChanged: onFilterChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chips = _chipConfigs;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => _showAllFiltersSheet(context),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: filterState.hasActiveFilters ? _themeColor : Colors.white,
                  border: Border.all(color: _themeColor, width: 1.5),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: filterState.hasActiveFilters
                      ? [BoxShadow(color: _themeColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune_rounded, size: 15, color: filterState.hasActiveFilters ? Colors.white : _themeColor),
                    const SizedBox(width: 5),
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: filterState.hasActiveFilters ? Colors.white : _themeColor,
                      ),
                    ),
                    if (filterState.activeFilterCount > 0) ...[
                      const SizedBox(width: 5),
                      Container(
                        width: 18, height: 18,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text(
                          '${filterState.activeFilterCount}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            ...chips.map((chip) {
              final isActive = chip['isActive'] as bool;
              return GestureDetector(
                onTap: () => _onChipTap(context, chip['key'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: isActive ? _themeColor.withOpacity(0.08) : Colors.white,
                    border: Border.all(
                      color: isActive ? _themeColor : Colors.grey.shade300,
                      width: isActive ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        chip['icon'] as IconData,
                        size: 13,
                        color: isActive ? _themeColor : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        chip['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isActive ? _themeColor : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 15,
                        color: isActive ? _themeColor : Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HELPER: OPEN SUB-FILTERS
// ══════════════════════════════════════════════════════════════════════════════
void _showSubFilterSheet(BuildContext context, String key, FilterState currentState, Function(FilterState) onUpdate, int tabIndex, Color themeColor, List<Map<String, dynamic>> searchResults) {
  switch (key) {
    case 'sort':
      final options = tabIndex == 1
          ? [
              {'key': 'popular', 'label': 'Most Popular', 'icon': Icons.trending_up_rounded},
              {'key': 'rating', 'label': 'Top Rated', 'icon': Icons.star_rounded},
              {'key': 'low_to_high', 'label': 'Price: Low to High', 'icon': Icons.arrow_upward_rounded},
              {'key': 'high_to_low', 'label': 'Price: High to Low', 'icon': Icons.arrow_downward_rounded},
              {'key': 'newest', 'label': 'Newly Opened', 'icon': Icons.fiber_new_rounded},
            ]
          : tabIndex == 2
              ? [
                  {'key': 'popular', 'label': 'Most Popular', 'icon': Icons.trending_up_rounded},
                  {'key': 'rating', 'label': 'Top Rated', 'icon': Icons.star_rounded},
                  {'key': 'low_to_high', 'label': 'Price: Low to High', 'icon': Icons.arrow_upward_rounded},
                  {'key': 'high_to_low', 'label': 'Price: High to Low', 'icon': Icons.arrow_downward_rounded},
                ]
              : [
                  {'key': 'popular', 'label': 'Most Popular', 'icon': Icons.trending_up_rounded},
                  {'key': 'rating', 'label': 'Top Rated', 'icon': Icons.star_rounded},
                  {'key': 'low_to_high', 'label': 'Price: Low to High', 'icon': Icons.arrow_upward_rounded},
                  {'key': 'high_to_low', 'label': 'Price: High to Low', 'icon': Icons.arrow_downward_rounded},
                  {'key': 'newest', 'label': 'Newest First', 'icon': Icons.fiber_new_rounded},
                  {'key': 'discount', 'label': 'Biggest Discount', 'icon': Icons.local_offer_rounded},
                ];

      _showOptionSheet(
        context,
        title: 'Sort By',
        themeColor: themeColor,
        child: Column(
          children: options.map((opt) {
            final isSelected = currentState.sortBy == opt['key'];
            return _OptionTile(
              label: opt['label'] as String,
              icon: opt['icon'] as IconData,
              isSelected: isSelected,
              themeColor: themeColor,
              onTap: () {
                onUpdate(currentState.copyWith(sortBy: isSelected ? '' : opt['key'] as String));
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
      break;

    case 'quantity':
      // 🔥 DYNAMIC QUANTITY EXTRACTION
      Set<String> extractedQuantities = {};
      for (var item in searchResults) {
        if (item['variants'] != null) {
          for (var v in item['variants']) {
            if (v['weight'] != null) extractedQuantities.add(v['weight'].toString());
          }
        } else if (item['weight'] != null) {
          extractedQuantities.add(item['weight'].toString());
        }
      }
      List<String> options = extractedQuantities.toList();
      if (options.isEmpty) options = ['100g', '250g', '500g', '1kg', '1 pc']; // Fallback

      _showMultiSelectSheet(
        context,
        title: 'Select Quantity',
        themeColor: themeColor,
        options: options,
        selected: currentState.selectedQuantities,
        onApply: (selected) {
          onUpdate(currentState.copyWith(selectedQuantities: selected));
        },
      );
      break;

    case 'price':
      RangeValues tempRange = currentState.priceRange;
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setLocalState) => _BottomSheetWrapper(
            title: 'Price Range',
            themeColor: themeColor,
            onApply: () {
              onUpdate(currentState.copyWith(priceRange: tempRange));
              Navigator.pop(ctx);
            },
            onClear: () {
              onUpdate(currentState.copyWith(priceRange: const RangeValues(0, 1000)));
              Navigator.pop(ctx);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: themeColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Min Price', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                        Text('₹${tempRange.start.toInt()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: themeColor)),
                      ]),
                      Container(height: 40, width: 1, color: Colors.grey.shade200),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        const Text('Max Price', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                        Text('₹${tempRange.end.toInt()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: themeColor)),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: themeColor,
                    inactiveTrackColor: themeColor.withOpacity(0.15),
                    thumbColor: themeColor,
                    overlayColor: themeColor.withOpacity(0.1),
                    trackHeight: 4,
                  ),
                  child: RangeSlider(
                    values: tempRange,
                    min: 0,
                    max: 1000,
                    divisions: 100,
                    onChanged: (v) => setLocalState(() => tempRange = v),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹0', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                    Text('₹1000+', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Popular Ranges', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: [
                    for (var range in [
                      [0.0, 50.0], [50.0, 200.0], [200.0, 500.0], [500.0, 1000.0]
                    ])
                      GestureDetector(
                        onTap: () => setLocalState(() => tempRange = RangeValues(range[0], range[1])),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: (tempRange.start == range[0] && tempRange.end == range[1]) ? themeColor.withOpacity(0.1) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (tempRange.start == range[0] && tempRange.end == range[1]) ? themeColor : Colors.transparent,
                            ),
                          ),
                          child: Text('₹${range[0].toInt()} - ₹${range[1].toInt()}',
                              style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700,
                                color: (tempRange.start == range[0] && tempRange.end == range[1]) ? themeColor : Colors.black87,
                              )),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      break;

    case 'brand':
      // 🔥 DYNAMIC BRAND EXTRACTION
      Set<String> dynamicBrands = {};
      for (var item in searchResults) {
        if (item['brand'] != null) {
          dynamicBrands.add(item['brand']);
        } else if (tabIndex == 1 && item['name'] != null) {
          dynamicBrands.add(item['name']); // Restaurant mein item ka naam hi restaurant/brand hai
        } else if (tabIndex == 1 && item['restaurant'] != null) {
          dynamicBrands.add(item['restaurant']);
        }
      }
      
      List<String> brands = dynamicBrands.toList();
      
      // Fallback agar dummy data mein 'brand' nahi hai
      if (brands.isEmpty) {
        brands = tabIndex == 2 
            ? ['Cipla', 'Sun Pharma', 'Generic'] 
            : tabIndex == 1 
                ? ['Local Restaurant'] 
                : ['Fresh Farm', 'Local Generic'];
      }

      _showMultiSelectSheet(
        context,
        title: 'Select Brand',
        themeColor: themeColor,
        options: brands,
        selected: currentState.selectedBrands,
        onApply: (selected) {
          onUpdate(currentState.copyWith(selectedBrands: selected));
        },
      );
      break;

    case 'rating':
      final options = [
        {'value': 4.5, 'label': '4.5★ & above', 'sub': 'Outstanding'},
        {'value': 4.0, 'label': '4.0★ & above', 'sub': 'Excellent'},
        {'value': 3.5, 'label': '3.5★ & above', 'sub': 'Very Good'},
        {'value': 3.0, 'label': '3.0★ & above', 'sub': 'Good'},
      ];

      _showOptionSheet(
        context,
        title: 'Minimum Rating',
        themeColor: themeColor,
        child: Column(
          children: options.map((opt) {
            final isSelected = currentState.minRating == opt['value'];
            return _OptionTile(
              label: opt['label'] as String,
              subtitle: opt['sub'] as String,
              icon: Icons.star_rounded,
              iconColor: const Color(0xFFFFA726),
              isSelected: isSelected,
              themeColor: themeColor,
              onTap: () {
                onUpdate(currentState.copyWith(minRating: isSelected ? 0.0 : opt['value'] as double));
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
      break;

    case 'discount':
      final options = ['10% off & above', '20% off & above', '30% off & above', '50% off & above', 'Buy 1 Get 1', 'Combo Offer'];
      _showMultiSelectSheet(
        context,
        title: 'Discount & Offers',
        themeColor: themeColor,
        options: options,
        selected: currentState.selectedDiscounts,
        onApply: (selected) {
          onUpdate(currentState.copyWith(selectedDiscounts: selected));
        },
      );
      break;

    case 'veg':
      final options = [
        {'key': 'all', 'label': 'All', 'sub': 'Show everything', 'icon': Icons.restaurant_menu_rounded},
        {'key': 'veg', 'label': '🟢 Veg Only', 'sub': 'Pure vegetarian items', 'icon': Icons.eco_rounded},
        {'key': 'non_veg', 'label': '🔴 Non-Veg', 'sub': 'Includes meat & seafood', 'icon': Icons.set_meal_rounded},
      ];

      _showOptionSheet(
        context,
        title: 'Food Preference',
        themeColor: themeColor,
        child: Column(
          children: options.map((opt) {
            final isSelected = currentState.vegFilter == opt['key'];
            return _OptionTile(
              label: opt['label'] as String,
              subtitle: opt['sub'] as String,
              icon: opt['icon'] as IconData,
              isSelected: isSelected,
              themeColor: themeColor,
              onTap: () {
                onUpdate(currentState.copyWith(vegFilter: opt['key'] as String));
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
      break;

    case 'distance':
      final options = [
        {'key': 'all', 'label': 'Any Distance'},
        {'key': 'Within 1 km', 'label': 'Within 1 km'},
        {'key': 'Within 3 km', 'label': 'Within 3 km'},
        {'key': 'Within 5 km', 'label': 'Within 5 km'},
        {'key': 'Within 10 km', 'label': 'Within 10 km'},
      ];

      _showOptionSheet(
        context,
        title: 'Distance',
        themeColor: themeColor,
        child: Column(
          children: options.map((opt) {
            final isSelected = currentState.distanceFilter == opt['key'];
            return _OptionTile(
              label: opt['label'] as String,
              icon: Icons.location_on_rounded,
              isSelected: isSelected,
              themeColor: themeColor,
              onTap: () {
                onUpdate(currentState.copyWith(distanceFilter: opt['key'] as String));
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
      break;

    case 'form':
      // 🔥 DYNAMIC FORM EXTRACTION
      Set<String> extractedForms = {};
      for (var item in searchResults) {
        if (item['form'] != null) extractedForms.add(item['form']);
      }
      List<String> options = extractedForms.toList();
      if (options.isEmpty) options = ['Tablet', 'Capsule', 'Syrup', 'Drops', 'Powder']; // Fallback

      _showMultiSelectSheet(
        context,
        title: 'Medicine Form',
        themeColor: themeColor,
        options: options,
        selected: currentState.selectedForms,
        onApply: (selected) {
          onUpdate(currentState.copyWith(selectedForms: selected));
        },
      );
      break;
  }
}

// ── REUSABLE: Single Option Sheet ──
void _showOptionSheet(BuildContext context, {required String title, required Color themeColor, required Widget child}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _BottomSheetWrapper(
      title: title,
      themeColor: themeColor,
      showApplyButton: false,
      onClear: null,
      onApply: () {},
      child: child,
    ),
  );
}

// ── REUSABLE: Multi-Select Sheet ──
void _showMultiSelectSheet(
  BuildContext context, {
  required String title,
  required Color themeColor,
  required List<String> options,
  required List<String> selected,
  required Function(List<String>) onApply,
}) {
  List<String> tempSelected = List.from(selected);
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocalState) => _BottomSheetWrapper(
        title: title,
        themeColor: themeColor,
        onApply: () {
          onApply(tempSelected);
          Navigator.pop(ctx);
        },
        onClear: () {
          onApply([]);
          Navigator.pop(ctx);
        },
        child: Wrap(
          spacing: 8,
          runSpacing: 10,
          children: options.map((opt) {
            final isSelected = tempSelected.contains(opt);
            return GestureDetector(
              onTap: () => setLocalState(() {
                if (isSelected) {
                  tempSelected.remove(opt);
                } else {
                  tempSelected.add(opt);
                }
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? themeColor.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? themeColor : Colors.transparent,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      Icon(Icons.check_circle_rounded, size: 14, color: themeColor),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      opt,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? themeColor : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}


// ══════════════════════════════════════════════════════════════════════════════
// REUSABLE BOTTOM SHEET WRAPPER 
// ══════════════════════════════════════════════════════════════════════════════
class _BottomSheetWrapper extends StatelessWidget {
  final String title;
  final Color themeColor;
  final Widget child;
  final VoidCallback onApply;
  final VoidCallback? onClear;
  final bool showApplyButton;

  const _BottomSheetWrapper({
    required this.title,
    required this.themeColor,
    required this.child,
    required this.onApply,
    this.onClear,
    this.showApplyButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── DRAG HANDLE ──
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          // ── HEADER ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // ── CONTENT ──
          Flexible(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: child,
            ),
          ),
          // ── ACTION BUTTONS ──
          if (showApplyButton)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Row(
                children: [
                  if (onClear != null)
                    Expanded(
                      child: GestureDetector(
                        onTap: onClear,
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          alignment: Alignment.center,
                          child: const Text('Clear', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black87)),
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: onApply,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: themeColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        alignment: Alignment.center,
                        child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// OPTION TILE 
// ══════════════════════════════════════════════════════════════════════════════
class _OptionTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final bool isSelected;
  final Color themeColor;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    this.subtitle,
    required this.icon,
    this.iconColor,
    required this.isSelected,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withOpacity(0.06) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? themeColor : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: (iconColor ?? themeColor).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor ?? themeColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: isSelected ? themeColor : Colors.black87)),
                  if (subtitle != null) Text(subtitle!, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? themeColor : Colors.grey.shade400, width: 2),
                color: isSelected ? themeColor : Colors.transparent,
              ),
              child: isSelected ? const Icon(Icons.check_rounded, size: 12, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ALL FILTERS MASTER SHEET
// ══════════════════════════════════════════════════════════════════════════════
class _AllFiltersSheet extends StatefulWidget {
  final int tabIndex;
  final Color themeColor;
  final FilterState filterState;
  final List<Map<String, dynamic>> searchResults; // NAYA: Data Pass ho raha hai yahan bhi
  final Function(FilterState) onFilterChanged;

  const _AllFiltersSheet({
    required this.tabIndex,
    required this.themeColor,
    required this.filterState,
    required this.searchResults,
    required this.onFilterChanged,
  });

  @override
  State<_AllFiltersSheet> createState() => _AllFiltersSheetState();
}

class _AllFiltersSheetState extends State<_AllFiltersSheet> {
  late FilterState _localState;

  @override
  void initState() {
    super.initState();
    _localState = widget.filterState.copyWith();
  }

  List<Map<String, dynamic>> get _sections {
    if (widget.tabIndex == 1) {
      return [
        {'title': 'Sort By', 'key': 'sort'},
        {'title': 'Veg / Non-Veg', 'key': 'veg'},
        {'title': 'Distance', 'key': 'distance'},
        {'title': 'Rating', 'key': 'rating'},
      ];
    } else if (widget.tabIndex == 2) {
      return [
        {'title': 'Sort By', 'key': 'sort'},
        {'title': 'Medicine Form', 'key': 'form'},
        {'title': 'Brand', 'key': 'brand'},
        {'title': 'Price Range', 'key': 'price'},
        {'title': 'Rating', 'key': 'rating'},
      ];
    } else {
      return [
        {'title': 'Sort By', 'key': 'sort'},
        {'title': 'Quantity', 'key': 'quantity'},
        {'title': 'Price Range', 'key': 'price'},
        {'title': 'Brand', 'key': 'brand'},
        {'title': 'Rating', 'key': 'rating'},
        {'title': 'Discount & Offers', 'key': 'discount'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (ctx, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
              child: Row(
                children: [
                  const Expanded(child: Text('All Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
                  if (_localState.hasActiveFilters)
                    GestureDetector(
                      onTap: () => setState(() => _localState = FilterState()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text('Clear All', style: TextStyle(color: Colors.red.shade600, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: _sections.map((section) {
                  return _buildSectionTile(section['title'] as String, section['key'] as String);
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: GestureDetector(
                onTap: () {
                  widget.onFilterChanged(_localState);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity, height: 54,
                  decoration: BoxDecoration(
                    color: widget.themeColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: widget.themeColor.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                      if (_localState.activeFilterCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(10)),
                          child: Text('${_localState.activeFilterCount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTile(String title, String key) {
    String subtitle = _getSubtitle(key);
    bool isActive = _isSectionActive(key);

    return GestureDetector(
      onTap: () {
        _showSubFilterSheet(
          context, 
          key, 
          _localState, 
          (newState) {
            setState(() {
              _localState = newState;
            });
          }, 
          widget.tabIndex, 
          widget.themeColor,
          widget.searchResults, // 🔥 PASSED RESULTS HERE
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? widget.themeColor.withOpacity(0.05) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? widget.themeColor.withOpacity(0.3) : Colors.grey.shade200,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: isActive ? widget.themeColor.withOpacity(0.12) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isActive ? widget.themeColor.withOpacity(0.3) : Colors.grey.shade200),
              ),
              child: Icon(_getSectionIcon(key), size: 20, color: isActive ? widget.themeColor : Colors.grey.shade500),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: isActive ? widget.themeColor : Colors.grey.shade500, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: isActive ? widget.themeColor : Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  String _getSubtitle(String key) {
    switch (key) {
      case 'sort': return _localState.sortBy.isEmpty ? 'Not selected' : _localState.sortBy.replaceAll('_', ' ').toUpperCase();
      case 'quantity': return _localState.selectedQuantities.isEmpty ? 'Any quantity' : _localState.selectedQuantities.join(', ');
      case 'price': return (_localState.priceRange.start == 0 && _localState.priceRange.end == 1000) ? 'Any price' : '₹${_localState.priceRange.start.toInt()} - ₹${_localState.priceRange.end.toInt()}';
      case 'brand': return _localState.selectedBrands.isEmpty ? 'All brands' : _localState.selectedBrands.join(', ');
      case 'rating': return _localState.minRating == 0 ? 'Any rating' : '${_localState.minRating}★ & above';
      case 'discount': return _localState.selectedDiscounts.isEmpty ? 'Any offer' : _localState.selectedDiscounts.join(', ');
      case 'veg': return _localState.vegFilter == 'all' ? 'All' : _localState.vegFilter;
      case 'distance': return _localState.distanceFilter == 'all' ? 'Any distance' : _localState.distanceFilter;
      case 'form': return _localState.selectedForms.isEmpty ? 'Any form' : _localState.selectedForms.join(', ');
      default: return '';
    }
  }

  bool _isSectionActive(String key) {
    switch (key) {
      case 'sort': return _localState.sortBy.isNotEmpty;
      case 'quantity': return _localState.selectedQuantities.isNotEmpty;
      case 'price': return _localState.priceRange.start > 0 || _localState.priceRange.end < 1000;
      case 'brand': return _localState.selectedBrands.isNotEmpty;
      case 'rating': return _localState.minRating > 0;
      case 'discount': return _localState.selectedDiscounts.isNotEmpty;
      case 'veg': return _localState.vegFilter != 'all';
      case 'distance': return _localState.distanceFilter != 'all';
      case 'form': return _localState.selectedForms.isNotEmpty;
      default: return false;
    }
  }

  IconData _getSectionIcon(String key) {
    switch (key) {
      case 'sort': return Icons.swap_vert_rounded;
      case 'quantity': return Icons.scale_rounded;
      case 'price': return Icons.currency_rupee_rounded;
      case 'brand': return Icons.business_rounded;
      case 'rating': return Icons.star_rounded;
      case 'discount': return Icons.local_offer_rounded;
      case 'veg': return Icons.eco_rounded;
      case 'distance': return Icons.location_on_rounded;
      case 'form': return Icons.medication_rounded;
      default: return Icons.filter_list_rounded;
    }
  }
}