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
    logDebug('Building CustomNavBar, currentIndex: ${navigationService.currentIndex}');
    
    // Log asset bundle to check if assets are properly registered
    DefaultAssetBundle.of(context).loadString('AssetManifest.json').then((manifestJson) {
      logDebug('Asset manifest available: ${manifestJson.substring(0, Math.min(100, manifestJson.length))}...');
    }).catchError((error, stackTrace) {
      logError('Failed to load asset manifest', error, stackTrace);
    });
    
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
    logDebug('Building nav item: $label, index: $index, isSelected: $isSelected');
    logDebug('Using SVG path: ${isSelected ? selectedSvgPath : unselectedSvgPath}');
    
    return GestureDetector(
      onTap: () {
        logInfo('Tapped on nav item: $label with index: $index');
        if (index != 0) {
          logInfo('Navigating to page with index: $index');
          navigationService.navigateToPage(context, index);
        } else {
          logInfo('Navigation skipped for index 0');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Builder(
            builder: (context) {
              final path = isSelected ? selectedSvgPath : unselectedSvgPath;
              logDebug('Attempting to load SVG file: $path');
              
              // Check if file exists in asset bundle
              bool fileExists = false;
              try {
                DefaultAssetBundle.of(context).load(path).then((_) {
                  fileExists = true;
                  logDebug('SVG file exists: $path');
                }).catchError((error) {
                  logError('SVG file does not exist in asset bundle: $path', error, null);
                });
              } catch (e) {
                logDebug('Error checking if file exists: $path');
              }
              
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
                logError('Error loading SVG: $path', e, stackTrace);
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