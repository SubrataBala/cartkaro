// ============================================================
// CartKaro — Grocery Item Details Widgets
// File: lib/widgets/grocery_item_details_widgets.dart
//
// Contains:
//   • Data models  (GroceryVariant, GroceryItemModel, etc.)
//   • Dummy data   (dummyGroceryItem)
//   • Design tokens (GroceryTheme)
//   • All reusable UI widgets used by GroceryItemDetailsScreen
// ============================================================

import 'package:cartkaro/screens/cart_grocery.dart';
import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════
// SECTION 1 — DATA MODELS
// ════════════════════════════════════════════════════════════

/// A single product variant, e.g. "1 kg / ₹100".
class GroceryVariant {
  final String label; // "500 gm", "1 kg" …
  final double price; // selling price in ₹
  final double? mrp; // original MRP; null = no discount shown

  const GroceryVariant({required this.label, required this.price, this.mrp});

  /// Computed discount % or null when unavailable.
  int? get discountPercent {
    if (mrp == null || mrp! <= price) return null;
    return (((mrp! - price) / mrp!) * 100).round();
  }
}

/// A single row in the nutritional info table.
class NutritionEntry {
  final String name;
  final String value;
  const NutritionEntry({required this.name, required this.value});
}

/// A user-submitted review.
class GroceryReview {
  final String userName;
  final String avatarInitials; // shown when no network avatar is available
  final double rating;
  final String comment;
  final String date;

  const GroceryReview({
    required this.userName,
    required this.avatarInitials,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

/// One icon card in the feature highlights row.
class FeatureHighlight {
  final String label;
  final String iconAsset; // logical key mapped to an IconData in the widget

  const FeatureHighlight({required this.label, required this.iconAsset});
}

/// Complete grocery item detail — wire this to your API/repository layer.
class GroceryItemModel {
  final String id;
  final String name;
  final String category;
  final List<String> imageUrls;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> badges;
  final String deliveryTime;
  final String storeName;
  final List<GroceryVariant> variants;
  final List<FeatureHighlight> features;
  final String productDetails;
  final List<NutritionEntry> nutritionInfo;
  final String ingredients;
  final String storageInstructions;
  final List<GroceryReview> reviews;
  final List<GroceryItemModel> relatedItems;

  const GroceryItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrls,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.badges,
    required this.deliveryTime,
    required this.storeName,
    required this.variants,
    required this.features,
    required this.productDetails,
    required this.nutritionInfo,
    required this.ingredients,
    required this.storageInstructions,
    required this.reviews,
    this.relatedItems = const [],
  });
}

// ════════════════════════════════════════════════════════════
// SECTION 2 — DUMMY DATA
// Replace with your API/repository call in production.
// ════════════════════════════════════════════════════════════

final GroceryItemModel dummyGroceryItem = GroceryItemModel(
  id: 'apple_red_001',
  name: 'Fresh Red Apples',
  category: 'Fruits',
  imageUrls: const [
    'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=800',
    'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=800',
    'https://images.unsplash.com/photo-1570913149827-d2ac84ab3f9a?w=800',
  ],
  rating: 4.8,
  reviewCount: 1200,
  description:
      'Handpicked from the finest orchards, our Fresh Red Apples are crisp, '
      'juicy and bursting with natural sweetness. Perfect for snacking, '
      'salads or baking. Rich in antioxidants and dietary fiber to support '
      'a healthy lifestyle.',
  badges: const ['100% Fresh & Natural', 'Farm to Door'],
  deliveryTime: 'Delivered in 10 mins',
  storeName: 'CartKaro Fresh Hub',
  variants: const [
    GroceryVariant(label: '500 gm', price: 55, mrp: 65),
    GroceryVariant(label: '1 kg', price: 100, mrp: 120),
    GroceryVariant(label: '2 kg', price: 190, mrp: 230),
    GroceryVariant(label: '5 kg', price: 440, mrp: 550),
  ],
  features: const [
    FeatureHighlight(label: 'Farm Fresh', iconAsset: 'farm_fresh'),
    FeatureHighlight(label: 'No Pesticides', iconAsset: 'no_pesticides'),
    FeatureHighlight(label: 'Rich in Fiber', iconAsset: 'fiber'),
    FeatureHighlight(label: 'Boosts Immunity', iconAsset: 'immunity'),
    FeatureHighlight(label: 'Organic', iconAsset: 'organic'),
  ],
  productDetails:
      'Variety: Royal Gala / Fuji blend\n'
      'Origin: Himachal Pradesh, India\n'
      'Shelf Life: 7–10 days when refrigerated\n'
      'Weight (net): As per selected variant\n'
      'Packaging: Food-grade breathable mesh bag',
  nutritionInfo: const [
    NutritionEntry(name: 'Calories', value: '52 kcal'),
    NutritionEntry(name: 'Carbohydrates', value: '13.8 g'),
    NutritionEntry(name: 'Dietary Fiber', value: '2.4 g'),
    NutritionEntry(name: 'Sugars', value: '10.4 g'),
    NutritionEntry(name: 'Protein', value: '0.3 g'),
    NutritionEntry(name: 'Fat', value: '0.2 g'),
    NutritionEntry(name: 'Vitamin C', value: '7 % DV'),
    NutritionEntry(name: 'Potassium', value: '107 mg'),
  ],
  ingredients:
      'Fresh Red Apples (100%). No added preservatives, colors or flavors.',
  storageInstructions:
      'Store in a cool, dry place away from direct sunlight. '
      'Refrigerate for best freshness. Consume within 7–10 days of purchase.',
  reviews: const [
    GroceryReview(
      userName: 'Priya Sharma',
      avatarInitials: 'PS',
      rating: 5,
      comment:
          'Super fresh and crispy! Delivered in less than 15 minutes. '
          'Will definitely order again.',
      date: '12 Jun 2025',
    ),
    GroceryReview(
      userName: 'Rahul Mehta',
      avatarInitials: 'RM',
      rating: 4,
      comment:
          'Good quality apples. Slightly smaller than expected for the '
          '1 kg pack, but taste is excellent.',
      date: '8 Jun 2025',
    ),
    GroceryReview(
      userName: 'Anjali Verma',
      avatarInitials: 'AV',
      rating: 5,
      comment:
          'Love the freshness! Packaging is neat and eco-friendly. '
          'CartKaro never disappoints.',
      date: '1 Jun 2025',
    ),
  ],
  relatedItems: [
    GroceryItemModel(
      id: 'banana_001',
      name: 'Banana',
      category: 'Fruits',
      imageUrls: const [
        'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
      ],
      rating: 4.5,
      reviewCount: 800,
      description: 'Fresh ripe bananas.',
      badges: const [],
      deliveryTime: '10 mins',
      storeName: 'CartKaro',
      variants: const [GroceryVariant(label: '1 kg', price: 60)],
      features: const [],
      productDetails: '',
      nutritionInfo: const [],
      ingredients: '',
      storageInstructions: '',
      reviews: const [],
    ),
    GroceryItemModel(
      id: 'grapes_green_001',
      name: 'Green Grapes',
      category: 'Fruits',
      imageUrls: const [
        'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      ],
      rating: 4.6,
      reviewCount: 650,
      description: 'Sweet seedless green grapes.',
      badges: const [],
      deliveryTime: '10 mins',
      storeName: 'CartKaro',
      variants: const [GroceryVariant(label: '500 gm', price: 80)],
      features: const [],
      productDetails: '',
      nutritionInfo: const [],
      ingredients: '',
      storageInstructions: '',
      reviews: const [],
    ),
    GroceryItemModel(
      id: 'orange_001',
      name: 'Orange',
      category: 'Fruits',
      imageUrls: const [
        'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
      ],
      rating: 4.7,
      reviewCount: 920,
      description: 'Juicy navel oranges.',
      badges: const [],
      deliveryTime: '10 mins',
      storeName: 'CartKaro',
      variants: const [GroceryVariant(label: '1 kg', price: 70)],
      features: const [],
      productDetails: '',
      nutritionInfo: const [],
      ingredients: '',
      storageInstructions: '',
      reviews: const [],
    ),
    GroceryItemModel(
      id: 'pineapple_001',
      name: 'Pineapple',
      category: 'Fruits',
      imageUrls: const [
        'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=400',
      ],
      rating: 4.4,
      reviewCount: 430,
      description: 'Sweet tropical pineapple.',
      badges: const [],
      deliveryTime: '10 mins',
      storeName: 'CartKaro',
      variants: const [GroceryVariant(label: '1 pc', price: 40)],
      features: const [],
      productDetails: '',
      nutritionInfo: const [],
      ingredients: '',
      storageInstructions: '',
      reviews: const [],
    ),
  ],
);

// ════════════════════════════════════════════════════════════
// SECTION 3 — DESIGN TOKENS
// Single source of truth for colors, text styles, radii.
// Extend or override to match your existing CartKaro theme.
// ════════════════════════════════════════════════════════════

abstract class GroceryTheme {
  // ── Colors ────────────────────────────────────────────────
  static const Color primary = Color(0xFF43A047);
  static const Color primaryLight = Color(0xFFE8F5E9);
  static const Color primaryDark = Color(0xFF2E7D32);
  static const Color accent = Color(0xFFFF5252); // discounts / sale
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color starColor = Color(0xFFFFA000);

  // ── Radii ─────────────────────────────────────────────────
  static const double rSm = 8.0;
  static const double rMd = 12.0;
  static const double rLg = 16.0;
  static const double rXL = 24.0;
  static const double rMax = 100.0;

  // ── Shadows ───────────────────────────────────────────────
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.07),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // ── Text Styles ───────────────────────────────────────────
  static const TextStyle headingLg = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle headingMd = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyReg = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle priceLg = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );

  static const TextStyle priceSm = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle badgeText = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: primary,
  );
}

// ════════════════════════════════════════════════════════════
// SECTION 4 — REUSABLE WIDGETS
// ════════════════════════════════════════════════════════════

// ─── 4.1 ProductImageCarousel ─────────────────────────────────────────────────
/// Full-width image carousel with animated page-indicator dots.
/// Wrap the source image in Hero(tag: 'product_\${item.id}') for
/// a shared-element transition from your listing screen.
class ProductImageCarousel extends StatefulWidget {
  const ProductImageCarousel({
    super.key,
    required this.imageUrls,
    required this.heroTag,
    this.height = 300,
  });

  final List<String> imageUrls;
  final String heroTag;
  final double height;

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  final PageController _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: const BoxDecoration(
        color: GroceryTheme.primaryLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(GroceryTheme.rLg),
          bottomRight: Radius.circular(GroceryTheme.rLg),
        ),
      ),
      child: Stack(
        children: [
          // ── Page View ──────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(GroceryTheme.rLg),
              bottomRight: Radius.circular(GroceryTheme.rLg),
            ),
            child: PageView.builder(
              controller: _ctrl,
              itemCount: widget.imageUrls.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) => Hero(
                tag: i == 0 ? widget.heroTag : '${widget.heroTag}_$i',
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(
                    widget.imageUrls[i],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: GroceryTheme.textHint,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Page Dots ──────────────────────────────────────
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.imageUrls.length, (i) {
                  final active = _page == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active
                          ? GroceryTheme.primary
                          : GroceryTheme.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(GroceryTheme.rMax),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── 4.2 VariantSelector ─────────────────────────────────────────────────────
/// Horizontal row of animated selectable variant chips.
class VariantSelector extends StatelessWidget {
  const VariantSelector({
    super.key,
    required this.variants,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<GroceryVariant> variants;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: variants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => _VariantChip(
          variant: variants[i],
          isSelected: i == selectedIndex,
          onTap: () => onSelected(i),
        ),
      ),
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({
    required this.variant,
    required this.isSelected,
    required this.onTap,
  });

  final GroceryVariant variant;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? GroceryTheme.primaryLight : GroceryTheme.surface,
          borderRadius: BorderRadius.circular(GroceryTheme.rMd),
          border: Border.all(
            color: isSelected ? GroceryTheme.primary : GroceryTheme.divider,
            width: isSelected ? 1.8 : 1,
          ),
          boxShadow: isSelected ? [] : GroceryTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weight label
            Text(
              variant.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? GroceryTheme.primary
                    : GroceryTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            // Price
            Text(
              '₹${variant.price.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? GroceryTheme.primary
                    : GroceryTheme.textSecondary,
              ),
            ),
            // Discount badge
            if (variant.discountPercent != null) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: GroceryTheme.accent.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(GroceryTheme.rMax),
                ),
                child: Text(
                  '${variant.discountPercent}% off',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: GroceryTheme.accent,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── 4.3 FeatureHighlightsRow ─────────────────────────────────────────────────
/// Horizontally scrolling row of feature icon cards.
class FeatureHighlightsRow extends StatelessWidget {
  const FeatureHighlightsRow({super.key, required this.features});

  final List<FeatureHighlight> features;

  static IconData _icon(String asset) {
    switch (asset) {
      case 'farm_fresh':
        return Icons.eco_outlined;
      case 'no_pesticides':
        return Icons.no_food_outlined;
      case 'fiber':
        return Icons.grass_outlined;
      case 'immunity':
        return Icons.shield_outlined;
      case 'organic':
        return Icons.spa_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: features.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) => Container(
          width: 80,
          decoration: BoxDecoration(
            color: GroceryTheme.surface,
            borderRadius: BorderRadius.circular(GroceryTheme.rMd),
            boxShadow: GroceryTheme.cardShadow,
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _icon(features[i].iconAsset),
                color: GroceryTheme.primary,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                features[i].label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: GroceryTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 4.4 GroceryExpansionTile ─────────────────────────────────────────────────
/// Animated expandable section — chevron rotates, content slides open.
class GroceryExpansionTile extends StatefulWidget {
  const GroceryExpansionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  State<GroceryExpansionTile> createState() => _GroceryExpansionTileState();
}

class _GroceryExpansionTileState extends State<GroceryExpansionTile>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _ctrl;
  late Animation<double> _rotate;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _rotate = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _slide = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: GroceryTheme.surface,
        borderRadius: BorderRadius.circular(GroceryTheme.rMd),
        boxShadow: GroceryTheme.cardShadow,
      ),
      child: Column(
        children: [
          // ── Header row ─────────────────────────────────────
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(GroceryTheme.rMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(widget.icon, color: GroceryTheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.title, style: GroceryTheme.headingMd),
                  ),
                  if (widget.trailing != null) ...[
                    widget.trailing!,
                    const SizedBox(width: 8),
                  ],
                  RotationTransition(
                    turns: _rotate,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: GroceryTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Expandable content ─────────────────────────────
          SizeTransition(
            sizeFactor: _slide,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 4.5 NutritionTable ───────────────────────────────────────────────────────
/// Two-column table for nutritional values.
class NutritionTable extends StatelessWidget {
  const NutritionTable({super.key, required this.entries});

  final List<NutritionEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(entries.length, (i) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: i < entries.length - 1
                  ? const BorderSide(color: GroceryTheme.divider, width: 0.8)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entries[i].name, style: GroceryTheme.bodyReg),
              Text(
                entries[i].value,
                style: GroceryTheme.bodyMd.copyWith(
                  color: GroceryTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// ─── 4.6 ReviewCard ───────────────────────────────────────────────────────────
/// Single user review with avatar, rating stars, and comment.
class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key, required this.review});

  final GroceryReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GroceryTheme.background,
        borderRadius: BorderRadius.circular(GroceryTheme.rMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar circle
              CircleAvatar(
                radius: 18,
                backgroundColor: GroceryTheme.primaryLight,
                child: Text(
                  review.avatarInitials,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: GroceryTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: GroceryTheme.bodyMd),
                    Text(review.date, style: GroceryTheme.caption),
                  ],
                ),
              ),
              // Star + rating
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: GroceryTheme.starColor,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: GroceryTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: GroceryTheme.bodyReg),
        ],
      ),
    );
  }
}

// ─── 4.7 RelatedItemCard ──────────────────────────────────────────────────────
/// Compact card for the "You may also like" horizontal list.
class RelatedItemCard extends StatelessWidget {
  const RelatedItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onAddToCart,
  });

  final GroceryItemModel item;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final v = item.variants.first;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: GroceryTheme.surface,
          borderRadius: BorderRadius.circular(GroceryTheme.rMd),
          boxShadow: GroceryTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(GroceryTheme.rMd),
                topRight: Radius.circular(GroceryTheme.rMd),
              ),
              child: Container(
                height: 90,
                color: GroceryTheme.primaryLight,
                alignment: Alignment.center,
                child: Image.asset(
                  item.imageUrls.first,
                  height: 70,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.image_outlined,
                    size: 40,
                    color: GroceryTheme.textHint,
                  ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GroceryTheme.bodyMd,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(v.label, style: GroceryTheme.caption),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${v.price.toStringAsFixed(0)}',
                        style: GroceryTheme.priceSm,
                      ),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: GroceryTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 4.8 StickyBottomBar ─────────────────────────────────────────────────────
/// Fixed bottom bar: price display + quantity selector + Add to Cart CTA.
/// First tap adds the item to cart; subsequent taps navigate to CartGrocery.
class StickyBottomBar extends StatefulWidget {
  const StickyBottomBar({
    super.key,
    required this.price,
    required this.variantLabel,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  final double price;
  final String variantLabel;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  @override
  State<StickyBottomBar> createState() => _StickyBottomBarState();
}

class _StickyBottomBarState extends State<StickyBottomBar> {
  bool _added = false;

  void _handleButtonTap() {
    if (!_added) {
      widget.onAddToCart();
      setState(() => _added = true);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CartGrocery(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: GroceryTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Price column ──────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${(widget.price * widget.quantity).toStringAsFixed(0)}',
                style: GroceryTheme.priceLg,
              ),
              Text(widget.variantLabel, style: GroceryTheme.caption),
            ],
          ),

          const SizedBox(width: 16),

          // ── Quantity selector ─────────────────────────────
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: GroceryTheme.divider),
              borderRadius: BorderRadius.circular(GroceryTheme.rMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _QtyButton(
                  icon: Icons.remove,
                  onTap: widget.onDecrement,
                  enabled: widget.quantity > 1,
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    '${widget.quantity}',
                    textAlign: TextAlign.center,
                    style: GroceryTheme.bodyMd,
                  ),
                ),
                _QtyButton(
                  icon: Icons.add,
                  onTap: widget.onIncrement,
                  enabled: true,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Add to Cart / Go to Cart button ───────────────
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _handleButtonTap,
              icon: Icon(
                _added
                    ? Icons.arrow_forward_rounded
                    : Icons.shopping_cart_outlined,
                size: 18,
              ),
              label: Text(_added ? 'Go To Cart' : 'Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: GroceryTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(GroceryTheme.rMd),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ± tap target inside the quantity selector.
class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(GroceryTheme.rSm),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? GroceryTheme.primary : GroceryTheme.textHint,
        ),
      ),
    );
  }
}

// ─── 4.9 GroceryAppBarButton ─────────────────────────────────────────────────
/// Frosted-glass circular icon button for the transparent app bar.
class GroceryAppBarButton extends StatelessWidget {
  const GroceryAppBarButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.90),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: iconColor ?? GroceryTheme.textPrimary,
        ),
      ),
    );
  }
}

// ─── 4.10 GroceryBadgeChip ────────────────────────────────────────────────────
/// Small green badge for "100% Fresh", "Organic" etc.
class GroceryBadgeChip extends StatelessWidget {
  const GroceryBadgeChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: GroceryTheme.primaryLight,
        borderRadius: BorderRadius.circular(GroceryTheme.rMax),
        border: Border.all(color: GroceryTheme.primary.withOpacity(0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.eco_outlined, size: 12, color: GroceryTheme.primary),
          const SizedBox(width: 4),
          Text(label, style: GroceryTheme.badgeText),
        ],
      ),
    );
  }
}

// ─── 4.11 GroceryRatingRow ────────────────────────────────────────────────────
/// Inline star + rating + review count row.
class GroceryRatingRow extends StatelessWidget {
  const GroceryRatingRow({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, color: GroceryTheme.starColor, size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: GroceryTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text('($reviewCount reviews)', style: GroceryTheme.caption),
      ],
    );
  }
}

// ─── 4.12 GrocerySectionTitle ─────────────────────────────────────────────────
/// Consistent section heading with an optional "See all" link.
class GrocerySectionTitle extends StatelessWidget {
  const GrocerySectionTitle({super.key, required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GroceryTheme.headingMd),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: GroceryTheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
