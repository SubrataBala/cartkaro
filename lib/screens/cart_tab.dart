import 'package:flutter/material.dart';
import 'app_models.dart';
import '../widgets/adaptive_item_card.dart';
import '../widgets/shared_card_widgets.dart';// ── MAIN FIX: Naye Cards aur SharedCartButton yahan se aayenge ──
import 'address_screen.dart'; 
import 'login_screen.dart';   

// ── JELLY/BOUNCE EFFECT REMOVER ──
class NoJellyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class CartTab extends StatefulWidget {
  final int selectedTab; 
  const CartTab({super.key, required this.selectedTab});

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  // ── Ab ye hamesha 'false' rahega taaki Grocery bhi White dikhe ──
  bool get _isDark => false; 
  
  Color get _bgColor => _isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  Color get _cardBgColor => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _textPrimary => _isDark ? Colors.white : const Color(0xFF1A1A1A); 
  Color get _textSecondary => _isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);
  Color get _borderColor => _isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.15);

  Color get _themeColor {
    if (widget.selectedTab == 1) return const Color(0xFFE53935);
    if (widget.selectedTab == 2) return const Color(0xFF1565C0);
    return const Color(0xFF4CAF50);
  }

  ValueNotifier<Map<String, int>> get _activeCartNotifier {
    if (widget.selectedTab == 1) return restaurantCartNotifier;
    if (widget.selectedTab == 2) return medicalCartNotifier;
    return groceryCartNotifier;
  }

  // ── CART STATE VARIABLES ──
  int _selectedTip = 0;
  bool _noBagOpted = false;

  // ── CROSS SELL ITEMS ("Did you forget?") ──
  List<Map<String, dynamic>> get _crossSellItems {
    final currentTabData = globalAllCategoryData[widget.selectedTab] ?? {};
    List<Map<String, dynamic>> items = [];
    for (var categoryItems in currentTabData.values) {
      items.addAll(categoryItems);
      if (items.length >= 6) break;
    }
    return items.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _activeCartNotifier,
      builder: (context, Map<String, int> cart, _) {
        // ── EMPTY CART STATE ──
        if (cart.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: _textSecondary.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text("Your Cart is empty", style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text("Add items to start building your cart", style: TextStyle(color: _textSecondary, fontSize: 13)),
              ],
            )
          );
        }

        final currentTabData = globalAllCategoryData[widget.selectedTab] ?? {};
        double itemTotal = 0;
        List<Widget> cartListWidgets = [];

        // ── CALCULATE CART ITEMS & TOTAL ──
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
                      decoration: BoxDecoration(color: _isDark ? Colors.white10 : Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                      child: Image.asset(foundItem['image'], height: 40, width: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(foundItem['name'], style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(variant['weight'], style: TextStyle(color: _textSecondary, fontSize: 11)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.bookmark_border, size: 12, color: _textSecondary),
                              const SizedBox(width: 4),
                              Text('Move to watchlist', style: TextStyle(color: _textSecondary, fontSize: 10, decoration: TextDecoration.underline)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // ── MAIN FIX: Using SharedCartButton ──
                        SharedCartButton(itemId: cartItemId, themeColor: _themeColor, cartNotifier: _activeCartNotifier),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text('₹$oldPrice', style: TextStyle(color: _textSecondary, fontSize: 10, decoration: TextDecoration.lineThrough)),
                            const SizedBox(width: 4),
                            Text('₹$price', style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w900)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            );
          }
        });

        // ── BILL CALCULATIONS ──
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
                    Text('Checkout', style: TextStyle(color: _textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: _themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('${cart.values.fold(0, (a, b) => a + b)} Items', style: TextStyle(color: _themeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    )
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(), 
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    
                    // ── 1. DYNAMIC DELIVERY ADDRESS CARD ──
                    _buildDeliveryDetailsCard(),
                    const SizedBox(height: 16),

                    // ── 2. ITEMS CART CARD ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('12 Mins', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w900)),
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
                              )
                            ],
                          ),
                          Divider(color: _borderColor, height: 30),
                          ...cartListWidgets,
                          Divider(color: _borderColor, height: 20),
                          Center(
                            child: TextButton.icon(
                              onPressed: () => Navigator.pop(context), 
                              icon: Icon(Icons.add, color: _textPrimary, size: 16),
                              label: Text('Add more items', style: TextStyle(color: _textPrimary, fontWeight: FontWeight.w600)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 3. SAVINGS & GSTIN ──
                    _buildSimpleActionCard(Icons.local_offer_outlined, 'Apply Coupon', Colors.blueAccent),
                    const SizedBox(height: 16),
                    _buildSimpleActionCard(Icons.receipt_long_outlined, 'Add GSTIN', Colors.indigo, subtitle: 'Claim GST credit up to 18% on the order'),
                    const SizedBox(height: 24),

                    // ── 4. CROSS SELL ──
                    Text('Did you forget?', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 245,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemCount: _crossSellItems.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 140, 
                            // ── MAIN FIX: Using AdaptiveItemCard based on the tab ──
                            child: AdaptiveItemCard(
                              item: _crossSellItems[index], 
                              tabIndex: widget.selectedTab
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── 5. NO BAG PLEDGE ──
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("I don't need a bag!", style: TextStyle(color: _textPrimary, fontSize: 14, fontWeight: FontWeight.w800)),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.eco, color: Colors.green, size: 16),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text("Take the pledge for a greener future - opt for a no bag delivery!", style: TextStyle(color: _textSecondary, fontSize: 11, height: 1.3)),
                              ],
                            ),
                          ),
                          Switch(
                            value: _noBagOpted,
                            activeColor: _themeColor,
                            onChanged: (val) => setState(() => _noBagOpted = val),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 6. DELIVERY TIP ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DELIVERY TIP', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                          const SizedBox(height: 8),
                          Text('A small tip, a big gesture! Tip your delivery partner to show your appreciation for their hard work.', style: TextStyle(color: _textSecondary, fontSize: 11, height: 1.3)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTipChip(10),
                              _buildTipChip(20, isMostTipped: true),
                              _buildTipChip(30),
                              _buildTipChip(0, label: 'Clear'), 
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 7. BILL DETAILS ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BILL DETAILS', style: TextStyle(color: _textSecondary, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                          const SizedBox(height: 16),
                          _buildBillRow('Item Total', itemTotal, oldAmount: itemTotal + 20),
                          _buildBillRow('Handling Fee', handlingFee, oldAmount: handlingFee + 2),
                          Divider(color: _borderColor, height: 30),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Partner Tip', style: TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                              _selectedTip > 0 
                                ? Text('₹$_selectedTip', style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600))
                                : Text('Add a tip', style: TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.delivery_dining, color: _textSecondary, size: 16),
                                  const SizedBox(width: 6),
                                  Text('Delivery Partner Fee', style: TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                                ],
                              ),
                              itemTotal < 200 
                                  ? Text('₹30', style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600))
                                  : Row(
                                      children: [
                                        Text('₹30', style: TextStyle(color: _textSecondary.withOpacity(0.5), fontSize: 12, decoration: TextDecoration.lineThrough)),
                                        const SizedBox(width: 6),
                                        const Text('FREE', style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold)),
                                      ],
                                    )
                            ],
                          ),
                          if (itemTotal < 200)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 22),
                              child: Text('Shop for ₹${(200 - itemTotal).toStringAsFixed(0)} more to get FREE delivery', style: TextStyle(color: _themeColor, fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                          Divider(color: _borderColor, height: 30),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('To Pay', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w900)),
                              Text('₹${grandTotal.toStringAsFixed(1)}', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 8. CANCELLATION NOTE ──
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'NOTE: ', style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(text: 'Orders cannot be cancelled and are non-refundable once packed for delivery.', style: TextStyle(color: _textSecondary, fontWeight: FontWeight.normal)),
                              ]
                            )
                          ),
                          const SizedBox(height: 8),
                          const Text('Read cancellation policy', style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── 9. PROCEED TO CHECKOUT BUTTON (WITH LOGIN & ADDRESS CHECK) ──
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _themeColor, 
                          padding: const EdgeInsets.symmetric(vertical: 18), 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                        ),
                        onPressed: () {
                          // Check 1: Address select kiya hai ya nahi?
                          if (selectedAddressNotifier.value == -1 || globalSavedAddresses.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add/select a delivery address first!')));
                            return;
                          }

                          // Check 2: User logged in hai ya Guest Mode me hai?
                          if (!isUserLoggedIn) {
                            // Guest hai, Login par bhejo
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                            return;
                          }

                          // Agar Dono Theek Hain, Toh Payment/Checkout page par bhejo
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
      }
    );
  }

  // ── HELPER WIDGETS ──
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
              color: isSelected ? Colors.blueAccent.withOpacity(0.1) : _isDark ? Colors.white10 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent),
            ),
            child: Text(label ?? '₹$amount', style: TextStyle(color: isSelected ? Colors.blueAccent : _textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
          ),
          if (isMostTipped)
            Positioned(
              bottom: -8, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(4)),
                child: const Text('Most tipped', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildSimpleActionCard(IconData icon, String title, Color iconColor, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: _textPrimary, fontSize: 15, fontWeight: FontWeight.w800)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: _textSecondary, fontSize: 11)),
                ]
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: _textSecondary),
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
          Text(title, style: TextStyle(color: _textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
          Row(
            children: [
              if (oldAmount != null) ...[
                Text('₹${oldAmount.toStringAsFixed(1)}', style: TextStyle(color: _textSecondary.withOpacity(0.5), fontSize: 12, decoration: TextDecoration.lineThrough)),
                const SizedBox(width: 6),
              ],
              Text('₹${amount.toStringAsFixed(1)}', style: TextStyle(color: _textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }

  // ── DYNAMIC DELIVERY ADDRESS CARD ──
  Widget _buildDeliveryDetailsCard() {
    return ValueListenableBuilder<int>(
      valueListenable: selectedAddressNotifier,
      builder: (context, selectedIndex, _) {
        
        // IF NO ADDRESS IS SELECTED
        if (selectedIndex == -1 || globalSavedAddresses.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.redAccent.withOpacity(0.5))),
            child: Column(
              children: [
                Icon(Icons.location_off_rounded, color: Colors.redAccent, size: 32),
                const SizedBox(height: 12),
                Text('Delivery Address Missing', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Please select an address to proceed with your order.', textAlign: TextAlign.center, style: TextStyle(color: _textSecondary, fontSize: 12)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _themeColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressScreen(isDark: _isDark, themeColor: _themeColor))),
                    child: const Text('Add Delivery Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          );
        }

        // IF ADDRESS IS SELECTED
        final addr = globalSavedAddresses[selectedIndex];
        IconData typeIcon = addr.type == 'Home' ? Icons.home_rounded : addr.type == 'Office' ? Icons.work_outline : Icons.location_on_outlined;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: _borderColor)),
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
                      Text('Delivering to ${addr.type}', style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddressScreen(isDark: _isDark, themeColor: _themeColor))),
                    child: Text('CHANGE', style: TextStyle(color: _themeColor, fontSize: 12, fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(addr.completeAddress, style: TextStyle(color: _textSecondary, fontSize: 12, height: 1.4)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: _isDark ? Colors.white10 : Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: _textSecondary, size: 16),
                    const SizedBox(width: 8),
                    Text(addr.fullName, style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Icon(Icons.phone_outlined, color: _textSecondary, size: 16),
                    const SizedBox(width: 8),
                    Text(addr.phone, style: TextStyle(color: _textPrimary, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}