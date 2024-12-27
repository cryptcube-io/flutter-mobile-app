import 'package:flutter/material.dart';
import 'package:my_app2/presentation/components/custom_navbar.dart';
import '../auth/signin_page.dart';
import 'dart:developer' as developer;

import '../score/app_list.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    developer.log('initState called', name: 'HomePage');
    developer.log('Auth Token: ${widget.token}', name: 'HomePage');
  } 

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    developer.log('Navigation item tapped: $index', name: 'HomePage');
  } //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    developer.log('didChangeDependencies called', name: 'HomePage');
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    developer.log('didUpdateWidget called', name: 'HomePage');

    if (oldWidget.token != widget.token) {
      developer.log('Token changed', name: 'HomePage');
    }
  }

  @override
  void dispose() {
    
    developer.log('dispose called', name: 'HomePage');
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.blue,
                    size: 28,
                  ),
                  onPressed: () {
                    developer.log('Notification bell pressed',
                        name: 'HomePage');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifications'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    developer.log('Score circle tapped', name: 'HomePage');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppList(),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '650',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield,
                        size: 80,
                        color: Colors.blue.withOpacity(0.7),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '75%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: CustomNavBar(),
  );
}
}
