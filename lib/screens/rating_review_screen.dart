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

// ─────────────────────────────────────────────
//  Dummy Data per App Type
// ─────────────────────────────────────────────
const _kGreen = Color(0xFF4CAF50);
const _kRed   = Color(0xFFE53935);
const _kBlue  = Color(0xFF1565C0);

// Grocery dummy items
const _groceryItems = [
  {'name': 'Organic Basmati Rice 5kg',    'image': '🌾', 'qty': '1 Pack'},
  {'name': 'Fresh Whole Milk 1L',          'image': '🥛', 'qty': '2 Bottles'},
  {'name': 'Extra Virgin Olive Oil 500ml', 'image': '🫒', 'qty': '1 Bottle'},
  {'name': 'Multigrain Bread Loaf',        'image': '🍞', 'qty': '1 Loaf'},
  {'name': 'Farm Fresh Eggs (12 pcs)',     'image': '🥚', 'qty': '1 Dozen'},
  {'name': 'Alphonso Mangoes 1kg',         'image': '🥭', 'qty': '1 Kg'},
  {'name': 'Greek Yogurt 400g',            'image': '🫙', 'qty': '2 Cups'},
  {'name': 'Cold Pressed Coconut Oil',     'image': '🥥', 'qty': '1 Jar'},
  {'name': 'Baby Spinach 250g',            'image': '🥬', 'qty': '1 Pack'},
  {'name': 'Dark Chocolate 70% 100g',      'image': '🍫', 'qty': '2 Bars'},
];

// Restaurant dummy items
const _restaurantItems = [
  {'name': 'Butter Chicken (Half)',        'image': '🍛', 'qty': '1 Plate'},
  {'name': 'Garlic Naan',                  'image': '🫓', 'qty': '3 Pieces'},
  {'name': 'Dal Makhani',                  'image': '🫕', 'qty': '1 Bowl'},
  {'name': 'Chicken Biryani',             'image': '🍚', 'qty': '1 Full'},
  {'name': 'Paneer Tikka Starter',         'image': '🧀', 'qty': '1 Plate'},
  {'name': 'Mango Lassi',                  'image': '🥤', 'qty': '2 Glasses'},
  {'name': 'Tandoori Roti',               'image': '🫓', 'qty': '4 Pieces'},
  {'name': 'Raita',                        'image': '🥣', 'qty': '1 Bowl'},
  {'name': 'Gulab Jamun',                 'image': '🍮', 'qty': '2 Pieces'},
  {'name': 'Cold Coffee',                 'image': '☕', 'qty': '1 Glass'},
];

// Medical dummy items
const _medicalItems = [
  {'name': 'Dolo 650mg Tablets',          'image': '💊', 'qty': '1 Strip'},
  {'name': 'Vitamin D3 Capsules 60K',     'image': '🔵', 'qty': '4 Capsules'},
  {'name': 'Azithromycin 500mg',          'image': '💊', 'qty': '1 Strip'},
  {'name': 'Cetrizine 10mg Tablets',      'image': '💊', 'qty': '2 Strips'},
  {'name': 'Digene Antacid Syrup',        'image': '🧴', 'qty': '1 Bottle'},
  {'name': 'Betadine Antiseptic 50ml',    'image': '🩺', 'qty': '1 Bottle'},
  {'name': 'Glucon-D Sachet Pack',        'image': '🟡', 'qty': '1 Pack'},
  {'name': 'Omeprazole 20mg Capsules',    'image': '💊', 'qty': '1 Strip'},
  {'name': 'Crocin Advance Tablets',      'image': '💊', 'qty': '2 Strips'},
  {'name': 'Surgical Mask (Pack of 10)',  'image': '😷', 'qty': '1 Pack'},
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
  late List<Map<String, String>> _items;
  late List<_ReviewState> _reviews;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    // Theme color se items decide karo
    if (widget.themeColor == _kRed) {
      _items = List<Map<String, String>>.from(
        _restaurantItems.map((e) => e.cast<String, String>()));
    } else if (widget.themeColor == _kBlue) {
      _items = List<Map<String, String>>.from(
        _medicalItems.map((e) => e.cast<String, String>()));
    } else {
      _items = List<Map<String, String>>.from(
        _groceryItems.map((e) => e.cast<String, String>()));
    }
    _reviews = List.generate(_items.length, (_) => _ReviewState());
  }

  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = kTextDark, double? letterSpacing, double? height}) =>
      TextStyle(fontFamily: kFont, fontSize: size, fontWeight: weight, color: color, letterSpacing: letterSpacing, height: height);

  String get _appLabel {
    if (widget.themeColor == _kRed)  return 'Restaurant';
    if (widget.themeColor == _kBlue) return 'Medical';
    return 'Grocery';
  }

  String get _orderLabel {
    if (widget.themeColor == _kRed)  return 'Rate Your Food';
    if (widget.themeColor == _kBlue) return 'Rate Your Medicines';
    return 'Rate Your Groceries';
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
    HapticFeedback.mediumImpact();
    setState(() => _submitted = true);
  }

  // ── Success Screen ──
  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                color: widget.themeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded, size: 60, color: widget.themeColor),
            ),
            const SizedBox(height: 28),
            Text('Thank You!', style: _s(size: 28, weight: FontWeight.w800, color: kTextDark)),
            const SizedBox(height: 12),
            Text(
              'Your ratings & reviews have been\nsubmitted successfully.',
              textAlign: TextAlign.center,
              style: _s(size: 14, color: kMuted, height: 1.6),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text('Back to Profile', style: _s(size: 15, weight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Star Rating Widget ──
  Widget _buildStars(int index) {
    final current = _reviews[index].stars;
    return Row(
      children: List.generate(5, (si) {
        final filled = si < current;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _reviews[index].stars = si + 1);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 28,
              color: filled ? kStar : kBorder,
            ),
          ),
        );
      }),
    );
  }

  // ── Single Product Card ──
  Widget _buildCard(int index) {
    final item = _items[index];
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
            // ── Product Info Row ──
            Row(
              children: [
                // Emoji avatar
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: widget.themeColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(item['image']!, style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']!, style: _s(size: 14, weight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('Qty: ${item['qty']}', style: _s(size: 12, color: kMuted)),
                    ],
                  ),
                ),
                // Item number badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('#${index + 1}', style: _s(size: 11, weight: FontWeight.w700, color: widget.themeColor)),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: kBorder),
            const SizedBox(height: 16),

            // ── Star Rating ──
            Row(
              children: [
                _buildStars(index),
                const SizedBox(width: 10),
                Text(
                  _starLabel(review.stars),
                  style: _s(
                    size: 12,
                    weight: FontWeight.w600,
                    color: review.stars > 0 ? kStar : kMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Review Text Field ──
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: widget.themeColor, width: 1.5),
                ),
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
      child: Scaffold(
        backgroundColor: kSurface,
        appBar: AppBar(
          backgroundColor: kBg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: kTextDark),
            onPressed: () => Navigator.pop(context),
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
        body: _submitted
            ? _buildSuccess()
            : Column(
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
                              Text(_orderLabel, style: _s(size: 13, weight: FontWeight.w700, color: widget.themeColor)),
                              const SizedBox(height: 2),
                              Text('${_items.length} items from your last order', style: _s(size: 11, color: kMuted)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: widget.themeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('${_items.length} Items', style: _s(size: 11, weight: FontWeight.w700, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),

                  // ── Scrollable Cards ──
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        physics: const ClampingScrollPhysics(),
                        itemCount: _items.length,
                        itemBuilder: (ctx, i) => _buildCard(i),
                      ),
                    ),
                  ),
                ],
              ),

        // ── Submit Button ──
        bottomNavigationBar: _submitted
            ? null
            : Container(
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
      ),
    );
  }
}