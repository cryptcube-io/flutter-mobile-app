import 'package:flutter/material.dart';

import '../presentation/pages/navbar/chat_page.dart';
import '../presentation/pages/navbar/cube_page.dart';
import '../presentation/pages/navbar/folder_page.dart';
import '../presentation/pages/navbar/home_page.dart';
import '../presentation/pages/navbar/people_page.dart';


class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  Future<void> navigateToPage(BuildContext context, int index) async {

    _currentIndex = index;
    Widget page;

    switch (index) {
      case 1:
        page = const HomePage(token: "ddasnjk",);
        break;
      case 3:
        page = const FolderPage();
        break;
      case 2:
        page = ChatPage(appName:"Reddit");
        break;
      case 5:
        page = const PeoplePage();
        break;
      case 4:
        page = const CubePage();
        break;
      default:
        return;
    }

    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}