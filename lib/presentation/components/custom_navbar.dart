import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../services/navigation_service.dart';
import '../../services/logger_service.dart';

class CustomNavBar extends StatelessWidget with LoggerMixin {
  final NavigationService navigationService = NavigationService();

  CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // logDebug('Building navbar with current index: ${navigationService.currentIndex}');
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
                'lib/icons/svg/home-outline.svg',
                'lib/icons/svg/home.svg',
                'Home',
                1,
                navigationService.currentIndex == 1,
              ),
              _buildNavItem(
                context,
                'lib/icons/svg/chat-bubble-outline.svg',
                'lib/icons/svg/chat-bubble-left-right.svg',
                'Chat',
                2,
                navigationService.currentIndex == 2,
              ),
              _buildNavItem(
                context,
                'lib/icons/svg/square-3-stack-outline.svg',
                'lib/icons/svg/square-3-stack-3d.svg',
                'Insights',
                3,
                navigationService.currentIndex == 3,
              ),
              _buildNavItem(
                context,
                'lib/icons/svg/user-circle-outline.svg',
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
    String unselectedSvgPath,
    String selectedSvgPath,
    String label,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        logInfo('Navigating to: $label');
        if (index != 0) {
          navigationService.navigateToPage(context, index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (context) {
              final path = isSelected ? selectedSvgPath : unselectedSvgPath;
              
              try {
                return SvgPicture.asset(
                  path,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isSelected ? const Color(0xFF5A4BDD) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                );
              } catch (e, stackTrace) {
                logError('Failed to load icon: $path', e, stackTrace);
                return Container(
                  width: 24,
                  height: 24,
                  color: Colors.red.withOpacity(0.3),
                  child: const Center(
                    child: Text('!', style: TextStyle(color: Colors.white)),
                  ),
                );
              }
            },
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