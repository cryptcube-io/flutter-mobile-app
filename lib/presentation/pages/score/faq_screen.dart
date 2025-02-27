import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/custom_navbar.dart';
import '../../components/shared/header.dart';
import '../navbar/chat_page.dart';
import '../../../config/theme/app_colors.dart';

class FAQScreen extends StatelessWidget {
  final String appName;
  final Uint8List? iconBytes;
  const FAQScreen({
    super.key,
    required this.appName,
    this.iconBytes,
  });

  Widget _buildButton(String text, IconData icon,
      {required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFFEEEDFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: const Color(0xFF6044de)),
              const SizedBox(width: 8),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF6044de),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String title, String content) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("FAQScreen - IconBytes length: ${iconBytes?.length}");

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              CustomHeader(
                title: 'FAQs',
                onBackPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  color: AppColors.contentAreaBackground,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'What can I help with ?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                _buildFAQItem('How is GPS data used?',
                                    'Understand how the app handles and protects your location information.'),
                                _buildFAQItem(
                                    'Does the app have access to my Email content?',
                                    'Learn about email permissions and how the app safeguards your email data.'),
                                _buildFAQItem(
                                    'What are the major app interactions and what do they reveal about the Users?',
                                    'Discover what information is collected when you use different app features.'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildButton(
                            'Still have Doubts? Chat with Us',
                            Icons.chat_bubble_outline,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    appName: appName,
                                    iconBytes: iconBytes,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              CustomNavBar(),
            ],
          ),
        ),
      ),
    );
  }
}
