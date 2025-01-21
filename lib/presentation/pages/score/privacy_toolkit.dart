import 'package:flutter/material.dart';

import '../../components/custom_navbar.dart';

class PrivacyToolkit extends StatelessWidget {
  const PrivacyToolkit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: const [
                          Text(
                            'Privacy Toolkit',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.build_outlined,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Protect your privacy with Simple Steps',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            _buildToolkitItem(
                              icon: Icons.mic_off_outlined,
                              title: 'Revoke microphone access\nfor XYZ app',
                            ),
                            _buildToolkitItem(
                              icon: Icons.location_off_outlined,
                              title: 'Turn off location tracking for\nABC service',
                            ),
                            _buildToolkitItem(
                              icon: Icons.lock_outline,
                              title: 'Enable two-factor\nauthentication for your account',
                            ),
                            _buildToolkitItem(
                              icon: Icons.credit_card_outlined,
                              title: 'Avoid saving card details; link\nPayPal or similar apps for\nbetter security',
                            ),
                            _buildToolkitItem(
                              icon: Icons.person_outline,
                              title: 'Avoid signing in using social\nmedia accounts to reduce\ndata linking',
                              showBorder: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
             CustomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolkitItem({
    required IconData icon,
    required String title,
    bool showBorder = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1,
                ),
              )
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 24,
          color: Colors.black87,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        onTap: () {
         
        },
      ),
    );
  }
}