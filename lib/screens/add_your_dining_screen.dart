import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddYourDiningScreen extends StatefulWidget {
  final Color themeColor;

  const AddYourDiningScreen({super.key, required this.themeColor});

  @override
  State<AddYourDiningScreen> createState() => _AddYourDiningScreenState();
}

class _AddYourDiningScreenState extends State<AddYourDiningScreen> {
  // ── State Variables ──
  int _selectedRestaurantIndex = 0; 
  int _selectedGuests = 2;
  int _selectedDateIndex = 0;
  String _selectedTime = '19:30';

  // ── Extracted Unique Restaurants from Your Data ──
  final List<Map<String, String>> _restaurants = [
    {'name': 'Biryani Blues', 'type': 'Biryani & Pulao', 'icon': '🍲', 'rating': '4.7'},
    {'name': 'Domino\'s Pizza', 'type': 'Pizzas & Fast Food', 'icon': '🍕', 'rating': '4.3'},
    {'name': 'Momo Corner', 'type': 'Noodles & Momos', 'icon': '🥟', 'rating': '4.6'},
    {'name': 'Haldiram\'s', 'type': 'North Indian', 'icon': '🍛', 'rating': '4.5'},
    {'name': 'Burger King', 'type': 'American Fast Food', 'icon': '🍔', 'rating': '4.5'},
    {'name': 'Chowman', 'type': 'Asian & Chinese', 'icon': '🍜', 'rating': '4.2'},
    {'name': 'Cafe Coffee Day', 'type': 'Beverages & Desserts', 'icon': '☕', 'rating': '4.6'},
    {'name': 'Kolkata Rolls', 'type': 'Street Food', 'icon': '🌯', 'rating': '4.4'},
    {'name': 'Punjabi Dhaba', 'type': 'North Indian', 'icon': '🥘', 'rating': '4.4'},
    {'name': 'South Indian Hub', 'type': 'South Indian', 'icon': '🥞', 'rating': '4.8'},
    {'name': 'Bansi Vihar', 'type': 'Indian Authentic', 'icon': '🥙', 'rating': '4.8'},
  ];

  final List<String> _lunchSlots = ['12:30', '13:00', '13:30', '14:00', '14:30'];
  final List<String> _dinnerSlots = ['19:00', '19:30', '20:00', '20:30', '21:00', '21:30'];

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? height}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, height: height);
  }

  // ── Confirm Booking Logic ──
  void _confirmBooking() {
    FocusScope.of(context).unfocus();
    
    final selectedRest = _restaurants[_selectedRestaurantIndex]['name'];
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Table Booked at $selectedRest! 🎉', style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: widget.themeColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
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
          title: Text('Book a Table', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── STEP 1: CHOOSE RESTAURANT ──
                    _buildStepHeader('Step 1', 'Choose a Restaurant'),
                    SizedBox(
                      height: 100, // Adjusted height for clean look
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
                              width: 220,
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
                                    height: 50, width: 50,
                                    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                                    child: Center(child: Text(_restaurants[index]['icon']!, style: const TextStyle(fontSize: 24))),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(_restaurants[index]['name']!, style: _s(size: 14, weight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(Icons.star_rounded, size: 14, color: Color(0xFF10B981)),
                                            const SizedBox(width: 2),
                                            Text(_restaurants[index]['rating']!, style: _s(size: 11, weight: FontWeight.w600, color: const Color(0xFF10B981))),
                                            const SizedBox(width: 8),
                                            Expanded(child: Text(_restaurants[index]['type']!, style: _s(size: 11, color: const Color(0xFF6B7280)), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                          ],
                                        ),
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

                    // ── STEP 2: NUMBER OF GUESTS ──
                    _buildStepHeader('Step 2', 'Number of Guests'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(6, (index) {
                          int guestNum = index + 1;
                          bool isSelected = _selectedGuests == guestNum;
                          String label = guestNum == 6 ? '6+' : guestNum.toString();
                          return GestureDetector(
                            onTap: () => setState(() => _selectedGuests = guestNum),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              height: 50, width: 50,
                              decoration: BoxDecoration(
                                color: isSelected ? widget.themeColor : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: isSelected ? widget.themeColor : const Color(0xFFE5E7EB), width: 1.5),
                                boxShadow: isSelected ? [BoxShadow(color: widget.themeColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                              ),
                              child: Center(
                                child: Text(label, style: _s(size: 16, weight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? Colors.white : const Color(0xFF374151))),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(height: 1, color: Color(0xFFE5E7EB))),

                    // ── STEP 3: DATE & TIME ──
                    _buildStepHeader('Step 3', 'Select Date & Time'),
                    
                    // Date Selector
                    SizedBox(
                      height: 85,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: 7, 
                        itemBuilder: (context, index) {
                          DateTime date = DateTime.now().add(Duration(days: index));
                          bool isSelected = _selectedDateIndex == index;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedDateIndex = index),
                            child: Container(
                              width: 65,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: isSelected ? widget.themeColor : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: isSelected ? widget.themeColor : const Color(0xFFE5E7EB), width: 1.5),
                                boxShadow: isSelected ? [BoxShadow(color: widget.themeColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(index == 0 ? 'Today' : index == 1 ? 'Tmrw' : _getWeekday(date.weekday), style: _s(size: 11, weight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? Colors.white70 : const Color(0xFF6B7280))),
                                  const SizedBox(height: 4),
                                  Text(date.day.toString(), style: _s(size: 18, weight: FontWeight.w700, color: isSelected ? Colors.white : const Color(0xFF111827))),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Time Selector (Lunch)
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Lunch', style: _s(size: 14, weight: FontWeight.w600, color: const Color(0xFF4B5563)))),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(spacing: 12, runSpacing: 12, children: _lunchSlots.map((time) => _buildTimeChip(time)).toList()),
                    ),

                    const SizedBox(height: 20),

                    // Time Selector (Dinner)
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Dinner', style: _s(size: 14, weight: FontWeight.w600, color: const Color(0xFF4B5563)))),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(spacing: 12, runSpacing: 12, children: _dinnerSlots.map((time) => _buildTimeChip(time)).toList()),
                    ),

                    const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(height: 1, color: Color(0xFFE5E7EB))),

                    // ── STEP 4: SPECIAL REQUEST (OPTIONAL) ──
                    _buildStepHeader('Step 4', 'Special Request (Optional)'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        maxLines: 2,
                        style: _s(size: 14),
                        decoration: InputDecoration(
                          hintText: 'e.g. Anniversary celebration, Window seat...',
                          hintStyle: _s(size: 13, color: const Color(0xFF9CA3AF)),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          contentPadding: const EdgeInsets.all(16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: widget.themeColor.withOpacity(0.5), width: 1.5)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // ── BOTTOM BOOKING BUTTON ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text('Confirm Booking', style: _s(size: 15, weight: FontWeight.w600, color: Colors.white)),
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

  // ── WIDGET: Time Chip ──
  Widget _buildTimeChip(String time) {
    bool isSelected = _selectedTime == time;
    return GestureDetector(
      onTap: () => setState(() => _selectedTime = time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? widget.themeColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? widget.themeColor : const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: Text(
          time,
          style: _s(size: 13, weight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? widget.themeColor : const Color(0xFF374151)),
        ),
      ),
    );
  }

  // ── HELPER: Get Weekday String ──
  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }
}