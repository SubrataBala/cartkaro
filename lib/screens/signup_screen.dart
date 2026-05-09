import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ── MEMORY IMPORT ──
import 'home_screen.dart'; 
import 'login_screen.dart'; // To access the global isUserLoggedIn

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _otpSent = false;
  bool _agreedToTerms = false;
  bool _canResend = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  static const kGreen = Color(0xFF0C831F);
  static const kGreenLight = Color(0xFFE8F5E9);
  static const kSurface = Color(0xFFF6F6F6);
  static const kTextDark = Color(0xFF1A1A1A);
  static const kTextMuted = Color(0xFF757575);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    for (final c in _otpControllers) { c.dispose(); }
    for (final f in _otpFocusNodes) { f.dispose(); }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) { _showSnack('Please agree to the Terms & Conditions to continue.', isError: true); return; }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() { _isLoading = false; _otpSent = true; });
    _startResendTimer();
    Future.delayed(const Duration(milliseconds: 200), () => _otpFocusNodes[0].requestFocus());
    _showSnack('OTP sent to +91 ${_mobileController.text.trim()}');
  }

  void _verifyAndCreate() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) { _showSnack('Please enter the complete 6-digit OTP', isError: true); return; }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (mounted) {
      // ── SET GLOBAL LOGIN TRUE & SAVE TO PHONE MEMORY ──
      isUserLoggedIn = true; 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      _showSnack('Account created! Welcome to Cartkaro 🎉');
      
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    }
  }

  void _startResendTimer() {
    setState(() { _canResend = false; _resendSeconds = 30; });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds <= 1) { t.cancel(); setState(() => _canResend = true); } 
      else { setState(() => _resendSeconds--); }
    });
  }

  void _resendOtp() async {
    if (!_canResend) return;
    for (final c in _otpControllers) { c.clear(); }
    _otpFocusNodes[0].requestFocus();
    _startResendTimer();
    await Future.delayed(const Duration(milliseconds: 500));
    _showSnack('OTP resent to +91 ${_mobileController.text.trim()}');
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: isError ? Colors.redAccent : kGreen, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
  }

  void _changeNumber() {
    _resendTimer?.cancel();
    for (final c in _otpControllers) { c.clear(); }
    setState(() { _otpSent = false; _canResend = false; _resendSeconds = 30; });
  }

  void _skipToHome() {
    isUserLoggedIn = false; // Guest
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  
                  // ── TOP ROW: BACK & SKIP BUTTONS ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _otpSent ? _changeNumber : () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                        child: Container(width: 44, height: 44, decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: kTextDark)),
                      ),
                      if (!_otpSent)
                        TextButton(
                          onPressed: _skipToHome,
                          style: TextButton.styleFrom(foregroundColor: kTextMuted),
                          child: const Text('Skip', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600)),
                        )
                    ],
                  ),

                  const SizedBox(height: 36),
                  _buildHeader(),
                  const SizedBox(height: 28),

                  if (!_otpSent) ...[ _buildPerksStrip(), const SizedBox(height: 28), ],

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(anim), child: child)),
                    child: _otpSent ? _buildOtpStep(key: const ValueKey('otp')) : _buildDetailsStep(key: const ValueKey('details')),
                  ),

                  const SizedBox(height: 28),
                  _buildLoginLink(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 18)), const SizedBox(width: 10), const Text('Cartkaro', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700, color: kGreen))]), const SizedBox(height: 24), Text(_otpSent ? 'Verify Number 🔐' : 'Create Account ✨', style: const TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w700, color: kTextDark, height: 1.2)), const SizedBox(height: 8), Text(_otpSent ? 'Enter the 6-digit OTP sent to\n+91 ${_mobileController.text.trim()}' : 'Join thousands getting groceries in 10 mins', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w400, color: kTextMuted))]);
  }

  Widget _buildPerksStrip() {
    return Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(14)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [_PerkChip(icon: Icons.bolt_rounded, label: '10 min\ndelivery'), _PerkDivider(), _PerkChip(icon: Icons.discount_outlined, label: 'Exclusive\noffers'), _PerkDivider(), _PerkChip(icon: Icons.track_changes_rounded, label: 'Live\ntracking')]));
  }

  Widget _buildDetailsStep({Key? key}) {
    return Form(
      key: _formKey,
      child: Column(
        key: key,
        children: [
          TextFormField(controller: _nameController, textCapitalization: TextCapitalization.words, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, color: kTextDark), decoration: _inputDecoration(hint: 'Full Name', icon: Icons.person_outline_rounded), validator: (v) { if (v == null || v.trim().isEmpty) return 'Please enter your full name'; if (v.trim().length < 3) return 'Name must be at least 3 characters'; return null; }),
          const SizedBox(height: 16),
          Container(decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(15)), child: Row(children: [Container(margin: const EdgeInsets.all(6), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(10)), child: const Text('🇮🇳  +91', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: kGreen))), Expanded(child: TextFormField(controller: _mobileController, keyboardType: TextInputType.phone, maxLength: 10, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: kTextDark, letterSpacing: 1.2), decoration: const InputDecoration(hintText: 'Mobile Number', hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFFBDBDBD), letterSpacing: 0), border: InputBorder.none, counterText: '', contentPadding: EdgeInsets.symmetric(vertical: 18), errorStyle: TextStyle(fontFamily: 'Poppins', fontSize: 11)), inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) { if (v == null || v.isEmpty) return 'Please enter your mobile number'; if (v.length != 10) return 'Enter a valid 10-digit number'; return null; }))])),
          const SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [SizedBox(width: 24, height: 24, child: Checkbox(value: _agreedToTerms, onChanged: (v) => setState(() => _agreedToTerms = v ?? false), activeColor: kGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), side: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5))), const SizedBox(width: 10), Expanded(child: RichText(text: const TextSpan(style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: kTextMuted), children: [TextSpan(text: 'I agree to the '), TextSpan(text: 'Terms & Conditions', style: TextStyle(color: kGreen, fontWeight: FontWeight.w600)), TextSpan(text: ' and '), TextSpan(text: 'Privacy Policy', style: TextStyle(color: kGreen, fontWeight: FontWeight.w600))])))]),
          const SizedBox(height: 28),
          _buildPrimaryButton(label: 'Send OTP', icon: Icons.send_rounded, onTap: _requestOtp),
        ],
      ),
    );
  }

  Widget _buildOtpStep({Key? key}) {
    return Column(key: key, crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(6, (i) => _buildOtpBox(i))), const SizedBox(height: 24), Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Didn't receive OTP? ", style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: kTextMuted)), GestureDetector(onTap: _canResend ? _resendOtp : null, child: _canResend ? const Text('Resend OTP', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: kGreen)) : Text('Resend in ${_resendSeconds}s', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: kTextMuted)))]), const SizedBox(height: 8), Center(child: GestureDetector(onTap: _changeNumber, child: const Text('Change Number', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: kGreen, decoration: TextDecoration.underline)))), const SizedBox(height: 28), _buildPrimaryButton(label: 'Verify & Create Account', icon: Icons.verified_user_rounded, onTap: _verifyAndCreate)]);
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(width: 48, height: 58, child: TextField(controller: _otpControllers[index], focusNode: _otpFocusNodes[index], keyboardType: TextInputType.number, textAlign: TextAlign.center, maxLength: 1, style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: kTextDark), inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: InputDecoration(counterText: '', filled: true, fillColor: kSurface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(13), borderSide: const BorderSide(color: kGreen, width: 2))), onChanged: (val) { if (val.isNotEmpty) { if (index < 5) { _otpFocusNodes[index + 1].requestFocus(); } else { _otpFocusNodes[index].unfocus(); _verifyAndCreate(); } } else { if (index > 0) _otpFocusNodes[index - 1].requestFocus(); } }));
  }

  Widget _buildPrimaryButton({required String label, required IconData icon, required VoidCallback onTap}) {
    return SizedBox(width: double.infinity, height: 56, child: ElevatedButton.icon(onPressed: _isLoading ? null : onTap, icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) : Icon(icon, size: 20), label: _isLoading ? const SizedBox.shrink() : Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3)), style: ElevatedButton.styleFrom(backgroundColor: kGreen, foregroundColor: Colors.white, disabledBackgroundColor: const Color(0xFF4CAF50).withOpacity(0.6), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))));
  }

  Widget _buildLoginLink() {
    return Center(child: RichText(text: TextSpan(style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: kTextMuted), children: [const TextSpan(text: 'Already have an account? '), WidgetSpan(child: GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Log In', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: kGreen))))])));
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon, Widget? prefix, Widget? suffix}) {
    return InputDecoration(hintText: hint, hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFFBDBDBD)), filled: true, fillColor: kSurface, prefixIcon: prefix ?? Icon(icon, color: kTextMuted, size: 20), suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix) : null, suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: kGreen, width: 1.8)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)), focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.redAccent, width: 1.8)), errorStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11));
  }
}

// Helper Widgets
class _PerkChip extends StatelessWidget {
  final IconData icon; final String label;
  const _PerkChip({required this.icon, required this.label});
  @override Widget build(BuildContext context) { return Column(children: [Icon(icon, color: const Color(0xFF0C831F), size: 22), const SizedBox(height: 4), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF0C831F), height: 1.3))]); }
}
class _PerkDivider extends StatelessWidget {
  const _PerkDivider();
  @override Widget build(BuildContext context) { return Container(height: 36, width: 1, color: const Color(0xFF0C831F).withOpacity(0.2)); }
}