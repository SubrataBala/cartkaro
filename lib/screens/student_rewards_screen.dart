import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StudentRewardsScreen extends StatefulWidget {
  final Color themeColor;

  const StudentRewardsScreen({super.key, required this.themeColor});

  @override
  State<StudentRewardsScreen> createState() => _StudentRewardsScreenState();
}

class _StudentRewardsScreenState extends State<StudentRewardsScreen> {
  // ── State Variables ──
  bool _isOtpSent = false;
  bool _isVerified = false;
  
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? height, double? letterSpacing}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, height: height, letterSpacing: letterSpacing);
  }

  // ── Mock Functions ──
  void _sendOtp() {
    FocusScope.of(context).unfocus();
    if (_emailCtrl.text.isEmpty || !_emailCtrl.text.contains('@')) {
      _showSnack('Please enter a valid college email address.', isError: true);
      return;
    }
    
    // Yahan API call hogi OTP bhejne ke liye
    setState(() => _isOtpSent = true);
    _showSnack('OTP sent to ${_emailCtrl.text}!');
  }

  void _verifyOtp() {
    FocusScope.of(context).unfocus();
    if (_otpCtrl.text.length < 4) {
      _showSnack('Please enter a valid OTP.', isError: true);
      return;
    }

    // Yahan API call hogi OTP verify karne ke liye
    setState(() => _isVerified = true);
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
          title: Text('Student Privileges', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                            child: Text('STUDENT EXCLUSIVE', style: _s(size: 10, weight: FontWeight.w700, color: Colors.white)),
                          ),
                          const SizedBox(height: 12),
                          // 🔥 UPDATED TEXT HERE 🔥
                          Text('Flat 5% OFF on Cart!', style: _s(size: 18, weight: FontWeight.w800, color: Colors.white, height: 1.2)),
                          const SizedBox(height: 6),
                          Text('Verify your college ID and save 5% on your total cart value. Example: Save ₹5 instantly on a ₹100 order!', style: _s(size: 12, color: Colors.white.withOpacity(0.9), height: 1.4)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      height: 70, width: 70,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Center(child: Text('🎓', style: TextStyle(fontSize: 36))),
                    ),
                  ],
                ),
              ),

              // ── DYNAMIC CONTENT (Verified vs Unverified) ──
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _isVerified ? _buildSuccessState() : _buildVerificationForm(),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── FORM: EMAIL & OTP ──
  Widget _buildVerificationForm() {
    return Padding(
      key: const ValueKey('form'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Verify Your Status', style: _s(size: 16, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Please enter your official college email address (e.g. name@college.edu or .ac.in)', style: _s(size: 13, color: const Color(0xFF6B7280), height: 1.4)),
          const SizedBox(height: 24),

          // Email Input
          Text('College Email Address', style: _s(size: 13, weight: FontWeight.w600, color: const Color(0xFF4B5563))),
          const SizedBox(height: 8),
          TextField(
            controller: _emailCtrl,
            enabled: !_isOtpSent, // Disable if OTP is sent
            keyboardType: TextInputType.emailAddress,
            style: _s(size: 14),
            decoration: InputDecoration(
              hintText: 'student@university.ac.in',
              hintStyle: _s(size: 14, color: const Color(0xFF9CA3AF)),
              prefixIcon: Icon(Icons.school_outlined, color: const Color(0xFF9CA3AF), size: 20),
              filled: true,
              fillColor: _isOtpSent ? const Color(0xFFF3F4F6) : const Color(0xFFF9FAFB),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: widget.themeColor, width: 1.5)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),

          // Send OTP Button
          if (!_isOtpSent) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text('Get Verification Code', style: _s(size: 15, weight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],

          // OTP Section
          if (_isOtpSent) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enter 4-Digit OTP', style: _s(size: 13, weight: FontWeight.w600, color: const Color(0xFF4B5563))),
                GestureDetector(
                  onTap: () => setState(() => _isOtpSent = false), // Reset
                  child: Text('Change Email', style: _s(size: 12, weight: FontWeight.w600, color: widget.themeColor)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: _s(size: 24, weight: FontWeight.w700, letterSpacing: 8),
              decoration: InputDecoration(
                counterText: '',
                hintText: '----',
                hintStyle: _s(size: 24, color: const Color(0xFFD1D5DB), letterSpacing: 8),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: widget.themeColor, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text('Verify & Claim Discount', style: _s(size: 15, weight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ]
        ],
      ),
    );
  }

  // ── SUCCESS STATE WIDGET ──
  Widget _buildSuccessState() {
    return Padding(
      key: const ValueKey('success'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.verified_rounded, size: 64, color: Color(0xFF10B981)),
            ),
            const SizedBox(height: 24),
            Text('Verification Successful!', style: _s(size: 18, weight: FontWeight.w800)),
            const SizedBox(height: 8),
            // 🔥 UPDATED TEXT HERE 🔥
            Text(
              'Your college email is verified! A flat 5% discount will now be automatically deducted from your cart total every time you checkout.',
              style: _s(size: 13, color: const Color(0xFF6B7280), height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: widget.themeColor, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Start Ordering', style: _s(size: 14, weight: FontWeight.w600, color: widget.themeColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}