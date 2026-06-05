import 'package:flutter/material.dart';

class CustomerSupportScreen extends StatelessWidget {
  final Color themeColor;

  const CustomerSupportScreen({super.key, required this.themeColor});

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
        title: const Text(
          'Customer Support',
          style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── TOP ILLUSTRATION CARD ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: themeColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Icon(Icons.support_agent_rounded, size: 48, color: themeColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'How can we help you?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We usually respond within a few minutes.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF8A8A9A)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ── POPULAR QUERIES (FAQ) ──
            const Text(
              'POPULAR QUERIES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF8A8A9A), letterSpacing: 0.8),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))
                ],
              ),
              child: Column(
                children: [
                  _buildFaqTile('Where is my order?'),
                  _buildFaqTile('I want to refund an item'),
                  _buildFaqTile('Issue with the delivery partner'),
                  _buildFaqTile('Payment got deducted but order failed', showDivider: false),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ── CONTACT OPTIONS ──
            const Text(
              'STILL NEED HELP?',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF8A8A9A), letterSpacing: 0.8),
            ),
            const SizedBox(height: 12),
            
            // Chat Button (Primary)
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Chat with us', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Call & Email Buttons
            Row(
              children: [
                Expanded(
                  child: _buildSecondaryContactButton(Icons.phone_outlined, 'Call Us'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSecondaryContactButton(Icons.email_outlined, 'Email Us'),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(String title, {bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF8A8A9A)),
          onTap: () {},
        ),
        if (showDivider)
          const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF4F4F6)),
      ],
    );
  }

  Widget _buildSecondaryContactButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: themeColor, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: themeColor, fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}