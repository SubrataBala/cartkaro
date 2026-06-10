import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletScreen extends StatefulWidget {
  final Color themeColor;

  const WalletScreen({super.key, required this.themeColor});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController _amountController = TextEditingController();
  final double _balance = 248.50;
  final List<int> _quickAmounts = [100, 200, 500, 1000];
  int _selectedAmount = 0;

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? letterSpacing}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, letterSpacing: letterSpacing);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF111827), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('CartKaro Wallet', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. PREMIUM WALLET CARD ──
              Container(
                margin: const EdgeInsets.all(20),
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.themeColor, widget.themeColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(color: widget.themeColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text('Available Balance', style: _s(size: 14, weight: FontWeight.w500, color: Colors.white.withOpacity(0.9))),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: Text('Active', style: _s(size: 11, weight: FontWeight.w600, color: Colors.white)),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('₹ ${_balance.toStringAsFixed(2)}', style: _s(size: 42, weight: FontWeight.w800, color: Colors.white, letterSpacing: -1)),
                  ],
                ),
              ),

              // ── 2. ADD MONEY SECTION ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Top Up Wallet', style: _s(size: 16, weight: FontWeight.w700)),
              ),
              const SizedBox(height: 16),

              // Custom Input Field
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: _s(size: 24, weight: FontWeight.w700),
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    hintStyle: _s(size: 18, color: const Color(0xFFD1D5DB)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('₹', style: _s(size: 24, weight: FontWeight.w700, color: widget.themeColor)),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  onChanged: (value) {
                    setState(() => _selectedAmount = int.tryParse(value) ?? 0);
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Quick Amount Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _quickAmounts.map((amount) {
                    bool isSelected = _selectedAmount == amount;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('+ ₹$amount', style: _s(size: 14, weight: isSelected ? FontWeight.w700 : FontWeight.w600, color: isSelected ? Colors.white : const Color(0xFF4B5563))),
                        selected: isSelected,
                        selectedColor: widget.themeColor,
                        backgroundColor: Colors.white,
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: isSelected ? widget.themeColor : const Color(0xFFE5E7EB), width: 1.5),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedAmount = amount;
                            _amountController.text = amount.toString();
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Add Money Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus(); // Hide Keyboard
                      if (_amountController.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Proceeding to add ₹${_amountController.text}...', style: const TextStyle(fontFamily: 'Poppins')),
                          backgroundColor: widget.themeColor,
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.themeColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: Text('Proceed to Pay', style: _s(size: 15, weight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── 3. TRANSACTION HISTORY ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Transactions', style: _s(size: 16, weight: FontWeight.w700)),
                    Text('View All', style: _s(size: 12, weight: FontWeight.w600, color: widget.themeColor)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    _transactionTile(title: "Added to Wallet", date: "12 Jun, 10:30 AM", money: "+ ₹200", isCredit: true),
                    const Divider(height: 1, indent: 64, endIndent: 20, color: Color(0xFFF3F4F6)),
                    _transactionTile(title: "Order #8892 Payment", date: "10 Jun, 08:15 PM", money: "- ₹120", isCredit: false),
                    const Divider(height: 1, indent: 64, endIndent: 20, color: Color(0xFFF3F4F6)),
                    _transactionTile(title: "Cashback Received", date: "05 Jun, 01:45 PM", money: "+ ₹50", isCredit: true),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Custom Transaction Tile ──
  Widget _transactionTile({required String title, required String date, required String money, required bool isCredit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            height: 48, width: 48,
            decoration: BoxDecoration(
              color: isCredit ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _s(size: 14, weight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(date, style: _s(size: 12, color: const Color(0xFF6B7280))),
              ],
            ),
          ),
          Text(
            money,
            style: _s(size: 15, weight: FontWeight.w700, color: isCredit ? const Color(0xFF10B981) : const Color(0xFF111827)),
          ),
        ],
      ),
    );
  }
}