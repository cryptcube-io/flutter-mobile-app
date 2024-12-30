import 'package:flutter/material.dart';
import 'package:my_app2/presentation/components/custom_navbar.dart';

import 'app_detail.dart';

class AppItem {
  final String name;
  final String score;
  final String iconPath;

  AppItem({
    required this.name,
    required this.score,
    required this.iconPath,
  });
}

class AppList extends StatelessWidget {
  AppList({super.key});

  final List<AppItem> apps = [
    AppItem(
      name: 'Whatsapp',
      score: '654/800',
      iconPath: 'assets/whatsapp_icon.png',
    ),
    AppItem(
      name: 'Doordash',
      score: '624/800',
      iconPath: 'assets/doordash_icon.png',
    ),
    AppItem(
      name: 'GrubHub',
      score: '604/800',
      iconPath: 'assets/grubhub_icon.png',
    ),
    AppItem(
      name: 'Whatsapp',
      score: '654/800',
      iconPath: 'assets/whatsapp_icon.png',
    ),
    AppItem(
      name: 'Doordash',
      score: '624/800',
      iconPath: 'assets/doordash_icon.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Apps affecting your Score',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: apps.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final app = apps[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: _buildAppIcon(app.name),
                      title: Text(
                        app.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          text: 'Privacy Score: ',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: app.score.split('/')[0],
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '/${app.score.split('/')[1]}',
                              style: const TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppDetail(appName: app.name),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }

  Widget _buildAppIcon(String appName) {
    Color backgroundColor;
    IconData iconData;
    Color iconColor;

    switch (appName.toLowerCase()) {
      case 'whatsapp':
        backgroundColor = const Color(0xFF25D366);
        iconData = Icons.chat_bubble;
        iconColor = Colors.white;
        break;
      case 'doordash':
        backgroundColor = const Color(0xFFFF3008);
        iconData = Icons.delivery_dining;
        iconColor = Colors.white;
        break;
      case 'grubhub':
        backgroundColor = const Color(0xFFFF8000);
        iconData = Icons.restaurant;
        iconColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.grey;
        iconData = Icons.apps;
        iconColor = Colors.white;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
}