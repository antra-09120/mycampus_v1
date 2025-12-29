import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'map_screen.dart';
import 'calendar_screen.dart';
import 'planner_screen.dart';

class HomeScreen extends StatefulWidget {
  final String studentName;
  final String college;
  final String uid;
  final Function(ThemeMode) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.studentName,
    required this.college,
    required this.uid,
    required this.onThemeChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _launchURL(String url) async {
    try {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }

      final Uri validUri = Uri.parse(url);
      print('🔗 Opening: $url');

      if (await canLaunchUrl(validUri)) {
        await launchUrl(validUri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Cannot launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyCampus'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'theme',
                child: Row(children: [Icon(Icons.palette_rounded), SizedBox(width: 12), Text('Theme')]),
              ),
              const PopupMenuItem(
                value: 'about',
                child: Row(children: [Icon(Icons.info_rounded), SizedBox(width: 12), Text('About')]),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(children: [Icon(Icons.logout_rounded), SizedBox(width: 12), Text('Logout')]),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF1F65B0), Color(0xFF2B7FC7)]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.person_rounded, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back!',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.studentName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.college,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'UID: ${widget.uid}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Campus Tools',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildFeatureCard(
                    context,
                    icon: Icons.map_rounded,
                    title: 'Campus Map',
                    description: 'Navigate around campus',
                    color: const Color(0xFF1F65B0),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen())),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    icon: Icons.calendar_today_rounded,
                    title: 'Calendar',
                    description: 'Mark & track events',
                    color: const Color(0xFF6B21A8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarScreen())),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    icon: Icons.checklist_rounded,
                    title: 'Planner',
                    description: 'Manage your to-do list',
                    color: const Color(0xFF059669),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PlannerScreen())),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    icon: Icons.support_agent_rounded,
                    title: 'Help Desk',
                    description: 'Get support & contact us',
                    color: const Color(0xFFF59E0B),
                    onTap: () => _launchHelpDesk(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: color, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  void _launchHelpDesk() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Help Desk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_rounded, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 12),
                    Expanded(child: Text('Get in touch with our support team', style: Theme.of(context).textTheme.bodySmall)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _launchURL('https://www.culko.in/contact/');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.language_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Visit Help Desk Website', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
        );
      },
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'theme':
        _showThemeDialog(context);
        break;
      case 'about':
        _showAboutDialog(context);
        break;
      case 'logout':
        Navigator.pop(context);
        break;
    }
  }

  void _showThemeDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Choose Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(leading: const Icon(Icons.light_mode_rounded), title: const Text('Light'), onTap: () {
                widget.onThemeChanged(ThemeMode.light);
                Navigator.pop(context);
              }),
              ListTile(leading: const Icon(Icons.dark_mode_rounded), title: const Text('Dark'), onTap: () {
                widget.onThemeChanged(ThemeMode.dark);
                Navigator.pop(context);
              }),
              ListTile(leading: const Icon(Icons.brightness_auto_rounded), title: const Text('System Default'), onTap: () {
                widget.onThemeChanged(ThemeMode.system);
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('About MyCampus'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1F65B0), Color(0xFF2B7FC7)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Icon(Icons.school_rounded, size: 48, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                const Text('MyCampus v1.0.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text('Your complete campus companion. Maps, calendar, planner & support.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _launchURL('https://www.cuchd.in/');
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.language_rounded, color: Color(0xFF1F65B0)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Visit CU Website', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF1F65B0),
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                      const Icon(Icons.open_in_new_rounded, size: 16, color: Color(0xFF1F65B0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
        );
      },
    );
  }
}
