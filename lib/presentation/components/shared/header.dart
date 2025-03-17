import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/logger_service.dart';

class CustomHeader extends StatelessWidget with LoggerMixin {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  const CustomHeader({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    // logDebug('Building CustomHeader with title: $title, showBackButton: $showBackButton');
    
    try {
      // Set system UI overlay style to match white background
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ));
      // logDebug('SystemUIOverlayStyle set to dark with white background');

      final statusBarHeight = MediaQuery.of(context).padding.top;
      // logDebug('Status bar height: $statusBarHeight');

      return Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: statusBarHeight),
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade100,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (showBackButton) ...[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                      ),
                      onPressed: () {
                        logDebug('Back button pressed');
                        if (onBackPressed != null) {
                          onBackPressed!();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.grey,
                    ),
                  ],
                  Expanded(
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  if (showBackButton)
                    const SizedBox(width: 48),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      logError('Error building CustomHeader', e, stackTrace);
      rethrow;
    }
  }
}