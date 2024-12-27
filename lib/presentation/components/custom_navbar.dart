import 'package:flutter/material.dart';

import '../../services/navigation_service.dart';


class CustomNavBar extends StatelessWidget {
  final NavigationService navigationService = NavigationService();

  CustomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_outlined),
          label: 'Folder',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'People',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_in_ar_outlined),
          label: 'Cube',
        ),
      ],
      currentIndex: navigationService.currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) => navigationService.navigateToPage(context, index),
    );
  }
}