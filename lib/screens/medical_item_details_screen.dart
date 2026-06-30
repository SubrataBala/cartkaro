// lib/screens/medical_item_details_screen.dart
// FILE 2 — Create this second.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/medical_item_details_widgets.dart';
import '../screens/app_models.dart';

// ─────────────────────────────────────────────
// SAMPLE DATA  (replace with real data from medical_data.dart)
// ─────────────────────────────────────────────

const List<MedicineModel> _allMedicines = [
  MedicineModel(
    id: 'med_001',
    name: 'Paracetamol 650 Tablet',
    manufacturer: 'Sun Pharma',
    description:
        'Paracetamol 650 is used to relieve pain and reduce fever. It works by blocking the release of certain chemical messengers that cause pain and fever. It is one of the most commonly used medicines for mild to moderate pain and is suitable for adults and children.',
    price: 89,
    mrp: 120,
    discountPercent: 26,
    imagePaths: ['assets/images/paracetamol.png'],
    prescriptionRequired: false,
    composition: 'Paracetamol 650 mg',
    uses: [
      'Relief of mild to moderate pain',
      'Reduction of fever',
      'Headache',
      'Toothache',
      'Backache',
      'Minor arthritis pain',
    ],
    sideEffects: [
      'Nausea',
      'Vomiting',
      'Allergic reaction (rare)',
      'Liver damage on overdose',
    ],
    safetyAdvice:
        'Do not exceed 4g per day. Avoid alcohol. Use with caution in patients with liver or kidney disease.',
    dosageInstructions:
        'Adults: 650 mg every 4–6 hours as needed. Maximum 4 doses in 24 hours. Children: as directed by physician.',
    storageInformation:
        'Store below 25°C away from direct sunlight and moisture. Keep out of reach of children.',
    manufacturerInfo:
        'Sun Pharmaceutical Industries Ltd., Vadodara, Gujarat, India.',
  ),
  MedicineModel(
    id: 'med_002',
    name: 'Azithromycin 500 mg',
    manufacturer: 'Cipla',
    description:
        'Azithromycin is a broad-spectrum antibiotic used to treat various bacterial infections including respiratory tract, skin, and ear infections.',
    price: 145,
    mrp: 180,
    discountPercent: 19,
    imagePaths: ['assets/images/azithromycin.png'],
    prescriptionRequired: true,
    composition: 'Azithromycin 500 mg',
    uses: [
      'Bacterial infections',
      'Respiratory tract infections',
      'Skin infections',
    ],
    sideEffects: ['Nausea', 'Diarrhea', 'Abdominal pain', 'Headache'],
    safetyAdvice:
        'Complete the full course even if you feel better. Avoid antacids.',
    dosageInstructions:
        'As directed by physician. Typically 500 mg once daily for 3–5 days.',
    storageInformation: 'Store below 30°C, away from moisture and heat.',
    manufacturerInfo: 'Cipla Ltd., Mumbai, Maharashtra, India.',
  ),
  MedicineModel(
    id: 'med_003',
    name: 'Vitamin D3 + K2 Capsule',
    manufacturer: 'Himalaya',
    description:
        'A synergistic combination of Vitamin D3 and K2 that supports bone health, immune function, and calcium metabolism.',
    price: 320,
    mrp: 399,
    discountPercent: 20,
    imagePaths: ['assets/images/vitamin_d3.png'],
    prescriptionRequired: false,
    composition:
        'Cholecalciferol (Vitamin D3) 60,000 IU + Menaquinone-7 (Vitamin K2) 90 mcg',
    uses: [
      'Bone strength',
      'Calcium absorption',
      'Immune support',
      'Vitamin D deficiency',
    ],
    sideEffects: ['Nausea on overdose', 'Hypercalcemia (rare)'],
    safetyAdvice:
        'Take with a fatty meal for best absorption. Consult physician for dosage.',
    dosageInstructions: 'One capsule once weekly or as directed by physician.',
    storageInformation: 'Store in a cool, dry place below 25°C.',
    manufacturerInfo: 'The Himalaya Drug Company, Bengaluru, Karnataka, India.',
  ),
  MedicineModel(
    id: 'med_004',
    name: 'Cetirizine 10 mg Tablet',
    manufacturer: 'Dr. Reddy\'s',
    description:
        'Cetirizine is an antihistamine used for relief of allergy symptoms such as runny nose, watery eyes, and skin rashes.',
    price: 32,
    mrp: 45,
    discountPercent: 29,
    imagePaths: ['assets/images/cetirizine.png'],
    prescriptionRequired: false,
    composition: 'Cetirizine Hydrochloride 10 mg',
    uses: ['Allergic rhinitis', 'Urticaria', 'Hay fever', 'Itching'],
    sideEffects: ['Drowsiness', 'Dry mouth', 'Fatigue', 'Headache'],
    safetyAdvice: 'May cause drowsiness. Avoid driving or operating machinery.',
    dosageInstructions: 'Adults and children over 12: 10 mg once daily.',
    storageInformation: 'Store below 30°C, away from light and moisture.',
    manufacturerInfo:
        'Dr. Reddy\'s Laboratories Ltd., Hyderabad, Telangana, India.',
  ),
  MedicineModel(
    id: 'med_005',
    name: 'Omeprazole 20 mg',
    manufacturer: 'Abbott',
    description:
        'Omeprazole reduces the amount of acid your stomach produces, used for acid reflux, ulcers, and GERD.',
    price: 78,
    mrp: 98,
    discountPercent: 20,
    imagePaths: ['assets/images/omeprazole.png'],
    prescriptionRequired: false,
    composition: 'Omeprazole 20 mg',
    uses: ['Acid reflux', 'GERD', 'Peptic ulcer', 'Stomach ulcer'],
    sideEffects: ['Headache', 'Diarrhea', 'Nausea', 'Abdominal pain'],
    safetyAdvice:
        'Take 30 minutes before meals. Long-term use: consult a physician.',
    dosageInstructions: '20 mg once daily before breakfast for 4–8 weeks.',
    storageInformation: 'Store below 25°C in a dry place.',
    manufacturerInfo: 'Abbott India Limited, Mumbai, Maharashtra, India.',
  ),
];

final List<MedicineReview> _sampleReviews = [
  const MedicineReview(
    id: 'rev_1',
    userName: 'Rahul Sharma',
    avatarInitials: 'RS',
    rating: 5.0,
    reviewText:
        'Very effective medicine. Worked within 30 minutes for my headache. Packaging was also intact.',
    date: 'Jun 15, 2025',
    avatarColor: Color(0xFF1565C0),
  ),
  const MedicineReview(
    id: 'rev_2',
    userName: 'Priya Mehta',
    avatarInitials: 'PM',
    rating: 4.5,
    reviewText:
        'Good product, genuine medicine. Delivery was fast and on time. Highly recommended!',
    date: 'May 28, 2025',
    avatarColor: Color(0xFF2E7D32),
  ),
  const MedicineReview(
    id: 'rev_3',
    userName: 'Amit Verma',
    avatarInitials: 'AV',
    rating: 4.0,
    reviewText:
        'Works as expected. Price is also reasonable. Overall happy with the purchase.',
    date: 'Apr 10, 2025',
    avatarColor: Color(0xFFF57F17),
  ),
];

// ─────────────────────────────────────────────
// SCREEN
// ─────────────────────────────────────────────

/// Navigate to this screen from medical_item_card.dart:
///
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => MedicalItemDetailsScreen(
///       medicine: yourMedicineModel,
///     ),
///   ),
/// );
///
/// Or with a Hero animation — wrap the tapped image in a Hero with
/// tag 'medicine_${medicine.id}' and pass the same medicine object here.

class MedicalItemDetailsScreen extends StatefulWidget {
  final MedicineModel medicine;

  const MedicalItemDetailsScreen({super.key, required this.medicine});

  @override
  State<MedicalItemDetailsScreen> createState() =>
      _MedicalItemDetailsScreenState();
}

class _MedicalItemDetailsScreenState extends State<MedicalItemDetailsScreen>
    with TickerProviderStateMixin {
  // ── State ──────────────────────────────────
  int _quantity = 1;

  bool get _isWishlisted =>
      watchlistNotifier.value.contains(widget.medicine.id);

  bool get _isInCart =>
      medicalCartNotifier.value.containsKey(widget.medicine.id);

  late AnimationController _entryCtrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────
  double get _totalPrice => widget.medicine.price * _quantity;

  List<MedicineModel> get _similarMedicines =>
      _allMedicines.where((m) => m.id != widget.medicine.id).take(5).toList();

  void _toggleWishlist() {
    HapticFeedback.selectionClick();

    final favs = Set<String>.from(watchlistNotifier.value);

    if (favs.contains(widget.medicine.id)) {
      favs.remove(widget.medicine.id);
      _showSnack('Removed from wishlist');
    } else {
      favs.add(widget.medicine.id);
      _showSnack('Added to wishlist');
    }

    watchlistNotifier.value = favs;

    setState(() {});
  }

  void _addToCart() {
    final current = {...medicalCartNotifier.value};

    current[widget.medicine.id] =
        (current[widget.medicine.id] ?? 0) + _quantity;

    medicalCartNotifier.value = current;

    setState(() {});

    _showSnack('Added ${_quantity}x ${widget.medicine.name} to cart');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: MedicalTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _share() {
    HapticFeedback.selectionClick();
    // TODO: share widget.medicine.name + price
  }

  void _openRelated(MedicineModel m) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MedicalItemDetailsScreen(medicine: m)),
    );
  }

  // ── Build ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedicalTheme.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Image carousel
              SliverToBoxAdapter(child: _buildCarousel()),

              // Content
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildInfoSection(),
                    const SizedBox(height: 20),
                    _buildPriceQtySection(),
                    const SizedBox(height: 20),
                    _buildDeliverySection(),
                    const SizedBox(height: 28),
                    _buildMedicalDetailsSection(),
                    const SizedBox(height: 28),
                    _buildSimilarSection(),
                    const SizedBox(height: 28),
                    _buildReviewsSection(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MedicalBottomBar(
        onAddToCart: _addToCart,
        isInCart: _isInCart,
      ),
    );
  }

  // ── App Bar ─────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: MedicalAppBarButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ),
      title: const Text(
        'Details',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: MedicalTheme.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        MedicalAppBarButton(
          icon: _isWishlisted
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          onTap: _toggleWishlist,
          active: _isWishlisted,
          activeColor: const Color(0xFFE53935),
        ),
        const SizedBox(width: 10),
        MedicalAppBarButton(icon: Icons.ios_share_rounded, onTap: _share),
        const SizedBox(width: 16),
      ],
    );
  }

  // ── Carousel ────────────────────────────────
  Widget _buildCarousel() {
    return MedicineImageCarousel(
      imagePaths: widget.medicine.imagePaths,
      heroTag: 'medicine_${widget.medicine.id}',
    );
  }

  // ── Info ────────────────────────────────────
  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges row
        Row(
          children: [
            if (!widget.medicine.inStock)
              const MedicalBadgeChip(
                label: 'Out of Stock',
                backgroundColor: Color(0xFFFFEBEE),
                textColor: Color(0xFFD32F2F),
                icon: Icons.remove_shopping_cart_rounded,
              )
            else
              const MedicalBadgeChip(
                label: 'In Stock',
                backgroundColor: Color(0xFFE8F5E9),
                textColor: Color(0xFF2E7D32),
                icon: Icons.check_circle_outline_rounded,
              ),
            const SizedBox(width: 8),
            if (widget.medicine.prescriptionRequired)
              const MedicalBadgeChip(
                label: 'Rx Required',
                backgroundColor: Color(0xFFFFF8E1),
                textColor: Color(0xFFF57F17),
                icon: Icons.medical_services_outlined,
              ),
            const Spacer(),
            if (widget.medicine.discountPercent > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: MedicalTheme.accentLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.medicine.discountPercent}% OFF',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: MedicalTheme.accent,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Name
        Text(widget.medicine.name, style: MedicalTheme.displayLarge),
        const SizedBox(height: 6),

        // Manufacturer
        Row(
          children: [
            const Icon(
              Icons.business_rounded,
              size: 14,
              color: MedicalTheme.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              widget.medicine.manufacturer,
              style: const TextStyle(
                fontSize: 13,
                color: MedicalTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Rating
        const MedicalRatingRow(rating: 4.3, reviewCount: 128),
        const SizedBox(height: 14),

        // Description
        ExpandableText(text: widget.medicine.description),
      ],
    );
  }

  // ── Price + Qty ──────────────────────────────
  Widget _buildPriceQtySection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: MedicalTheme.cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Price block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MedicalTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: Text(
                    '₹${_totalPrice.toStringAsFixed(2)}',
                    key: ValueKey(_totalPrice),
                    style: MedicalTheme.priceDisplay,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'MRP ₹${widget.medicine.mrp.toStringAsFixed(0)}',
                      style: MedicalTheme.mrpStyle,
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: MedicalTheme.accent,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Inclusive of all taxes',
                  style: TextStyle(
                    fontSize: 11,
                    color: MedicalTheme.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Quantity selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: MedicalTheme.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              AnimatedQuantitySelector(
                quantity: _quantity,
                onChanged: (v) => setState(() => _quantity = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Delivery ────────────────────────────────
  Widget _buildDeliverySection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: MedicalTheme.cardDecoration,
      child: Column(
        children: const [
          MedicalDeliveryRow(
            icon: Icons.local_shipping_rounded,
            label: 'Free Delivery on this order',
            color: MedicalTheme.primary,
          ),
          SizedBox(height: 14),
          MedicalDeliveryRow(
            icon: Icons.timer_outlined,
            label: 'Express delivery in 10 minutes',
            color: MedicalTheme.accent,
          ),
          SizedBox(height: 14),
          MedicalDeliveryRow(
            icon: Icons.verified_rounded,
            label: '100% Genuine Product',
            color: Color(0xFFF57F17),
          ),
        ],
      ),
    );
  }

  // ── Medical Details ──────────────────────────
  Widget _buildMedicalDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MedicalSectionTitle(title: 'Product Details'),
        const SizedBox(height: 14),
        _expansionGap(
          MedicalExpansionTile(
            title: '💊 Composition',
            initiallyExpanded: true,
            child: Text(
              widget.medicine.composition.isEmpty
                  ? 'Information not available.'
                  : widget.medicine.composition,
              style: MedicalTheme.bodyLarge,
            ),
          ),
        ),
        _expansionGap(
          MedicalExpansionTile(
            title: '✅ Uses',
            child: widget.medicine.uses.isEmpty
                ? Text(
                    'Information not available.',
                    style: MedicalTheme.bodyLarge,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.medicine.uses
                        .map(
                          (u) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: MedicalTheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(u, style: MedicalTheme.bodyLarge),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
        _expansionGap(
          MedicalExpansionTile(
            title: '⚠️ Side Effects',
            child: widget.medicine.sideEffects.isEmpty
                ? Text(
                    'Information not available.',
                    style: MedicalTheme.bodyLarge,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.medicine.sideEffects
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 14,
                                  color: Color(0xFFF57F17),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(s, style: MedicalTheme.bodyLarge),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
        _expansionGap(
          MedicalExpansionTile(
            title: '🛡️ Safety Advice',
            child: Text(
              widget.medicine.safetyAdvice.isEmpty
                  ? 'Information not available.'
                  : widget.medicine.safetyAdvice,
              style: MedicalTheme.bodyLarge,
            ),
          ),
        ),
        _expansionGap(
          MedicalExpansionTile(
            title: '💉 Dosage Instructions',
            child: Text(
              widget.medicine.dosageInstructions.isEmpty
                  ? 'Information not available.'
                  : widget.medicine.dosageInstructions,
              style: MedicalTheme.bodyLarge,
            ),
          ),
        ),
        _expansionGap(
          MedicalExpansionTile(
            title: '🗄️ Storage Information',
            child: Text(
              widget.medicine.storageInformation.isEmpty
                  ? 'Information not available.'
                  : widget.medicine.storageInformation,
              style: MedicalTheme.bodyLarge,
            ),
          ),
        ),
        MedicalExpansionTile(
          title: '🏭 Manufacturer Information',
          child: Text(
            widget.medicine.manufacturerInfo.isEmpty
                ? 'Information not available.'
                : widget.medicine.manufacturerInfo,
            style: MedicalTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _expansionGap(Widget child) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: child);
  }

  // ── Similar Medicines ────────────────────────
  Widget _buildSimilarSection() {
    final similar = _similarMedicines;
    if (similar.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MedicalSectionTitle(title: 'Similar Medicines'),
        const SizedBox(height: 14),
        SizedBox(
          height: 252,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: similar.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final m = similar[i];
              return RelatedMedicineCard(
                medicine: m,
                onTap: () => _openRelated(m),
                onAddToCart: () {
                  final current = {...medicalCartNotifier.value};

                  current[m.id] = (current[m.id] ?? 0) + 1;

                  medicalCartNotifier.value = current;

                  _showSnack('${m.name} added to cart');

                  setState(() {});
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Reviews ─────────────────────────────────
  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MedicalSectionTitle(
          title: 'Customer Reviews',
          actionLabel: 'View all',
          onAction: () {},
        ),
        const SizedBox(height: 4),
        const MedicalRatingRow(rating: 4.3, reviewCount: 128),
        const SizedBox(height: 14),
        ..._sampleReviews.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MedicalReviewCard(review: r),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// INTEGRATION NOTES
// ─────────────────────────────────────────────
//
// 1. CREATE FIRST : medical_item_details_widgets.dart
// 2. CREATE SECOND: medical_item_details_screen.dart
//
// 3. FILES TO MODIFY:
//    • medical_item_card.dart — Add onTap that navigates to
//      MedicalItemDetailsScreen(medicine: yourModel)
//    • medical_data.dart — Map your existing MedicalItem model to
//      MedicineModel (or adapt the screen to use your existing model directly)
//    • app_models.dart — No changes required unless you want to extend
//      MedicineModel there instead
//    • main.dart or routes file — No changes needed; push navigation is used
//
// 4. HOW TO NAVIGATE FROM medical_item_card.dart:
//
//    InkWell(
//      onTap: () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (_) => MedicalItemDetailsScreen(
//              medicine: MedicineModel(
//                id: item.id,
//                name: item.name,
//                manufacturer: item.manufacturer,
//                description: item.description,
//                price: item.price,
//                mrp: item.mrp,
//                discountPercent: item.discount,
//                imagePaths: [item.imagePath],
//                prescriptionRequired: item.rxRequired,
//              ),
//            ),
//          ),
//        );
//      },
//      child: Hero(
//        tag: 'medicine_${item.id}',
//        child: Image.asset(item.imagePath),
//      ),
//    )
//
// ─────────────────────────────────────────────
