import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrescriptionsScreen extends StatefulWidget {
  final Color themeColor;

  const PrescriptionsScreen({super.key, required this.themeColor});

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  // ── Dummy Prescription Data ──
  final List<Map<String, dynamic>> _prescriptions = [
    {
      'id': '#PR-8892',
      'doctor': 'Dr. Sharma (General Physician)',
      'date': '14 June, 2026',
      'status': 'Verified',
    },
    {
      'id': '#PR-8841',
      'doctor': 'City Hospital (ENT Specialist)',
      'date': '02 May, 2026',
      'status': 'Verified',
    },
    {
      'id': '#PR-8750',
      'doctor': 'Self Uploaded',
      'date': '10 April, 2026',
      'status': 'Pending',
    },
  ];

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? height}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, height: height);
  }

  // ── Upload Mock Function ──
  void _uploadPrescription() {
    // Yahan Camera / File Picker khulega
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening Camera / Gallery...', style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: widget.themeColor,
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
          title: Text('My Prescriptions', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // ── UPLOAD SECTION ──
              Text('Upload New', style: _s(size: 16, weight: FontWeight.w700)),
              const SizedBox(height: 16),
              
              GestureDetector(
                onTap: _uploadPrescription,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    color: widget.themeColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: widget.themeColor.withOpacity(0.3), width: 1.5, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.themeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.document_scanner_rounded, size: 36, color: widget.themeColor),
                      ),
                      const SizedBox(height: 16),
                      Text('Tap to Upload Prescription', style: _s(size: 15, weight: FontWeight.w600, color: widget.themeColor)),
                      const SizedBox(height: 6),
                      Text('PDF, JPG or PNG (Max 5MB)', style: _s(size: 12, color: const Color(0xFF6B7280))),
                      
                      const SizedBox(height: 20),
                      
                      // Guidelines for valid prescription
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text('Doctor details', style: _s(size: 11, color: const Color(0xFF6B7280))),
                          const SizedBox(width: 12),
                          const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text('Patient name', style: _s(size: 11, color: const Color(0xFF6B7280))),
                          const SizedBox(width: 12),
                          const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text('Date', style: _s(size: 11, color: const Color(0xFF6B7280))),
                        ],
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── SAVED PRESCRIPTIONS ──
              Text('Saved Prescriptions', style: _s(size: 16, weight: FontWeight.w700)),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _prescriptions.length,
                itemBuilder: (context, index) {
                  final item = _prescriptions[index];
                  final isVerified = item['status'] == 'Verified';
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Document Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.description_outlined, color: widget.themeColor, size: 24),
                        ),
                        const SizedBox(width: 16),
                        
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item['id'], style: _s(size: 14, weight: FontWeight.w700)),
                                  // Status Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isVerified ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      item['status'],
                                      style: _s(size: 10, weight: FontWeight.w600, color: isVerified ? const Color(0xFF059669) : const Color(0xFFD97706)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(item['doctor'], style: _s(size: 13, weight: FontWeight.w500, color: const Color(0xFF4B5563))),
                              const SizedBox(height: 4),
                              Text('Uploaded on: ${item['date']}', style: _s(size: 11, color: const Color(0xFF9CA3AF))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}