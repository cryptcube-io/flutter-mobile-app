import 'package:flutter/material.dart';
import '../../../models/app_item.dart';
import '../../../services/app_loader_service.dart';
import '../../components/appListPage/app_list_item.dart';
import '../../components/custom_navbar.dart';


class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  final AppLoaderService _appLoader = AppLoaderService();
  List<AppItem> apps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      final loadedApps = await _appLoader.loadApps();
      setState(() {
        apps = loadedApps;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Apps affecting your Score',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: apps.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemBuilder: (context, index) => AppListItem(app: apps[index]),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar:  CustomNavBar(),
    );
  }
}