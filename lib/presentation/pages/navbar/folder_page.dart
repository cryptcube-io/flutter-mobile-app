import 'package:flutter/material.dart';

import '../../components/custom_navbar.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Folder Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}