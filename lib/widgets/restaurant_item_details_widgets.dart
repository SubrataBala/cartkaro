import 'package:flutter/material.dart';
import '../screens/app_models.dart';
import 'shared_card_widgets.dart';

// ─────────────────────────────────────────────────────────────
// DESIGN TOKENS
// ─────────────────────────────────────────────────────────────

abstract class RTheme {
  static const Color primary = Color(0xFFE53935);
  static const Color primaryLight = Color(0xFFFDECEA);
  static const Color background = Color(0xFFF8F8F8);
  static const Color surface = Colors.white;
  static const Color divider = Color(0xFFEEEEEE);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color starColor = Color(0xFFFFA000);
  static const Color vegColor = Color(0xFF2E7D32);
  static const Color nonVegColor = Color(0xFFB71C1C);

  static const double rSm = 8.0;
  static const double rMd = 12.0;
  static const double rLg = 16.0;
  static const double rXL = 24.0;
  static const double rImg = 28.0;
  static const double rTop = 32.0;
  static const double rMax = 100.0;

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];

  static const TextStyle headingLg = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: -0.3,
  );
  static const TextStyle headingMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
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
    fontSize: 21,
    fontWeight: FontWeight.w800,
    color: primary,
  );
  static const TextStyle priceSm = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: textPrimary,
  );
}

// ─────────────────────────────────────────────────────────────
// 1. IMAGE CAROUSEL
// ─────────────────────────────────────────────────────────────

class RImageCarousel extends StatefulWidget {
  const RImageCarousel({
    super.key,
    required this.images,
    required this.heroTag,
    required this.height,
  });

  final List<String> images;
  final String heroTag;
  final double height;

  @override
  State<RImageCarousel> createState() => _RImageCarouselState();
}

class _RImageCarouselState extends State<RImageCarousel> {
  final PageController _ctrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // ── The Image Itself
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(RTheme.rImg),
                bottomRight: Radius.circular(RTheme.rImg),
              ),
              child: PageView.builder(
                controller: _ctrl,
                itemCount: widget.images.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => Hero(
                  tag: i == 0 ? widget.heroTag : '${widget.heroTag}_$i',
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(color: RTheme.background),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Image.asset(
                        widget.images[i],
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.fastfood,
                          size: 90,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Top Gradient
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.40), Colors.transparent],
                ),
              ),
            ),
          ),

          // ── Page Dots
          if (widget.images.length > 1)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (i) {
                  final active = _page == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active
                          ? RTheme.primary
                          : Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(RTheme.rMax),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 3,
                        ),
                      ],
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

// ─────────────────────────────────────────────────────────────
// 2. GLASS APP-BAR ICON BUTTON
// ─────────────────────────────────────────────────────────────

class RGlassButton extends StatelessWidget {
  const RGlassButton({
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 19, color: iconColor ?? Colors.white),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 3. VEG / NON-VEG INDICATOR
// ─────────────────────────────────────────────────────────────

class RFoodDot extends StatelessWidget {
  const RFoodDot({super.key, required this.isVeg, this.size = 16});

  final bool isVeg;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? RTheme.vegColor : RTheme.nonVegColor;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.11),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.4),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Container(
          width: size * 0.44,
          height: size * 0.44,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 4. META ROW
// ─────────────────────────────────────────────────────────────

class RMetaRow extends StatelessWidget {
  const RMetaRow({
    super.key,
    required this.rating,
    required this.deliveryTime,
    required this.calories,
  });

  final String rating;
  final String deliveryTime;
  final String calories;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaChip(
          icon: Icons.star_rounded,
          iconColor: RTheme.starColor,
          label: rating,
        ),
        _divider(),
        _MetaChip(
          icon: Icons.access_time_rounded,
          iconColor: RTheme.textSecondary,
          label: deliveryTime,
        ),
        _divider(),
        _MetaChip(
          icon: Icons.local_fire_department_rounded,
          iconColor: RTheme.textSecondary,
          label: calories,
        ),
      ],
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 16,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: RTheme.divider,
  );
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: iconColor),
        const SizedBox(width: 4),
        Text(label, style: RTheme.bodyMd),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 5. EXPANDABLE DESCRIPTION
// ─────────────────────────────────────────────────────────────

class RExpandableDescription extends StatefulWidget {
  const RExpandableDescription({
    super.key,
    required this.text,
    this.maxLines = 3,
  });

  final String text;
  final int maxLines;

  @override
  State<RExpandableDescription> createState() => _RExpandableDescriptionState();
}

class _RExpandableDescriptionState extends State<RExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topLeft,
          child: Text(
            widget.text,
            style: RTheme.bodyReg,
            maxLines: _expanded ? null : widget.maxLines,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Read Less' : 'Read More',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: RTheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 6. VARIANT SELECTOR
// ─────────────────────────────────────────────────────────────

class RVariantSelector extends StatelessWidget {
  const RVariantSelector({
    super.key,
    required this.variants,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List variants;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: variants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          final label = variants[i]['weight']?.toString() ?? 'Option $i';
          final price = variants[i]['price']?.toString() ?? '';
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? RTheme.primaryLight : RTheme.surface,
                borderRadius: BorderRadius.circular(RTheme.rMax),
                border: Border.all(
                  color: selected ? RTheme.primary : RTheme.divider,
                  width: selected ? 1.6 : 1,
                ),
              ),
              child: Text(
                price.isNotEmpty ? '$label  ₹$price' : label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? RTheme.primary : RTheme.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 7. SECTION TITLE
// ─────────────────────────────────────────────────────────────

class RSectionTitle extends StatelessWidget {
  const RSectionTitle({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: RTheme.headingMd),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 8. REVIEW CARD
// ─────────────────────────────────────────────────────────────

class RReviewCard extends StatelessWidget {
  const RReviewCard({super.key, required this.review});

  final Map<String, dynamic> review;

  @override
  Widget build(BuildContext context) {
    final String name = review['userName'] ?? 'User';
    final String initials =
        review['initials'] ?? name.substring(0, 1).toUpperCase();
    final double rating =
        double.tryParse(review['rating']?.toString() ?? '5') ?? 5;
    final String comment = review['comment'] ?? '';
    final String date = review['date'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: RTheme.background,
        borderRadius: BorderRadius.circular(RTheme.rMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: RTheme.primaryLight,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: RTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: RTheme.bodyMd),
                    Text(date, style: RTheme.caption),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: RTheme.starColor,
                    size: 14,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: RTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(comment, style: RTheme.bodyReg),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 9. RECOMMENDED ITEM CARD 
// ─────────────────────────────────────────────────────────────

class RRecommendedCard extends StatelessWidget {
  const RRecommendedCard({
    super.key, 
    required this.item, 
    required this.onTap,
    this.onAdd,       // 🔥 New Optional ADD callback
    this.onWishlist,  // 🔥 New Optional Wishlist callback
  });

  final Map<String, dynamic> item;
  final VoidCallback onTap;
  final VoidCallback? onAdd;
  final VoidCallback? onWishlist;

  static const double _imageHeight = 88.0;

  @override
  Widget build(BuildContext context) {
    final bool isVeg =
        item['isVeg'] == true ||
        item['isVeg']?.toString().toLowerCase() == 'true';
    final double price = double.tryParse(item['price']?.toString() ?? '0') ?? 0;
    final String rating = item['rating']?.toString() ?? '4.5';
    final bool isWishlisted = item['isWishlisted'] == true;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 148,
        decoration: BoxDecoration(
          color: RTheme.surface,
          borderRadius: BorderRadius.circular(RTheme.rMd),
          boxShadow: RTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── IMAGE WITH WISHLIST BUTTON OVERLAY
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(RTheme.rMd),
                    topRight: Radius.circular(RTheme.rMd),
                  ),
                  child: Hero(
                    key: ValueKey('hero_${item['id']}'),
                    tag: 'restaurant_item_${item['id']}',
                    child: Container(
                      width: 148,
                      height: _imageHeight,
                      color: RTheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          item['image'] ?? 'assets/images/food_placeholder.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.fastfood,
                            size: 35,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔥 NEW FLOATING WISHLIST BUTTON
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlist ?? () { print("Wishlist Tapped"); },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 14,
                        color: isWishlisted ? RTheme.primary : RTheme.textHint,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── INFO & ADD BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RFoodDot(isVeg: isVeg, size: 12),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          item['name'] ?? '',
                          style: RTheme.bodyMd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: RTheme.starColor,
                      ),
                      const SizedBox(width: 3),
                      Text(rating, style: RTheme.caption),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // 🔥 NEW ROW WITH PRICE AND ADD BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${price.toStringAsFixed(0)}', style: RTheme.priceSm),
                      
                      // THE ADD BUTTON
                      InkWell(
                        onTap: onAdd ?? () { print("Add Tapped"); },
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: RTheme.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: RTheme.primary.withOpacity(0.3)),
                          ),
                          child: const Text(
                            'ADD',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: RTheme.primary,
                            ),
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

// ─────────────────────────────────────────────────────────────
// 10. STICKY BOTTOM BAR
// ─────────────────────────────────────────────────────────────

class RStickyBottomBar extends StatelessWidget {
  const RStickyBottomBar({
    super.key,
    required this.cartItemId,
    required this.totalPrice,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  final String cartItemId;
  final double totalPrice;
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

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
        color: RTheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: RTheme.divider),
              borderRadius: BorderRadius.circular(RTheme.rMax),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _QtyBtn(
                  icon: Icons.remove,
                  onTap: onDecrement,
                  enabled: quantity > 1,
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    quantity.toString().padLeft(2, '0'),
                    textAlign: TextAlign.center,
                    style: RTheme.bodyMd,
                  ),
                ),
                _QtyBtn(
                  icon: Icons.add,
                  onTap: onIncrement,
                  enabled: true,
                  filled: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _PressableScale(
              onTap: onAddToCart,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: RTheme.primary,
                  borderRadius: BorderRadius.circular(RTheme.rMax),
                  boxShadow: [
                    BoxShadow(
                      color: RTheme.primary.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Add to Cart  •  ₹${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
    this.filled = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(RTheme.rMax),
      child: Container(
        margin: const EdgeInsets.all(3),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: filled ? RTheme.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled
              ? Colors.white
              : (enabled ? RTheme.primary : RTheme.textHint),
        ),
      ),
    );
  }
}

class _PressableScale extends StatefulWidget {
  const _PressableScale({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// 11. WISHLIST HEART BUTTON
// ─────────────────────────────────────────────────────────────

class RWishlistButton extends StatefulWidget {
  const RWishlistButton({
    super.key,
    required this.itemId,
    required this.isWishlisted,
    required this.onTap,
    this.glass = false,
  });

  final String itemId;
  final bool isWishlisted;
  final VoidCallback onTap;
  final bool glass;

  @override
  State<RWishlistButton> createState() => _RWishlistButtonState();
}

class _RWishlistButtonState extends State<RWishlistButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      lowerBound: 0.80,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    _ctrl.forward(from: 0.80);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.isWishlisted
        ? Icons.favorite_rounded
        : Icons.favorite_border_rounded;
    final color = widget.isWishlisted ? RTheme.primary : Colors.white;

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _ctrl,
        child: widget.glass
            ? RGlassButton(icon: icon, iconColor: color, onTap: () {})
            : Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: RTheme.background,
                  shape: BoxShape.circle,
                  boxShadow: RTheme.cardShadow,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: widget.isWishlisted
                      ? RTheme.primary
                      : RTheme.textSecondary,
                ),
              ),
      ),
    );
  }
}