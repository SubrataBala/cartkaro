// lib/widgets/medical_item_details_widgets.dart
// FILE 1 — Create this first.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class MedicineModel {
  final String id;
  final String name;
  final String manufacturer;
  final String description;
  final double price;
  final double mrp;
  final int discountPercent;
  final List<String> imagePaths;
  final bool inStock;
  final bool prescriptionRequired;
  final String composition;
  final List<String> uses;
  final List<String> sideEffects;
  final String safetyAdvice;
  final String dosageInstructions;
  final String storageInformation;
  final String manufacturerInfo;

  const MedicineModel({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.description,
    required this.price,
    required this.mrp,
    required this.discountPercent,
    required this.imagePaths,
    this.inStock = true,
    this.prescriptionRequired = false,
    this.composition = '',
    this.uses = const [],
    this.sideEffects = const [],
    this.safetyAdvice = '',
    this.dosageInstructions = '',
    this.storageInformation = '',
    this.manufacturerInfo = '',
  });
}

class MedicineReview {
  final String id;
  final String userName;
  final String avatarInitials;
  final double rating;
  final String reviewText;
  final String date;
  final Color avatarColor;

  const MedicineReview({
    required this.id,
    required this.userName,
    required this.avatarInitials,
    required this.rating,
    required this.reviewText,
    required this.date,
    required this.avatarColor,
  });
}

class MedicineFeature {
  final IconData icon;
  final String label;
  final Color color;

  const MedicineFeature({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class MedicineVariant {
  final String label;
  final double price;
  final bool selected;

  const MedicineVariant({
    required this.label,
    required this.price,
    this.selected = false,
  });
}

// ─────────────────────────────────────────────
// THEME
// ─────────────────────────────────────────────

class MedicalTheme {
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF1976D2);
  static const Color primarySurface = Color(0xFFE3F2FD);
  static const Color background = Color(0xFFF8F9FC);
  static const Color surface = Colors.white;
  static const Color accent = Color(0xFF2E7D32);
  static const Color accentLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFF57F17);
  static const Color textPrimary = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
  static const Color discountRed = Color(0xFFD32F2F);

  static TextStyle get displayLarge => const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    height: 1.25,
    letterSpacing: -0.5,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.2,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
  );

  static TextStyle get priceDisplay => const TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w800,
    color: primary,
    letterSpacing: -1,
  );

  static TextStyle get mrpStyle => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textMuted,
    decoration: TextDecoration.lineThrough,
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get sectionDecoration => BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: border, width: 1),
  );
}

// ─────────────────────────────────────────────
// MEDICINE IMAGE CAROUSEL
// ─────────────────────────────────────────────

class MedicineImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final String heroTag;
  final double height;

  const MedicineImageCarousel({
    super.key,
    required this.imagePaths,
    required this.heroTag,
    this.height = 0.42,
  });

  @override
  State<MedicineImageCarousel> createState() => _MedicineImageCarouselState();
}

class _MedicineImageCarouselState extends State<MedicineImageCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _bgController;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeOut,
    );
    _bgController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    final images = widget.imagePaths.isEmpty
        ? ['assets/images/medicine_placeholder.png']
        : widget.imagePaths;

    return Container(
      height: screenH * widget.height,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative circular gradient background
          Positioned.fill(
            child: FadeTransition(
              opacity: _bgAnimation,
              child: Center(
                child: Container(
                  width: screenH * widget.height * 0.85,
                  height: screenH * widget.height * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [MedicalTheme.primarySurface, Colors.white],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Page view
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (ctx, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: i == 0
                    ? Hero(
                        tag: widget.heroTag,
                        child: _buildImageWidget(images[i]),
                      )
                    : _buildImageWidget(images[i]),
              );
            },
          ),

          // Dot indicators
          Positioned(
            bottom: 16,
            child: _PageIndicators(count: images.length, current: _currentPage),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String path) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const _MedicinePlaceholderImage(),
    );
  }
}

class _MedicinePlaceholderImage extends StatelessWidget {
  const _MedicinePlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.medication_rounded,
        size: 100,
        color: MedicalTheme.primary.withOpacity(0.3),
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  final int count;
  final int current;

  const _PageIndicators({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 20 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active
                ? MedicalTheme.primary
                : MedicalTheme.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// GLASSMORPHIC APP BAR BUTTON
// ─────────────────────────────────────────────

class MedicalAppBarButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final Color? activeColor;

  const MedicalAppBarButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
    this.activeColor,
  });

  @override
  State<MedicalAppBarButton> createState() => _MedicalAppBarButtonState();
}

class _MedicalAppBarButtonState extends State<MedicalAppBarButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.88,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: widget.active
                    ? (widget.activeColor ?? MedicalTheme.discountRed)
                    : MedicalTheme.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BADGE CHIP
// ─────────────────────────────────────────────

class MedicalBadgeChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const MedicalBadgeChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SECTION TITLE
// ─────────────────────────────────────────────

class MedicalSectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const MedicalSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: MedicalTheme.titleLarge),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MedicalTheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// ANIMATED EXPANSION TILE
// ─────────────────────────────────────────────

class MedicalExpansionTile extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const MedicalExpansionTile({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  State<MedicalExpansionTile> createState() => _MedicalExpansionTileState();
}

class _MedicalExpansionTileState extends State<MedicalExpansionTile>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _ctrl;
  late Animation<double> _expand;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: widget.initiallyExpanded ? 1.0 : 0.0,
    );
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _rotate = Tween(begin: 0.0, end: 0.5).animate(_expand);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MedicalTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MedicalTheme.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(widget.title, style: MedicalTheme.titleMedium),
                  ),
                  RotationTransition(
                    turns: _rotate,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: MedicalTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expand,
            child: Column(
              children: [
                Divider(height: 1, color: MedicalTheme.border),
                Padding(padding: const EdgeInsets.all(16), child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RATING ROW
// ─────────────────────────────────────────────

class MedicalRatingRow extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double starSize;

  const MedicalRatingRow({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.starSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final filled = i < rating.floor();
          final half = !filled && i < rating;
          return Icon(
            filled
                ? Icons.star_rounded
                : half
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded,
            color: const Color(0xFFF59E0B),
            size: starSize,
          );
        }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: starSize - 2,
            fontWeight: FontWeight.w700,
            color: MedicalTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '($reviewCount reviews)',
          style: TextStyle(
            fontSize: starSize - 3,
            color: MedicalTheme.textMuted,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// REVIEW CARD
// ─────────────────────────────────────────────

class MedicalReviewCard extends StatelessWidget {
  final MedicineReview review;

  const MedicalReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MedicalTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MedicalTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: review.avatarColor,
                child: Text(
                  review.avatarInitials,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: MedicalTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      review.date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: MedicalTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              MedicalRatingRow(
                rating: review.rating,
                reviewCount: 0,
                starSize: 14,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review.reviewText, style: MedicalTheme.bodyLarge),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RELATED MEDICINE CARD
// ─────────────────────────────────────────────

class RelatedMedicineCard extends StatefulWidget {
  final MedicineModel medicine;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const RelatedMedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  State<RelatedMedicineCard> createState() => _RelatedMedicineCardState();
}

class _RelatedMedicineCardState extends State<RelatedMedicineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          width: 150,
          decoration: MedicalTheme.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Hero(
                tag: 'medicine_${widget.medicine.id}',
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    color: MedicalTheme.primarySurface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        widget.medicine.imagePaths.isNotEmpty
                            ? widget.medicine.imagePaths.first
                            : 'assets/images/medicine_placeholder.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.medication_rounded,
                          size: 48,
                          color: MedicalTheme.primary.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Info
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 120, // Fixed height
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Medicine Name
                      SizedBox(
                        height: 34, // fixed height for all names
                        child: Text(
                          widget.medicine.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: MedicalTheme.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Manufacturer
                      SizedBox(
                        height: 14,
                        child: Text(
                          widget.medicine.manufacturer,
                          style: const TextStyle(
                            fontSize: 10,
                            color: MedicalTheme.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const Spacer(),

                      // Price Row
                      Row(
                        children: [
                          Text(
                            '₹${widget.medicine.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: MedicalTheme.primary,
                            ),
                          ),

                          const Spacer(),

                          if (widget.medicine.discountPercent > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: MedicalTheme.accentLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${widget.medicine.discountPercent}%',
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: MedicalTheme.accent,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      _AddCartBtn(onTap: widget.onAddToCart),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCartBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _AddCartBtn({required this.onTap});

  @override
  State<_AddCartBtn> createState() => _AddCartBtnState();
}

class _AddCartBtnState extends State<_AddCartBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.9,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) {
        _ctrl.forward();
        widget.onTap();
        HapticFeedback.lightImpact();
      },
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: MedicalTheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              'Add',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM BAR
// ─────────────────────────────────────────────

class MedicalBottomBar extends StatefulWidget {
  final VoidCallback onAddToCart;
  final bool isInCart;

  const MedicalBottomBar({
    super.key,
    required this.onAddToCart,
    this.isInCart = false,
  });

  @override
  State<MedicalBottomBar> createState() => _MedicalBottomBarState();
}

class _MedicalBottomBarState extends State<MedicalBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scale = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: MedicalTheme.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.reverse(),
        onTapUp: (_) {
          _ctrl.forward();
          widget.onAddToCart();
          HapticFeedback.mediumImpact();
        },
        onTapCancel: () => _ctrl.forward(),
        child: ScaleTransition(
          scale: _scale,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: MedicalTheme.primary,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: MedicalTheme.primary.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cart icon on the left
                Positioned(
                  left: 8,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                // Label
                Text(
                  widget.isInCart ? 'Go To Cart' : 'Add To Cart',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                // Arrow on the right
                const Positioned(
                  right: 20,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ANIMATED QUANTITY SELECTOR
// ─────────────────────────────────────────────

class AnimatedQuantitySelector extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const AnimatedQuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  @override
  State<AnimatedQuantitySelector> createState() =>
      _AnimatedQuantitySelectorState();
}

class _AnimatedQuantitySelectorState extends State<AnimatedQuantitySelector>
    with TickerProviderStateMixin {
  late AnimationController _numCtrl;
  late Animation<double> _numAnim;
  int? _prevQty;

  @override
  void initState() {
    super.initState();
    _numCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _numAnim = CurvedAnimation(parent: _numCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _numCtrl.dispose();
    super.dispose();
  }

  void _animate() {
    _numCtrl.reset();
    _numCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QtyButton(
          icon: Icons.remove,
          enabled: widget.quantity > widget.min,
          onTap: () {
            if (widget.quantity > widget.min) {
              _animate();
              widget.onChanged(widget.quantity - 1);
            }
          },
        ),
        AnimatedBuilder(
          animation: _numAnim,
          builder: (_, child) {
            return Transform.scale(
              scale: 0.9 + (_numAnim.value * 0.1),
              child: child,
            );
          },
          child: SizedBox(
            width: 44,
            child: Center(
              child: Text(
                '${widget.quantity}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: MedicalTheme.textPrimary,
                ),
              ),
            ),
          ),
        ),
        _QtyButton(
          icon: Icons.add,
          enabled: widget.quantity < widget.max,
          onTap: () {
            if (widget.quantity < widget.max) {
              _animate();
              widget.onChanged(widget.quantity + 1);
            }
          },
        ),
      ],
    );
  }
}

class _QtyButton extends StatefulWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _QtyButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_QtyButton> createState() => _QtyButtonState();
}

class _QtyButtonState extends State<_QtyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.88,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _ctrl.reverse() : null,
      onTapUp: widget.enabled
          ? (_) {
              _ctrl.forward();
              widget.onTap();
              HapticFeedback.selectionClick();
            }
          : null,
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: widget.enabled
                ? MedicalTheme.primarySurface
                : MedicalTheme.divider,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: widget.enabled
                ? MedicalTheme.primary
                : MedicalTheme.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// EXPANDABLE TEXT
// ─────────────────────────────────────────────

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.maxLines = 3});

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            style: MedicalTheme.bodyLarge,
            maxLines: widget.maxLines,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(widget.text, style: MedicalTheme.bodyLarge),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 260),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Read less' : 'Read more',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: MedicalTheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// DELIVERY ROW
// ─────────────────────────────────────────────

class MedicalDeliveryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const MedicalDeliveryRow({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
