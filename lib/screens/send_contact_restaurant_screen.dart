import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendContactRestaurantScreen extends StatefulWidget {
  final Color themeColor;

  const SendContactRestaurantScreen({super.key, required this.themeColor});

  @override
  State<SendContactRestaurantScreen> createState() => _SendContactRestaurantScreenState();
}

class _SendContactRestaurantScreenState extends State<SendContactRestaurantScreen> {
  // ── State Variables ──
  int _selectedRestaurantIndex = 0;
  bool _consentGiven = false;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  // ── Extracted Unique Restaurants from Your Data ──
  final List<Map<String, String>> _restaurants = [
    {'name': 'Biryani Blues', 'type': 'Biryani & Pulao', 'icon': '🍲'},
    {'name': 'Domino\'s Pizza', 'type': 'Pizzas & Fast Food', 'icon': '🍕'},
    {'name': 'Momo Corner', 'type': 'Noodles & Momos', 'icon': '🥟'},
    {'name': 'Haldiram\'s', 'type': 'North Indian', 'icon': '🍛'},
    {'name': 'Burger King', 'type': 'American Fast Food', 'icon': '🍔'},
    {'name': 'Chowman', 'type': 'Asian & Chinese', 'icon': '🍜'},
    {'name': 'Cafe Coffee Day', 'type': 'Beverages & Desserts', 'icon': '☕'},
    {'name': 'Kolkata Rolls', 'type': 'Street Food', 'icon': '🌯'},
    {'name': 'Punjabi Dhaba', 'type': 'North Indian', 'icon': '🥘'},
    {'name': 'South Indian Hub', 'type': 'South Indian', 'icon': '🥞'},
    {'name': 'Bansi Vihar', 'type': 'Indian Authentic', 'icon': '🥙'},
  ];

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? height}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, height: height);
  }

  // ── Submit Logic ──
  void _submitContact() {
    FocusScope.of(context).unfocus(); // Hide keyboard

    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      _showSnack('Please enter your name and phone number.', isError: true);
      return;
    }
    
    if (!_consentGiven) {
      _showSnack('Please check the consent box to proceed.', isError: true);
      return;
    }

    final selectedRest = _restaurants[_selectedRestaurantIndex]['name'];
    
    _showSnack('Contact shared securely with $selectedRest! ✅');

    // Page automatically close ho jayega 2 seconds baad
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: isError ? const Color(0xFFEF4444) : widget.themeColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
          title: Text('Connect with Restaurant', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(overscroll: false), // No jelly effect
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── HERO BANNER ──
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [widget.themeColor, widget.themeColor.withOpacity(0.8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: widget.themeColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Become a VIP Guest', style: _s(size: 16, weight: FontWeight.w800, color: Colors.white)),
                                  const SizedBox(height: 6),
                                  Text('Share your details directly with restaurants for exclusive offers, secret menus, and event invites.', style: _s(size: 12, color: Colors.white.withOpacity(0.9), height: 1.4)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                              child: const Text('💌', style: TextStyle(fontSize: 36)),
                            ),
                          ],
                        ),
                      ),

                      // ── STEP 1: CHOOSE RESTAURANT ──
                      _buildStepHeader('Step 1', 'Select Restaurant'),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _restaurants.length,
                          itemBuilder: (context, index) {
                            bool isSelected = _selectedRestaurantIndex == index;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedRestaurantIndex = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 200,
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected ? widget.themeColor.withOpacity(0.05) : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isSelected ? widget.themeColor : const Color(0xFFE5E7EB), width: isSelected ? 2 : 1.5),
                                  boxShadow: isSelected ? [BoxShadow(color: widget.themeColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))] : [],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45, width: 45,
                                      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                                      child: Center(child: Text(_restaurants[index]['icon']!, style: const TextStyle(fontSize: 22))),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(_restaurants[index]['name']!, style: _s(size: 14, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 4),
                                          Text(_restaurants[index]['type']!, style: _s(size: 11, color: const Color(0xFF6B7280)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(height: 1, color: Color(0xFFE5E7EB))),

                      // ── STEP 2: YOUR DETAILS ──
                      _buildStepHeader('Step 2', 'Your Details'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _nameCtrl,
                              label: 'Full Name',
                              hint: 'Enter your name',
                              icon: Icons.person_outline_rounded,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _phoneCtrl,
                              label: 'Mobile Number',
                              hint: '+91 98765 43210',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),

                      const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(height: 1, color: Color(0xFFE5E7EB))),

                      // ── STEP 3: CONSENT ──
                      _buildStepHeader('Step 3', 'Privacy & Consent'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _consentGiven,
                              activeColor: widget.themeColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              onChanged: (val) {
                                setState(() => _consentGiven = val ?? false);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  'I authorize CartKaro to securely share my name and phone number with the selected restaurant for direct communication and promotional offers.',
                                  style: _s(size: 12, color: const Color(0xFF4B5563), height: 1.4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // ── BOTTOM BUTTON ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text('Share Contact Details', style: _s(size: 15, weight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── WIDGET: Step Header ──
  Widget _buildStepHeader(String stepText, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: widget.themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
            child: Text(stepText, style: _s(size: 10, weight: FontWeight.w700, color: widget.themeColor)),
          ),
          const SizedBox(width: 12),
          Text(title, style: _s(size: 16, weight: FontWeight.w700)),
        ],
      ),
    );
  }

  // ── CUSTOM TEXT FIELD BUILDER ──
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _s(size: 13, weight: FontWeight.w600, color: const Color(0xFF4B5563))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: _s(size: 14, weight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: _s(size: 14, color: const Color(0xFF9CA3AF)),
            prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: widget.themeColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}