import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                'lib/icons/svg/home.svg',
                'Home',
                1,
                navigationService.currentIndex == 1,
              ),
              _buildNavItem(
                context,
                'lib/icons/svg/chat-bubble-left-right.svg',
                'Chat',
                2,
                navigationService.currentIndex == 2,
              ),
              _buildNavItem(
                context,
                'lib/icons/svg/square-3-stack-3d.svg',
                'Insights',
                3,
                navigationService.currentIndex == 3,
              ),
              _buildNavItem(
                context,
                'lib/icons/svg/user-circle.svg',
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
    String svgPath,
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
          SvgPicture.asset(
            svgPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isSelected ? const Color(0xFF5A4BDD) : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF5A4BDD) : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}