import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/restaurant_item_details_widgets.dart';
import '../widgets/shared_card_widgets.dart';
import '../screens/app_models.dart';
import '../screens/restaurant_data.dart'; // same folder as this screen

class RestaurantItemDetailsScreen extends StatefulWidget {
  const RestaurantItemDetailsScreen({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  State<RestaurantItemDetailsScreen> createState() =>
      _RestaurantItemDetailsScreenState();
}

class _RestaurantItemDetailsScreenState
    extends State<RestaurantItemDetailsScreen>
    with SingleTickerProviderStateMixin {
  // ── local state ────────────────────────────────────────────
  int _variantIndex = 0;
  int _quantity = 1;

  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const double _imgFactor = 0.42;

  // ── helpers ────────────────────────────────────────────────

  Map<String, dynamic> get _item => widget.item;

  List get _variants {
    final v = _item['variants'];
    if (v != null && v is List && v.isNotEmpty) return v;
    final double base =
        double.tryParse(_item['price']?.toString() ?? '0') ?? 0;
    return [
      {'weight': 'Standard', 'price': base}
    ];
  }

  double get _unitPrice =>
      double.tryParse(_variants[_variantIndex]['price']?.toString() ?? '0') ??
      0;

  double get _totalPrice => _unitPrice * _quantity;

  String get _cartItemId => '${_item['id']}|$_variantIndex';

  bool get _isVeg =>
      _item['isVeg'] == true ||
      _item['isVeg']?.toString().toLowerCase() == 'true';

  String get _heroTag => 'restaurant_item_${_item['id']}';

  // Reviews pulled straight from item map; fallback to empty list
  List get _reviews {
    final r = _item['reviews'];
    if (r is List) return r;
    return const [];
  }

  // Flatten restaurantData (Map<String, List<Map>>) into one list,
  // then recommend: same restaurant first, then others — exclude self.
  List<Map<String, dynamic>> get _recommended {
    final String myId = _item['id']?.toString() ?? '';
    final String myRestaurant = _item['restaurant']?.toString() ?? '';
    final String myBrand = _item['brand']?.toString() ?? '';

    // Flatten all category lists into a single list
    final List<Map<String, dynamic>> all = restaurantData.values
        .expand((list) => list)
        .toList();

    // Same restaurant / brand first (excluding self)
    final sameRestaurant = all
        .where((r) =>
            r['id']?.toString() != myId &&
            (r['restaurant']?.toString() == myRestaurant ||
                r['brand']?.toString() == myBrand))
        .toList();

    // Fill up to 8 with other items if needed
    if (sameRestaurant.length < 8) {
      final others = all
          .where((r) =>
              r['id']?.toString() != myId &&
              r['restaurant']?.toString() != myRestaurant &&
              r['brand']?.toString() != myBrand)
          .toList();
      return [...sameRestaurant, ...others].take(8).toList();
    }

    return sameRestaurant.take(8).toList();
  }

  // ── lifecycle ──────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim =
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _entryCtrl.forward());
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── event handlers ─────────────────────────────────────────

  void _toggleWishlist() {
    HapticFeedback.lightImpact();
    final id = _item['id']?.toString() ?? '';
    final set = Set<String>.from(watchlistNotifier.value);
    if (set.contains(id)) {
      set.remove(id);
    } else {
      set.add(id);
    }
    watchlistNotifier.value = set;
    setState(() {});
    _snack(
      watchlistNotifier.value.contains(id)
          ? '${_item['name']} added to wishlist ❤️'
          : 'Removed from wishlist',
    );
  }

  void _addToCart() {
    HapticFeedback.mediumImpact();
    final current = Map<String, int>.from(restaurantCartNotifier.value);
    current[_cartItemId] = (current[_cartItemId] ?? 0) + _quantity;
    restaurantCartNotifier.value = current;
    _snack(
  '${_item['name']} • Qty: $_quantity • Added to Cart !',
   );
  }

  void _snack(String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: RTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(RTheme.rMd),
      ),
    ),
  );
}

  // ── build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final double imgH = MediaQuery.of(context).size.height * _imgFactor;

    return Scaffold(
      backgroundColor: RTheme.background,
      extendBodyBehindAppBar: true,
      appBar: _appBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 130),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image carousel
                RImageCarousel(
                  images: [_item['image'] ?? 'assets/images/pizza.png'],
                  heroTag: _heroTag,
                  height: imgH,
                ),
                // animated content sheet
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _contentSheet(),
                  ),
                ),
              ],
            ),
          ),

          // sticky bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: RStickyBottomBar(
              cartItemId: _cartItemId,
              totalPrice: _totalPrice,
              quantity: _quantity,
              onDecrement: () {
                if (_quantity > 1) {
                  HapticFeedback.selectionClick();
                  setState(() => _quantity--);
                }
              },
              onIncrement: () {
                HapticFeedback.selectionClick();
                setState(() => _quantity++);
              },
              onAddToCart: _addToCart,
            ),
          ),
        ],
      ),
    );
  }

  // ── floating app bar ───────────────────────────────────────

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: RGlassButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      title: const Text(
        'Details',
        style: TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      actions: [
        
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: RGlassButton(
            icon: Icons.ios_share_rounded,
            onTap: () => _snack('Share coming soon!'),
          ),
        ),
      ],
    );
  }

  // ── content sheet ──────────────────────────────────────────

  Widget _contentSheet() {
    return Transform.translate(
      offset: const Offset(0, -RTheme.rTop),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: RTheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(RTheme.rTop),
            topRight: Radius.circular(RTheme.rTop),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            _headerInfo(),
            _divider(),
            _descriptionSection(),
            _divider(),
            if (_variants.length > 1) ...[
              _variantSection(),
              _divider(),
            ],
            _reviewsSection(),
            _recommendedSection(),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(height: 28, color: RTheme.divider),
      );

  // ── header: name, price, restaurant, meta ──────────────────

  Widget _headerInfo() {
    final double price =
        double.tryParse(_item['price']?.toString() ?? '0') ?? 0;
    final String rating = _item['rating']?.toString() ?? '4.5';
    final String deliveryTime =
        _item['deliveryTime'] ?? _item['time'] ?? '30-35 Mins';
    final String calories = _item['calories']?.toString() ?? '250 kcal';
    final String restaurant = _item['restaurant'] ?? _item['brand'] ?? 'CartKaro';
    final String totalSells = _item['totalSells'] ?? '';
    final String distance = _item['distance'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // name + wishlist
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RFoodDot(isVeg: _isVeg, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_item['name'] ?? 'Item', style: RTheme.headingLg),
              ),
              const SizedBox(width: 8),
              ValueListenableBuilder<Set<String>>(
                valueListenable: watchlistNotifier,
                builder: (_, wishSet, __) {
                  final wishlisted =
                      wishSet.contains(_item['id']?.toString() ?? '');
                  return RWishlistButton(
                    itemId: _item['id']?.toString() ?? '',
                    isWishlisted: wishlisted,
                    onTap: _toggleWishlist,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 6),

          // restaurant • distance • totalSells
          Row(
            children: [
              const Icon(Icons.storefront_outlined,
                  size: 13, color: RTheme.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  [
                    restaurant,
                    if (distance.isNotEmpty) distance,
                    if (totalSells.isNotEmpty) totalSells,
                  ].join('  •  '),
                  style: RTheme.caption,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // price
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text('From: ', style: RTheme.bodyReg),
              Text(
                '₹${price.toStringAsFixed(2)}',
                style: RTheme.priceLg,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // rating / time / calories
          RMetaRow(
            rating: rating,
            deliveryTime: deliveryTime,
            calories: calories,
          ),
        ],
      ),
    );
  }

  // ── description ────────────────────────────────────────────

  Widget _descriptionSection() {
    final String desc = _item['description'] ??
        'Freshly prepared with the finest ingredients.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Description', style: RTheme.headingMd),
          const SizedBox(height: 8),
          RExpandableDescription(text: desc),
        ],
      ),
    );
  }

  // ── variant selector ───────────────────────────────────────

  Widget _variantSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Size / Variant', style: RTheme.headingMd),
          const SizedBox(height: 10),
          RVariantSelector(
            variants: _variants,
            selectedIndex: _variantIndex,
            onSelected: (i) {
              HapticFeedback.selectionClick();
              setState(() {
                _variantIndex = i;
                _quantity = 1;
              });
            },
          ),
        ],
      ),
    );
  }

  // ── reviews ────────────────────────────────────────────────

  Widget _reviewsSection() {
    if (_reviews.isEmpty) return const SizedBox.shrink();
    final String ratingStr = _item['rating']?.toString() ?? '4.5';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RSectionTitle(
          title: 'Reviews',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star_rounded,
                  color: RTheme.starColor, size: 14),
              const SizedBox(width: 3),
              Text(
                ratingStr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: RTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: _reviews
                .map((r) => RReviewCard(review: r as Map<String, dynamic>))
                .toList(),
          ),
        ),
      ],
    );
  }

  // ── recommended / people also ordered ─────────────────────

  Widget _recommendedSection() {
    final recs = _recommended;
    if (recs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RSectionTitle(title: 'People Also Ordered'),
        SizedBox(
          height: 195,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final rec = recs[i];
              final String recId = rec['id']?.toString() ?? '';

              // Wrap in ValueListenableBuilder to make the Wishlist Heart dynamic
              return ValueListenableBuilder<Set<String>>(
                valueListenable: watchlistNotifier,
                builder: (context, wishSet, _) {
                  
                  // Create a mutable copy of the item so we can inject the 'isWishlisted' property for the UI
                  final Map<String, dynamic> itemWithWishlist = Map<String, dynamic>.from(rec);
                  itemWithWishlist['isWishlisted'] = wishSet.contains(recId);

                  return RRecommendedCard(
                    item: itemWithWishlist,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, anim, __) =>
                              RestaurantItemDetailsScreen(item: rec),
                          transitionsBuilder: (_, anim, __, child) =>
                              FadeTransition(opacity: anim, child: child),
                        ),
                      );
                    },
                    // 🔥 CART ADD LOGIC 
                    onAdd: () {
                      HapticFeedback.mediumImpact();
                      final current = Map<String, int>.from(restaurantCartNotifier.value);
                      final String recCartId = '$recId|0'; // Assuming variant index 0 for quick add
                      
                      current[recCartId] = (current[recCartId] ?? 0) + 1;
                      restaurantCartNotifier.value = current;
                      
                      _snack('${rec['name']} added to cart');
                    },
                    // 🔥 WISHLIST LOGIC
                    onWishlist: () {
                      HapticFeedback.lightImpact();
                      final set = Set<String>.from(watchlistNotifier.value);
                      
                      if (set.contains(recId)) {
                        set.remove(recId);
                        _snack('Removed from wishlist');
                      } else {
                        set.add(recId);
                        _snack('${rec['name']} added to wishlist ❤️');
                      }
                      
                      watchlistNotifier.value = set;
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}