import 'package:flutter/material.dart';
import 'package:my_app2/presentation/components/custom_navbar.dart';

class PrivacyShield extends StatelessWidget {
  const PrivacyShield({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with avatar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Privacy Shield',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            radius: 25,
                            child: const Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Shield Progress
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.green.withOpacity(0.7),
                                Colors.blue.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '75%',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Status Message
                      const Text(
                        'Hi John, 75% of apps are supported, but the following aren\'t yet. We\'re working hard to include them soon',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Pending Apps Section
                      const Text(
                        'Apps Pending Support (6)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Grid of Apps
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: [
                          _buildAppIcon('Whatsapp', Icons.chat_bubble, Colors.green),
                          _buildAppIcon('Doordash', Icons.delivery_dining, Colors.red),
                          _buildAppIcon('GrubHub', Icons.restaurant, Colors.orange),
                          _buildAppIcon('Whatsapp', Icons.chat_bubble, Colors.green),
                          _buildAppIcon('Doordash', Icons.delivery_dining, Colors.red),
                          _buildAppIcon('GrubHub', Icons.restaurant, Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
             CustomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIcon(String name, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: color,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}