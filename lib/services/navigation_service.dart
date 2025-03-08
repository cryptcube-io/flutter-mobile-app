import 'package:flutter/material.dart';

import '../presentation/pages/navbar/folder_page.dart';
import '../presentation/pages/navbar/home_page.dart';
import '../presentation/pages/navbar/navbar_chat_page.dart';
import '../presentation/pages/navbar/people_page.dart';
import '../../../services/logger_service.dart';

class NavigationService with LoggerMixin {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal();

  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  Future<void> navigateToPage(BuildContext context, int index) async {
    logInfo('Navigating to page index: $index');
    _currentIndex = index;
    Widget page;

    switch (index) {
      case 1:
        page = const HomePage();
        break;
      case 2:
        logDebug('Navigating to Introduction Page');
        page = const IntroductionPage();
        break;
      case 3:
        logDebug('Navigating to Folder Page');
        page = const FolderPage();
        break;
      case 4:
        logDebug('Navigating to People Page');
        page = const PeoplePage();
        break;
      default:
        logError('Invalid navigation index: $index');
        return;
    }

    logInfo('Navigating to ${page.runtimeType}');
    
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );

    logInfo('Navigation completed to ${page.runtimeType}');
  }
}
