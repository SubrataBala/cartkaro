import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  final int unreadCount;

  const NotificationButton({
    super.key,
    required this.unreadCount,
  });

  // 🔥 THE SHEET LOGIC IS NOW HERE INSIDE THE BUTTON FILE
  void _openNotificationMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Activity Update",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "3 new updates require attention",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: const Icon(Icons.close_rounded, size: 20, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildPremiumNotificationCard(
                      tag: "TRACKING",
                      tagColor: const Color(0xFF4CD964),
                      title: "Arriving in 8 Mins",
                      message: "Your Cartkaro Grocery driver Rajesh is near Sector 4 with your order.",
                      time: "Just now",
                      icon: Icons.delivery_dining_rounded,
                      actionLabel: "Track Order Live",
                      onActionTap: () => print("Tracking Clicked"),
                      hasAction: true,
                    ),
                    _buildPremiumNotificationCard(
                      tag: "LIMITED OFFER",
                      tagColor: const Color(0xFFFF9500),
                      title: "50% Off Lunch Craving",
                      message: "Top restaurants are unlocked! Claim your half-price gourmet meal ticket.",
                      time: "45 mins ago",
                      icon: Icons.fastfood_rounded,
                      actionLabel: "Claim Voucher",
                      onActionTap: () => print("Voucher Clicked"),
                      hasAction: true,
                    ),
                    _buildPremiumNotificationCard(
                      tag: "HEALTH REMINDER",
                      tagColor: const Color(0xFF007AFF),
                      title: "Prescription Cycle Due",
                      message: "Keep your healthcare schedule locked. Reorder regular wellness items seamlessly.",
                      time: "Yesterday",
                      icon: Icons.healing_rounded,
                      actionLabel: "Reorder Now",
                      onActionTap: () => print("Reorder Clicked"),
                      hasAction: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔥 THE CARD DESIGN IS ALSO MOVED HERE
  Widget _buildPremiumNotificationCard({
    required String tag,
    required Color tagColor,
    required String title,
    required String message,
    required String time,
    required IconData icon,
    required String actionLabel,
    required VoidCallback onActionTap,
    required bool hasAction,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, color: tagColor, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: tagColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: tagColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (hasAction) ...[
            Container(
              height: 1,
              color: Colors.grey.withOpacity(0.06),
            ),
            InkWell(
              onTap: onActionTap,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      actionLabel,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: tagColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: tagColor,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 🔥 NOW IT JUST CALLS ITS OWN METHOD!
      onTap: () => _openNotificationMenu(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF1A1A1A),
                size: 24,
              ),
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF3B30).withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}