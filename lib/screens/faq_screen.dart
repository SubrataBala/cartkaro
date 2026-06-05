import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  final Color themeColor;

  FaqScreen({super.key, required this.themeColor});

  final List<Map<String, String>> faqs = [
    {
      'q': 'How do I track my order?',
      'a': 'You can track your order in real-time by going to the "My Orders" section from your Profile or Quick Actions. Tap on the active order to see the live map and delivery partner details.'
    },
    {
      'q': 'What is your refund policy?',
      'a': 'Refunds are initiated immediately for cancelled orders. Depending on your bank, it may take 3-5 business days for the amount to reflect in your original payment method. Wallet refunds are instant.'
    },
    {
      'q': 'Can I change my delivery address after placing an order?',
      'a': 'Currently, address modifications are not allowed once an order is placed to ensure fast delivery. You can cancel the order within 60 seconds and place a new one.'
    },
    {
      'q': 'Why is my CartKaro wallet disabled?',
      'a': 'Your wallet might be restricted due to unusual activity or pending KYC verification. Please reach out to our Customer Support via chat to resolve this issue.'
    },
    {
      'q': 'Are there any hidden delivery charges?',
      'a': 'No, all charges including delivery fees, taxes, and handling charges are transparently displayed on the checkout page before you make a payment.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A2E), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('FAQ', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E), letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find answers to common queries regarding orders, payments, and our services.',
            style: TextStyle(fontSize: 13, color: Color(0xFF8A8A9A), height: 1.4),
          ),
          const SizedBox(height: 24),
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: faqs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ExpansionTile(
                    iconColor: themeColor,
                    collapsedIconColor: const Color(0xFF8A8A9A),
                    childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    title: Text(
                      faqs[index]['q']!,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
                    ),
                    children: [
                      Text(
                        faqs[index]['a']!,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF757575), height: 1.5),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}