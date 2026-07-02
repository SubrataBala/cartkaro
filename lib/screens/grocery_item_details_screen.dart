// ============================================================
// CartKaro — Grocery Item Details Screen
// File: lib/screens/grocery_item_details_screen.dart
//
// Depends on:
//   lib/widgets/grocery_item_details_widgets.dart
//
// Navigate to this screen:
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => GroceryItemDetailsScreen(item: yourItem),
//     ),
//   );
//
// For a Hero transition from your listing card, wrap the source
// product image with:
//   Hero(tag: 'product_\${item.id}', child: Image.network(...))
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/grocery_item_details_widgets.dart';
import '../screens/app_models.dart';
import '../widgets/shared_card_widgets.dart';
// ════════════════════════════════════════════════════════════
// GROCERY ITEM DETAILS SCREEN
// ════════════════════════════════════════════════════════════

class GroceryItemDetailsScreen extends StatefulWidget {
  const GroceryItemDetailsScreen({super.key, required this.item});

  /// The product to display. Pass real API data or [dummyGroceryItem]
  /// (exported from grocery_item_details_widgets.dart) during dev.
  final GroceryItemModel item;

  @override
  State<GroceryItemDetailsScreen> createState() =>
      _GroceryItemDetailsScreenState();
}

class _GroceryItemDetailsScreenState extends State<GroceryItemDetailsScreen>
    with SingleTickerProviderStateMixin {
  // ── Local UI state ─────────────────────────────────────────
  int _selectedVariantIdx = 0; // Always start from first variant
  int _quantity = 1;
  bool _isWishlisted = false;

  // Page-load fade animation
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  // Safe shortcut to currently selected variant
  GroceryVariant get _variant {
    if (widget.item.variants.isEmpty) {
      return const GroceryVariant(label: 'Default', price: 0);
    }

    final safeIndex = _selectedVariantIdx.clamp(
      0,
      widget.item.variants.length - 1,
    );

    return widget.item.variants[safeIndex];
  }

  // ── Lifecycle ──────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    // Trigger fade-in on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _fadeCtrl.forward());
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════════
  // EVENT HANDLERS
  // ════════════════════════════════════════════════════════════

  void _handleWishlistToggle() {
    HapticFeedback.lightImpact();

    final current = Set<String>.from(watchlistNotifier.value);

    if (current.contains(widget.item.id)) {
      current.remove(widget.item.id);
      _showSnack('Removed from wishlist');
    } else {
      current.add(widget.item.id);
      _showSnack('${widget.item.name} added to wishlist ❤️');
    }

    watchlistNotifier.value = current;
  }

  void _handleVariantSelected(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedVariantIdx = index;
      _quantity = 1; // reset count when variant changes
    });
  }

  void _handleDecrement() {
    if (_quantity <= 1) return;
    HapticFeedback.selectionClick();
    setState(() => _quantity--);
  }

  void _handleIncrement() {
    HapticFeedback.selectionClick();
    setState(() => _quantity++);
  }

  void _handleAddToCart() {
    HapticFeedback.mediumImpact();

    final cartId = "${widget.item.id}|$_selectedVariantIdx";

    final current = {...groceryCartNotifier.value};

    current[cartId] = (current[cartId] ?? 0) + _quantity;

    groceryCartNotifier.value = current;

    _showSnack(
      '${widget.item.name} (${_variant.label} × $_quantity) added to cart!',
    );
  }

  void _handleShare() {
    // TODO: integrate share_plus → Share.share('Check out ${widget.item.name}')
    _showSnack('Share coming soon!');
  }

  void _showSnack(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: GroceryTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GroceryTheme.rMd),
        ),
        action: action,
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GroceryTheme.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            // ── Scrollable content ───────────────────────────
            _buildScrollBody(),

            // ── Sticky bottom bar (always on top) ────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StickyBottomBar(
                price: _variant.price,
                variantLabel: _variant.label,
                quantity: _quantity,
                onDecrement: _handleDecrement,
                onIncrement: _handleIncrement,
                onAddToCart: _handleAddToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────

PreferredSizeWidget _buildAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: false,

    title: const Text(
      'Details',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    centerTitle: true,

    leading: Padding(
      padding: const EdgeInsets.all(8),
      child: GroceryAppBarButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).pop(),
      ),
    ),

    actions: [
      ValueListenableBuilder<Set<String>>(
        valueListenable: watchlistNotifier,
        builder: (_, favs, __) {
          final isFav = favs.contains(widget.item.id);

          return Padding(
            padding: const EdgeInsets.all(8),
            child: GroceryAppBarButton(
              icon: isFav
                  ? Icons.favorite
                  : Icons.favorite_border_rounded,
              iconColor: isFav ? Colors.red : Colors.black87,
              onTap: () {
                final newFavs = Set<String>.from(favs);

                if (isFav) {
                  newFavs.remove(widget.item.id);
                  _showSnack('Removed from Watchlist');
                } else {
                  newFavs.add(widget.item.id);
                  _showSnack('Added to Watchlist ❤️');
                }

                watchlistNotifier.value = newFavs;
              },
            ),
          );
        },
      ),

      Padding(
        padding: const EdgeInsets.only(
          right: 8,
          top: 8,
          bottom: 8,
        ),
        child: GroceryAppBarButton(
          icon: Icons.ios_share_rounded,
          onTap: _handleShare,
        ),
      ),
    ],
  );
}
  // ─── Scroll Body ──────────────────────────────────────────

  Widget _buildScrollBody() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Product image carousel
        SliverToBoxAdapter(child: _buildImageSection()),

        // All content below the image
        SliverToBoxAdapter(child: _buildContentArea()),
      ],
    );
  }

  // ─── Image Section ─────────────────────────────────────────

  Widget _buildImageSection() {
    return ProductImageCarousel(
      imageUrls: widget.item.imageUrls,
      heroTag: 'product_${widget.item.id}',
      height: 300,
    );
  }

  // ─── Content Area ──────────────────────────────────────────

  Widget _buildContentArea() {
    return Container(
      // Extra bottom padding so content clears the sticky bar
      padding: const EdgeInsets.only(bottom: 130),
      color: GroceryTheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // White rounded card: product info + variant selector
          _buildTopCard(),

          const SizedBox(height: 8),

          // Feature highlights
          _buildFeaturesSection(),

          const SizedBox(height: 8),

          // Expandable info sections
          _buildExpandableSections(),

          // "You may also like"
          _buildRelatedProducts(),
        ],
      ),
    );
  }

  // ─── Top Card (Product Info + Variants) ────────────────────

  Widget _buildTopCard() {
    return Container(
      decoration: const BoxDecoration(
        color: GroceryTheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(GroceryTheme.rXL),
          topRight: Radius.circular(GroceryTheme.rXL),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildProductInfo(),
          const SizedBox(height: 16),
          _buildVariantSection(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ─── Product Info ──────────────────────────────────────────

  Widget _buildProductInfo() {
    final item = widget.item;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Delivery + store meta ─────────────────────────
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 14,
                color: GroceryTheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                item.deliveryTime,
                style: GroceryTheme.caption.copyWith(
                  color: GroceryTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.store_outlined,
                size: 14,
                color: GroceryTheme.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.storeName,
                  style: GroceryTheme.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ── Product name ──────────────────────────────────
          Text(item.name, style: GroceryTheme.headingLg),

          const SizedBox(height: 6),

          // ── Rating row ────────────────────────────────────
          GroceryRatingRow(rating: item.rating, reviewCount: item.reviewCount),

          const SizedBox(height: 8),

          // ── Freshness / quality badges ────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: item.badges
                .map((b) => GroceryBadgeChip(label: b))
                .toList(),
          ),

          const SizedBox(height: 10),

          // ── Description ───────────────────────────────────
          Text(item.description, style: GroceryTheme.bodyReg),
        ],
      ),
    );
  }

  // ─── Variant Section ───────────────────────────────────────

  Widget _buildVariantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Select Variant', style: GroceryTheme.headingMd),
        ),
        const SizedBox(height: 10),
        VariantSelector(
          variants: widget.item.variants,
          selectedIndex: _selectedVariantIdx,
          onSelected: _handleVariantSelected,
        ),
      ],
    );
  }

  // ─── Features Section ──────────────────────────────────────

  Widget _buildFeaturesSection() {
    return Container(
      color: GroceryTheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Text('Why choose us?', style: GroceryTheme.headingMd),
          ),
          FeatureHighlightsRow(features: widget.item.features),
        ],
      ),
    );
  }

  // ─── Expandable Sections ───────────────────────────────────

  Widget _buildExpandableSections() {
    final item = widget.item;
    return Column(
      children: [
        // Product Details
        GroceryExpansionTile(
          icon: Icons.description_outlined,
          title: 'Product Details',
          child: Text(item.productDetails, style: GroceryTheme.bodyReg),
        ),

        // Nutritional Info
        GroceryExpansionTile(
          icon: Icons.bar_chart_outlined,
          title: 'Nutritional Info',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: GroceryTheme.primaryLight,
              borderRadius: BorderRadius.circular(GroceryTheme.rMax),
            ),
            child: const Text(
              'Per 100gm',
              style: TextStyle(
                fontSize: 11,
                color: GroceryTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child: NutritionTable(entries: item.nutritionInfo),
        ),

        // Ingredients
        GroceryExpansionTile(
          icon: Icons.eco_outlined,
          title: 'Ingredients',
          child: Text(item.ingredients, style: GroceryTheme.bodyReg),
        ),

        // Storage Instructions
        GroceryExpansionTile(
          icon: Icons.inventory_2_outlined,
          title: 'Storage Instructions',
          child: Text(item.storageInstructions, style: GroceryTheme.bodyReg),
        ),

        // Reviews
        GroceryExpansionTile(
          icon: Icons.star_outline_rounded,
          title: 'Reviews',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: GroceryTheme.starColor,
                size: 14,
              ),
              const SizedBox(width: 3),
              Text(
                '${item.rating} (${item.reviewCount})',
                style: const TextStyle(
                  fontSize: 12,
                  color: GroceryTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          child: Column(
            children: item.reviews.map((r) => ReviewCard(review: r)).toList(),
          ),
        ),
      ],
    );
  }

  // ─── Related Products ──────────────────────────────────────

  Widget _buildRelatedProducts() {
    // Get all grocery products from all categories
    List<Map<String, dynamic>> allProducts = [];

    globalAllCategoryData[0]?.forEach((category, items) {
      allProducts.addAll(items);
    });

    // Remove current product
    allProducts = allProducts
        .where((p) => p['id'].toString() != widget.item.id)
        .toList();

    // Show only first 10 products
    final relatedProducts = allProducts.take(10).toList();

    if (relatedProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GrocerySectionTitle(title: 'People also bought'),

        SizedBox(
          height: 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: relatedProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),

            itemBuilder: (_, index) {
              final product = relatedProducts[index];

              final groceryModel = GroceryItemModel(
                id: product['id'].toString(),
                name: product['name'].toString(),
                category: 'Grocery',

                imageUrls: [product['image'].toString()],

                rating: 4.5,
                reviewCount: 100,

                description: product['description'] ?? 'Fresh grocery product',

                badges: const ['Fresh', 'Fast Delivery'],

                deliveryTime: '10 mins',
                storeName: 'CartKaro Fresh',

                variants: product.containsKey('variants')
                    ? (product['variants'] as List).map<GroceryVariant>((v) {
                        return GroceryVariant(
                          label: v['weight'].toString(),
                          price: double.tryParse(v['price'].toString()) ?? 0,
                        );
                      }).toList()
                    : [
                        GroceryVariant(
                          label: product['weight'] ?? '1 Unit',
                          price:
                              double.tryParse(product['price'].toString()) ?? 0,
                        ),
                      ],

                features: const [],
                productDetails: '',
                nutritionInfo: const [],
                ingredients: '',
                storageInstructions: '',
                reviews: const [],
              );

              return RelatedItemCard(
                item: groceryModel,

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          GroceryItemDetailsScreen(item: groceryModel),
                    ),
                  );
                },

                onAddToCart: () {
                  final current = {...groceryCartNotifier.value};

                  current[groceryModel.id] =
                      (current[groceryModel.id] ?? 0) + 1;

                  groceryCartNotifier.value = current;

                  _showSnack('${groceryModel.name} added to cart');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
