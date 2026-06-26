import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  Design Tokens
// ─────────────────────────────────────────────
const Color kBg       = Color(0xFFFFFFFF);
const Color kSurface  = Color(0xFFFAFAFA);
const Color kBorder   = Color(0xFFEBEBEB);
const Color kTextDark = Color(0xFF222222);
const Color kMuted    = Color(0xFF999999);
const Color kStar     = Color(0xFFFFB300);
const String kFont    = 'Poppins';

const _kGreen = Color(0xFF4CAF50); // Grocery
const _kRed   = Color(0xFFE53935); // Restaurant
const _kBlue  = Color(0xFF1565C0); // Medical

// ─────────────────────────────────────────────
//  Dummy Orders Data
// ─────────────────────────────────────────────
final List<Map<String, dynamic>> _groceryOrders = [
  {
    'id': '#GR-8892', 'date': '12 Jun, 2026', 'store': 'CartKaro Fresh', 'total': '₹850',
    'items': [
      {'name': 'Organic Basmati Rice 5kg', 'image': '🌾', 'qty': '1 Pack'},
      {'name': 'Fresh Whole Milk 1L', 'image': '🥛', 'qty': '2 Bottles'},
    ]
  },
  {
    'id': '#GR-8841', 'date': '05 Jun, 2026', 'store': 'Daily Needs Grocery', 'total': '₹420',
    'items': [
      {'name': 'Farm Fresh Eggs (12 pcs)', 'image': '🥚', 'qty': '1 Dozen'},
      {'name': 'Alphonso Mangoes 1kg', 'image': '🥭', 'qty': '1 Kg'},
      {'name': 'Multigrain Bread Loaf', 'image': '🍞', 'qty': '1 Loaf'},
    ]
  },
];

final List<Map<String, dynamic>> _restaurantOrders = [
  {
    'id': '#RT-5521', 'date': '10 Jun, 2026', 'store': 'Biryani Blues', 'total': '₹450',
    'items': [
      {'name': 'Chicken Dum Biryani (Half)', 'image': '🍛', 'qty': '1 Plate'},
      {'name': 'Raita', 'image': '🥣', 'qty': '1 Bowl'},
    ]
  },
  {
    'id': '#RT-5490', 'date': '02 Jun, 2026', 'store': 'Domino\'s Pizza', 'total': '₹899',
    'items': [
      {'name': 'Farmhouse Veg Pizza', 'image': '🍕', 'qty': '1 Medium'},
      {'name': 'Choco Lava Cake', 'image': '🍫', 'qty': '2 Pieces'},
    ]
  },
];

final List<Map<String, dynamic>> _medicalOrders = [
  {
    'id': '#MD-2201', 'date': '11 Jun, 2026', 'store': 'Apollo Pharmacy', 'total': '₹210',
    'items': [
      {'name': 'Dolo 650mg Tablets', 'image': '💊', 'qty': '1 Strip'},
      {'name': 'Glucon-D Sachet Pack', 'image': '🟡', 'qty': '1 Pack'},
    ]
  },
  {
    'id': '#MD-2188', 'date': '28 May, 2026', 'store': 'City Medico', 'total': '₹550',
    'items': [
      {'name': 'Vitamin D3 Capsules 60K', 'image': '🔵', 'qty': '1 Bottle'},
      {'name': 'Surgical Mask (Pack of 10)', 'image': '😷', 'qty': '1 Pack'},
      {'name': 'Betadine Antiseptic 50ml', 'image': '🩺', 'qty': '1 Bottle'},
    ]
  },
];

// ─────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────
class _ReviewState {
  int stars;
  String review;
  _ReviewState({this.stars = 0, this.review = ''});
}

// ─────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────
class RatingReviewScreen extends StatefulWidget {
  final Color themeColor;

  const RatingReviewScreen({super.key, required this.themeColor});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  late List<Map<String, dynamic>> _orders;
  Map<String, dynamic>? _selectedOrder; // Agar null hai, toh Order List dikhegi
  List<_ReviewState> _reviews = [];
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    // Theme color se orders decide karo
    if (widget.themeColor == _kRed) {
      _orders = _restaurantOrders;
    } else if (widget.themeColor == _kBlue) {
      _orders = _medicalOrders;
    } else {
      _orders = _groceryOrders;
    }
  }

  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = kTextDark, double? letterSpacing, double? height}) =>
      TextStyle(fontFamily: kFont, fontSize: size, fontWeight: weight, color: color, letterSpacing: letterSpacing, height: height);

  String get _appLabel {
    if (widget.themeColor == _kRed)  return 'Restaurant';
    if (widget.themeColor == _kBlue) return 'Medical';
    return 'Grocery';
  }

  String get _placeholder {
    if (widget.themeColor == _kRed)  return 'How was the taste & delivery?';
    if (widget.themeColor == _kBlue) return 'Share your experience with this medicine...';
    return 'Share your experience with this product...';
  }

  String _starLabel(int stars) {
    switch (stars) {
      case 1: return 'Poor';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Very Good';
      case 5: return 'Excellent';
      default: return 'Tap to rate';
    }
  }

  // ── Handlers ──
  void _openOrderToReview(Map<String, dynamic> order) {
    setState(() {
      _selectedOrder = order;
      _reviews = List.generate((order['items'] as List).length, (_) => _ReviewState());
      _submitted = false;
    });
  }

  void _handleBack() {
    if (_submitted) {
      // Success screen pe back dabane se wapas order list par jayega
      setState(() {
        _selectedOrder = null;
        _submitted = false;
      });
    } else if (_selectedOrder != null) {
      // Agar item review page par hai, toh order list par wapas aayega
      setState(() => _selectedOrder = null);
    } else {
      // Agar order list par hai, toh pichli screen par wapas chala jayega
      Navigator.pop(context);
    }
  }

  void _submitAll() {
    final allRated = _reviews.every((r) => r.stars > 0);
    if (!allRated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please rate all items before submitting!', style: _s(size: 13, color: Colors.white)),
          backgroundColor: widget.themeColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    HapticFeedback.mediumImpact();
    setState(() => _submitted = true);
  }

  // ════════════════════════════════════════════════════════════
  //  UI: STEP 1 - ORDERS LIST
  // ════════════════════════════════════════════════════════════
  Widget _buildOrdersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text('Past Orders to Review', style: _s(size: 16, weight: FontWeight.w700)),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              final order = _orders[index];
              final itemsCount = (order['items'] as List).length;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kBorder),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: widget.themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(order['id'], style: _s(size: 12, weight: FontWeight.w700, color: widget.themeColor)),
                        ),
                        Text(order['date'], style: _s(size: 12, color: kMuted, weight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          height: 48, width: 48,
                          decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.storefront_outlined, color: widget.themeColor, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order['store'], style: _s(size: 15, weight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('$itemsCount Items • ${order['total']}', style: _s(size: 13, color: kMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _openOrderToReview(order),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: widget.themeColor, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Rate Order', style: _s(size: 13, weight: FontWeight.w600, color: widget.themeColor)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  //  UI: STEP 2 - ITEMS REVIEW
  // ════════════════════════════════════════════════════════════
  Widget _buildItemsReview() {
    final items = _selectedOrder!['items'] as List<dynamic>;

    return Column(
      children: [
        // ── Order Summary Banner ──
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: widget.themeColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.themeColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.receipt_long_rounded, size: 20, color: widget.themeColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedOrder!['store'], style: _s(size: 13, weight: FontWeight.w700, color: widget.themeColor)),
                    const SizedBox(height: 2),
                    Text('${_selectedOrder!['id']} • ${items.length} Items', style: _s(size: 11, color: kTextDark.withOpacity(0.6))),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Scrollable Items Cards ──
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (ctx, i) => _buildItemCard(i, items[i]),
          ),
        ),

        // ── Submit Button ──
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          decoration: BoxDecoration(
            color: kBg,
            border: const Border(top: BorderSide(color: kBorder)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -4))],
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.themeColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Submit All Reviews', style: _s(size: 15, weight: FontWeight.w600, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(int index, dynamic item) {
    final review = _reviews[index];
    final ctrl = TextEditingController(text: review.review);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: widget.themeColor.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Text(item['image'], style: const TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name'], style: _s(size: 14, weight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('Qty: ${item['qty']}', style: _s(size: 12, color: kMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: kBorder),
            const SizedBox(height: 16),
            Row(
              children: [
                Row(
                  children: List.generate(5, (si) {
                    final filled = si < review.stars;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _reviews[index].stars = si + 1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(filled ? Icons.star_rounded : Icons.star_outline_rounded, size: 28, color: filled ? kStar : kBorder),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 10),
                Text(_starLabel(review.stars), style: _s(size: 12, weight: FontWeight.w600, color: review.stars > 0 ? kStar : kMuted)),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: ctrl,
              maxLines: 2,
              style: _s(size: 13),
              onChanged: (val) => _reviews[index].review = val,
              decoration: InputDecoration(
                hintText: _placeholder,
                hintStyle: _s(size: 12, color: kMuted),
                filled: true,
                fillColor: kSurface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: widget.themeColor, width: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  UI: STEP 3 - SUCCESS
  // ════════════════════════════════════════════════════════════
  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(color: widget.themeColor.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.check_circle_rounded, size: 60, color: widget.themeColor),
            ),
            const SizedBox(height: 28),
            Text('Thank You!', style: _s(size: 28, weight: FontWeight.w800, color: kTextDark)),
            const SizedBox(height: 12),
            Text(
              'Your ratings & reviews for\n${_selectedOrder!['store']}\nhave been submitted successfully.',
              textAlign: TextAlign.center,
              style: _s(size: 14, color: kMuted, height: 1.6),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleBack,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text('View Other Orders', style: _s(size: 15, weight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      child: PopScope(
        canPop: _selectedOrder == null && !_submitted,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _handleBack();
          }
        },
        child: Scaffold(
          backgroundColor: kSurface,
          appBar: AppBar(
            backgroundColor: kBg,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: kTextDark),
              onPressed: _handleBack,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rating & Review', style: _s(size: 16, weight: FontWeight.w700)),
                Text(_appLabel, style: _s(size: 11, color: widget.themeColor, weight: FontWeight.w600)),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: kBorder),
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _submitted
                ? _buildSuccess()
                : _selectedOrder == null
                    ? _buildOrdersList()
                    : _buildItemsReview(),
          ),
        ),
      ),
    );
  }
}