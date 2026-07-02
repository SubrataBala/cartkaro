import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'app_models.dart';
import '../widgets/shared_card_widgets.dart';
import 'address_screen.dart';
import 'login_screen.dart';

class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) => child;
}

class CartGrocery extends StatefulWidget {
  const CartGrocery({super.key});
  @override
  State<CartGrocery> createState() => _CartGroceryState();
}

class _CartGroceryState extends State<CartGrocery> {
  final Color _themeColor = kGroceryGreen;
  final ValueNotifier<Map<String, int>> _activeCartNotifier = groceryCartNotifier;
  final int _tabIndex = 0;

  int _selectedTip = 0;
  bool _noBagOpted = false;

  List<Map<String, dynamic>> get _crossSellItems {
    final currentTabData = globalAllCategoryData[_tabIndex] ?? {};
    List<Map<String, dynamic>> items = [];
    for (var categoryItems in currentTabData.values) {
      items.addAll(categoryItems);
      if (items.length >= 6) break;
    }
    return items.take(6).toList();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: ValueListenableBuilder(
        valueListenable: _activeCartNotifier,
        builder: (context, Map<String, int> cart, _) {
        if (cart.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.withOpacity(0.3)),
                const SizedBox(height: 16),
                const Text("Your Grocery Cart is empty", style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text("Add items to start building your cart", style: TextStyle(color: Color(0xFF757575), fontSize: 13)),
              ],
            ),
          );
        }

        final currentTabData = globalAllCategoryData[_tabIndex] ?? {};
        double itemTotal = 0;
        List<Widget> cartListWidgets = [];

        cart.forEach((cartItemId, count) {
          final parts = cartItemId.split('|');
          final baseId = parts[0];
          final vIndex = parts.length > 1 ? int.parse(parts[1]) : 0;

          Map<String, dynamic>? foundItem;
          for (var categoryItems in currentTabData.values) {
            for (var item in categoryItems) {
              if (item['id'] == baseId) { foundItem = item; break; }
            }
            if (foundItem != null) break;
          }

          if (foundItem != null) {
            final variants = foundItem.containsKey('variants') ? foundItem['variants'] : [{'weight': foundItem['weight'], 'price': foundItem['price']}];
            final variant = variants[vIndex];
            final price = double.parse(variant['price'].toString());
            final oldPrice = price + 20;
            itemTotal += price * count;

            cartListWidgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                      child: Image.asset(foundItem['image'], height: 40, width: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(foundItem['name'], style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(variant['weight'], style: const TextStyle(color: Color(0xFF757575), fontSize: 11)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SharedCartButton(itemId: cartItemId, themeColor: _themeColor, cartNotifier: _activeCartNotifier),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('₹$oldPrice', style: const TextStyle(color: Color(0xFF757575), fontSize: 10, decoration: TextDecoration.lineThrough)),
                            const SizedBox(width: 4),
                            Text('₹$price', style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        });

        double handlingFee = 11.0;
        double deliveryFee = itemTotal < 200 ? 30.0 : 0.0;
        double grandTotal = itemTotal + handlingFee + deliveryFee + _selectedTip;

        return ScrollConfiguration(
          behavior: NoJellyScrollBehavior(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    const Text('Checkout', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 22, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: _themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('${cart.values.fold(0, (a, b) => a + b)} Items', style: TextStyle(color: _themeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildDeliveryDetailsCard(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('12 Mins', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.w900)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                                child: const Row(
                                  children: [
                                    Icon(Icons.bolt, color: Colors.green, size: 12),
                                    Text('Superfast', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey.withOpacity(0.15), height: 30),
                          ...cartListWidgets,
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSimpleActionCard(Icons.local_offer_outlined, 'Apply Coupon', Colors.blueAccent),
                    const SizedBox(height: 16),
                    _buildSimpleActionCard(Icons.receipt_long_outlined, 'Add GSTIN', Colors.indigo, subtitle: 'Claim GST credit up to 18% on the order'),
                    const SizedBox(height: 24),
                    const Text('Did you forget?', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),

                    // ✅ Restaurant-style cross-sell cards with variant dropdown + SnackBar popup
                    SizedBox(
                      height: 330,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemCount: _crossSellItems.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return _GroceryCrossSellCard(
                            item: _crossSellItems[index],
                            themeColor: _themeColor,
                            cartNotifier: _activeCartNotifier,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.15))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Text("I don't need a bag!", style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 14, fontWeight: FontWeight.w800)),
                                    SizedBox(width: 6),
                                    Icon(Icons.eco, color: Colors.green, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text("Take the pledge for a greener future - opt for a no bag delivery!", style: TextStyle(color: Color(0xFF757575), fontSize: 11, height: 1.3)),
                              ],
                            ),
                          ),
                          Switch(
                            value: _noBagOpted,
                            activeColor: _themeColor,
                            onChanged: (val) => setState(() => _noBagOpted = val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DELIVERY TIP', style: TextStyle(color: Color(0xFF757575), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                          const SizedBox(height: 8),
                          const Text('A small tip, a big gesture! Tip your delivery partner to show your appreciation.', style: TextStyle(color: Color(0xFF757575), fontSize: 11, height: 1.3)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTipChip(10),
                              _buildTipChip(20, isMostTipped: true),
                              _buildTipChip(30),
                              _buildTipChip(0, label: 'Clear'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('BILL DETAILS', style: TextStyle(color: Color(0xFF757575), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                          const SizedBox(height: 16),
                          _buildBillRow('Item Total', itemTotal, oldAmount: itemTotal + 20),
                          _buildBillRow('Handling Fee', handlingFee, oldAmount: handlingFee + 2),
                          Divider(color: Colors.grey.withOpacity(0.15), height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Delivery Partner Tip', style: TextStyle(color: Color(0xFF757575), fontSize: 13, fontWeight: FontWeight.w500)),
                              _selectedTip > 0
                                  ? Text('₹$_selectedTip', style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13, fontWeight: FontWeight.w600))
                                  : const Text('Add a tip', style: TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.delivery_dining, color: Color(0xFF757575), size: 16),
                                  SizedBox(width: 6),
                                  Text('Delivery Partner Fee', style: TextStyle(color: Color(0xFF757575), fontSize: 13, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              itemTotal < 200
                                  ? const Text('₹30', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 13, fontWeight: FontWeight.w600))
                                  : Row(
                                      children: [
                                        Text('₹30', style: TextStyle(color: const Color(0xFF757575).withOpacity(0.5), fontSize: 12, decoration: TextDecoration.lineThrough)),
                                        const SizedBox(width: 6),
                                        const Text('FREE', style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                            ],
                          ),
                          if (itemTotal < 200)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 22),
                              child: Text('Shop for ₹${(200 - itemTotal).toStringAsFixed(0)} more to get FREE delivery', style: TextStyle(color: _themeColor, fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                          Divider(color: Colors.grey.withOpacity(0.15), height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('To Pay', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.w900)),
                              Text('₹${grandTotal.toStringAsFixed(1)}', style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 18, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _themeColor,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          if (selectedAddressNotifier.value == -1 || globalSavedAddresses.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add/select a delivery address first!')));
                            return;
                          }
                          if (FirebaseAuth.instance.currentUser == null) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proceeding to payment gateway...')));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Proceed to Pay  ₹${grandTotal.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      ),
    ),
  );
  }

  Widget _buildTipChip(int amount, {bool isMostTipped = false, String? label}) {
    bool isSelected = _selectedTip == amount && label == null;
    return GestureDetector(
      onTap: () => setState(() => _selectedTip = amount),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent),
            ),
            child: Text(label ?? '₹$amount', style: TextStyle(color: isSelected ? Colors.blueAccent : const Color(0xFF1A1A1A), fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          if (isMostTipped)
            Positioned(
              bottom: -8, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(4)),
                child: const Text('Most tipped', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSimpleActionCard(IconData icon, String title, Color iconColor, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.15))),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 15, fontWeight: FontWeight.w800)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF757575), fontSize: 11)),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF757575)),
        ],
      ),
    );
  }

  Widget _buildBillRow(String title, double amount, {double? oldAmount}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF757575), fontSize: 13, fontWeight: FontWeight.w500)),
          Row(
            children: [
              if (oldAmount != null) ...[
                Text('₹${oldAmount.toStringAsFixed(1)}', style: TextStyle(color: const Color(0xFF757575).withOpacity(0.5), fontSize: 12, decoration: TextDecoration.lineThrough)),
                const SizedBox(width: 6),
              ],
              Text('₹${amount.toStringAsFixed(1)}', style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryDetailsCard() {
    return ValueListenableBuilder<int>(
      valueListenable: selectedAddressNotifier,
      builder: (context, selectedIndex, _) {
        if (selectedIndex == -1 || globalSavedAddresses.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.redAccent.withOpacity(0.5))),
            child: Column(
              children: [
                const Icon(Icons.location_off_rounded, color: Colors.redAccent, size: 32),
                const SizedBox(height: 12),
                const Text('Delivery Address Missing', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Please select an address to proceed with your order.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF757575), fontSize: 12)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _themeColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressScreen(isDark: false, themeColor: _themeColor))),
                    child: const Text('Add Delivery Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        }

        final addr = globalSavedAddresses[selectedIndex];
        IconData typeIcon = addr.type == 'Home'
            ? Icons.home_rounded
            : addr.type == 'Office'
                ? Icons.work_outline
                : Icons.location_on_outlined;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withOpacity(0.15))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(typeIcon, color: _themeColor, size: 22),
                      const SizedBox(width: 8),
                      Text('Delivering to ${addr.type}', style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressScreen(isDark: false, themeColor: _themeColor))),
                    child: Text('CHANGE', style: TextStyle(color: _themeColor, fontSize: 12, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(addr.completeAddress, style: const TextStyle(color: Color(0xFF757575), fontSize: 12, height: 1.4)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, color: Color(0xFF757575), size: 16),
                    const SizedBox(width: 8),
                    Text(addr.fullName, style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 12, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    const Icon(Icons.phone_outlined, color: Color(0xFF757575), size: 16),
                    const SizedBox(width: 8),
                    Text(addr.phone, style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// ✅ Grocery Cross-sell Card — exact same style as CartRestaurant
// ============================================================
class _GroceryCrossSellCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final Color themeColor;
  final ValueNotifier<Map<String, int>> cartNotifier;

  const _GroceryCrossSellCard({
    required this.item,
    required this.themeColor,
    required this.cartNotifier,
  });

  @override
  State<_GroceryCrossSellCard> createState() => _GroceryCrossSellCardState();
}

class _GroceryCrossSellCardState extends State<_GroceryCrossSellCard> {
  int _selectedVariantIndex = 0;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final Color themeColor = widget.themeColor;

    final List<dynamic> variants = item.containsKey('variants')
        ? item['variants']
        : [{'weight': item['weight'] ?? '', 'price': item['price']}];

    final selectedVariant = variants[_selectedVariantIndex];
    final double price = double.tryParse(selectedVariant['price'].toString()) ?? 0;
    final double oldPrice = price + 20;
    final int discount = ((oldPrice - price) / oldPrice * 100).round();
    final String itemId = item['id'].toString();
    final String cartKey = '$itemId|$_selectedVariantIndex';

    return Container(
      width: 165,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image + badges ──
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FFF4), // light green tint for grocery
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.all(14),
                child: Image.asset(item['image'], fit: BoxFit.contain),
              ),
              // Discount badge
              Positioned(
                top: 8, left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                  child: Text(
                    '$discount% OFF',
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.2),
                  ),
                ),
              ),
              // Heart — watchlist
              Positioned(
                top: 6, right: 6,
                child: ValueListenableBuilder<Set<String>>(
                  valueListenable: watchlistNotifier,
                  builder: (context, watchlist, _) {
                    final bool isWishlisted = watchlist.contains(itemId);
                    return GestureDetector(
                      onTap: () {
                        final updated = Set<String>.from(watchlistNotifier.value);
                        isWishlisted ? updated.remove(itemId) : updated.add(itemId);
                        watchlistNotifier.value = updated;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)],
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 14,
                          color: isWishlisted ? themeColor : Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ── Content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    item['name'],
                    style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 12, fontWeight: FontWeight.w800, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 13),
                      const SizedBox(width: 3),
                      const Text('4.5', style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 10, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 4),
                      const Text('1.2k+ bought', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 9)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Variant dropdown
                  if (variants.length > 1)
                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: themeColor.withOpacity(0.6)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedVariantIndex,
                          isDense: true,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: themeColor, size: 18),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedVariantIndex = val);
                          },
                          items: List.generate(variants.length, (i) {
                            return DropdownMenuItem<int>(
                              value: i,
                              child: Text(
                                variants[i]['weight'].toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: themeColor, fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                            );
                          }),
                        ),
                      ),
                    )
                  else
                    Text(
                      selectedVariant['weight'].toString(),
                      style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const Spacer(),

                  // Price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${oldPrice.toStringAsFixed(0)}',
                            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 10, decoration: TextDecoration.lineThrough),
                          ),
                          Text(
                            '₹${price.toStringAsFixed(0)}',
                            style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 15, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'You save ₹${(oldPrice - price).toStringAsFixed(0)}',
                            style: TextStyle(color: themeColor, fontSize: 8, fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ✅ ADD button with SnackBar popup
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        side: BorderSide(color: themeColor, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        final current = widget.cartNotifier.value[cartKey] ?? 0;
                        final updated = Map<String, int>.from(widget.cartNotifier.value);
                        updated[cartKey] = current + 1;
                        widget.cartNotifier.value = updated;
                        // ✅ Same SnackBar as CartRestaurant
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item['name']} (${selectedVariant['weight']}) added!'),
                            duration: const Duration(seconds: 1),
                            backgroundColor: themeColor,
                          ),
                        );
                      },
                      child: Text(
                        'ADD',
                        style: TextStyle(color: themeColor, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}