import 'package:flutter/material.dart';
import '../../services/navigation_service.dart';

class CustomNavBar extends StatelessWidget {
  final NavigationService navigationService = NavigationService();

  CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                Icons.home,
                'Home',
                1,
                navigationService.currentIndex == 1,
              ),
              _buildNavItem(
                context,
                Icons.chat_bubble_outline,
                'Chat',
                2,
                navigationService.currentIndex == 2,
              ),
              _buildNavItem(
                context,
                Icons.insights,
                'Insights',
                0,
                navigationService.currentIndex == 0,
              ),
              _buildNavItem(
                context,
                Icons.person_outline,
                'You',
                4,
                navigationService.currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (index != 0) {
          navigationService.navigateToPage(context, index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}