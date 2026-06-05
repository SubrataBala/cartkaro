import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  final Color themeColor;

  const AppSettingsScreen({super.key, required this.themeColor});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // Demo States
  bool pushNotifications = true;
  bool smsAlerts = false;
  bool locationAccess = true;
  bool darkTheme = false;

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
        title: const Text('App Settings', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('NOTIFICATIONS'),
          _buildSettingCard([
            _buildSwitchTile('Push Notifications', 'Order updates, offers & alerts', pushNotifications, (v) => setState(() => pushNotifications = v)),
            _buildDivider(),
            _buildSwitchTile('SMS Alerts', 'Delivery partner tracking via SMS', smsAlerts, (v) => setState(() => smsAlerts = v)),
          ]),
          const SizedBox(height: 24),

          _buildSectionHeader('PREFERENCES'),
          _buildSettingCard([
            _buildSwitchTile('Location Access', 'Required for fast & accurate delivery', locationAccess, (v) => setState(() => locationAccess = v)),
            _buildDivider(),
            _buildNavigationTile('App Language', 'English (US)'),
            _buildDivider(),
            _buildSwitchTile('Dark Mode', 'Currently disabled for standard view', darkTheme, (v) => setState(() => darkTheme = v)),
          ]),
          const SizedBox(height: 24),

          _buildSectionHeader('ACCOUNT DATA'),
          _buildSettingCard([
            _buildNavigationTile('Clear Cache', '14.2 MB'),
            _buildDivider(),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              title: const Text('Delete Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.red)),
              trailing: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
              onTap: () {
                // Warning dialog logic here
              },
            ),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF8A8A9A), letterSpacing: 0.8),
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF8A8A9A))),
      value: value,
      activeColor: Colors.white,
      activeTrackColor: widget.themeColor,
      inactiveTrackColor: Colors.grey.shade200,
      onChanged: onChanged,
    );
  }

  Widget _buildNavigationTile(String title, String trailingText) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailingText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8A8A9A))),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF8A8A9A)),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF4F4F6));
}