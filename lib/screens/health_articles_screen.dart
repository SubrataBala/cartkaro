import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HealthArticlesScreen extends StatefulWidget {
  final Color themeColor;

  const HealthArticlesScreen({super.key, required this.themeColor});

  @override
  State<HealthArticlesScreen> createState() => _HealthArticlesScreenState();
}

class _HealthArticlesScreenState extends State<HealthArticlesScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = ['All', 'Nutrition', 'Fitness', 'Mental Health', 'Sleep'];

  // ── Dummy Articles Data ──
  final List<Map<String, dynamic>> _articles = [
    {
      'title': 'How to maintain a healthy sleep cycle naturally',
      'desc': 'Discover 5 proven ways to fix your sleep schedule without relying on medication.',
      'icon': '😴',
      'time': '4 min read',
      'date': '12 June, 2026',
    },
    {
      'title': 'Understanding your BMI and what it actually means',
      'desc': 'Body Mass Index is a helpful indicator, but here is what you need to know about muscle mass.',
      'icon': '⚖️',
      'time': '6 min read',
      'date': '10 June, 2026',
    },
    {
      'title': 'Daily hydration: How much water is enough?',
      'desc': '8 glasses a day is a myth. Learn how to calculate your personalized daily water intake.',
      'icon': '💧',
      'time': '3 min read',
      'date': '05 June, 2026',
    },
    {
      'title': 'The impact of daily stretching on your joints',
      'desc': 'Just 10 minutes of morning stretching can improve your blood flow and joint health.',
      'icon': '🧘‍♂️',
      'time': '5 min read',
      'date': '01 June, 2026',
    },
  ];

  // ── Helper Text Style ──
  TextStyle _s({double size = 14, FontWeight weight = FontWeight.w400, Color color = const Color(0xFF111827), double? height}) {
    return TextStyle(fontFamily: 'Poppins', fontSize: size, fontWeight: weight, color: color, height: height);
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
          title: Text('Health Articles', style: _s(size: 18, weight: FontWeight.w700)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_outline_rounded, color: Color(0xFF111827)),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── CATEGORY CHIPS ──
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategory == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? widget.themeColor : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? widget.themeColor : const Color(0xFFE5E7EB)),
                          boxShadow: isSelected ? [BoxShadow(color: widget.themeColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _categories[index],
                          style: _s(size: 13, weight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? Colors.white : const Color(0xFF6B7280)),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── FEATURED ARTICLE ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Featured Today', style: _s(size: 16, weight: FontWeight.w700)),
              ),
              const SizedBox(height: 12),
              
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF3F4F6), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Image Area (Gradient + Emoji)
                    Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [widget.themeColor.withOpacity(0.8), widget.themeColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      ),
                      child: const Center(
                        child: Text('🥑', style: TextStyle(fontSize: 64)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: widget.themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                                child: Text('NUTRITION', style: _s(size: 10, weight: FontWeight.w700, color: widget.themeColor)),
                              ),
                              const Spacer(),
                              const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF9CA3AF)),
                              const SizedBox(width: 4),
                              Text('5 min read', style: _s(size: 11, color: const Color(0xFF6B7280))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('10 Superfoods to Boost Your Immunity Naturally', style: _s(size: 16, weight: FontWeight.w700, height: 1.3)),
                          const SizedBox(height: 8),
                          Text('Adding these power-packed foods to your daily diet can help your body fight off infections...', style: _s(size: 13, color: const Color(0xFF6B7280), height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── LATEST ARTICLES LIST ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Latest Articles', style: _s(size: 16, weight: FontWeight.w700)),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
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
                        // Article Icon/Thumbnail
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(child: Text(article['icon'], style: const TextStyle(fontSize: 32))),
                        ),
                        const SizedBox(width: 16),
                        // Article Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(article['title'], style: _s(size: 14, weight: FontWeight.w700, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Text(article['desc'], style: _s(size: 12, color: const Color(0xFF6B7280), height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(article['date'], style: _s(size: 11, color: const Color(0xFF9CA3AF))),
                                  const Spacer(),
                                  const Icon(Icons.circle, size: 4, color: Color(0xFFD1D5DB)),
                                  const SizedBox(width: 6),
                                  Text(article['time'], style: _s(size: 11, weight: FontWeight.w600, color: widget.themeColor)),
                                ],
                              ),
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