import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  final Color themeColor;

  const TermsConditionsScreen({super.key, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A2E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Terms & Conditions', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      // 🔥 FIX: ScrollConfiguration aur ClampingScrollPhysics add kar diya hai
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(), 
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('Last Updated: 15 May 2026', style: TextStyle(color: themeColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 24),
              
              _buildHeading('1. Introduction'),
              _buildParagraph('Welcome to CartKaro. By accessing our app, you agree to be bound by these terms and conditions, all applicable laws, and regulations. Please read them carefully before using our delivery services for groceries, food, and medical supplies.'),
              
              _buildHeading('2. User Accounts'),
              _buildParagraph('To use CartKaro, you must register for an account using a valid phone number. You are responsible for maintaining the confidentiality of your OTP and account details. CartKaro reserves the right to terminate accounts that violate our policies.'),
              
              _buildHeading('3. Payments & Wallet'),
              _buildParagraph('All payments must be made at the time of placing an order. The CartKaro Wallet allows you to store funds for quicker checkouts. Promotional coins and wallet cash are non-transferable to bank accounts and hold no real-world monetary value outside the app.'),
              
              _buildHeading('4. Delivery & Liability'),
              _buildParagraph('While we strive for lightning-fast deliveries within 10-30 minutes, actual delivery times may vary due to weather, traffic, or restaurant/store delays. CartKaro acts solely as a technology platform connecting users with local vendors and delivery partners.'),
              
              _buildHeading('5. Medical Supplies Disclaimer'),
              _buildParagraph('Medicines marked as "Prescription Required" will only be dispensed after a valid prescription from a registered medical practitioner is uploaded and verified. CartKaro does not provide medical advice.'),
              
              const SizedBox(height: 40),
              Center(
                child: Icon(Icons.local_mall_rounded, color: Colors.grey.shade300, size: 40),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('CartKaro © 2026', style: TextStyle(color: Color(0xFF8A8A9A), fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, color: Color(0xFF757575), height: 1.6, fontWeight: FontWeight.w400),
    );
  }
}