import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/app_item.dart';
import '../../../services/app_loader_service.dart';
import '../../../services/auth_notifier_service.dart';
import '../../components/appListPage/app_list_item.dart';
import '../../components/custom_navbar.dart';

class AppList extends ConsumerStatefulWidget {
  const AppList({super.key});

  @override
  ConsumerState<AppList> createState() => _AppListState();
}

class _AppListState extends ConsumerState<AppList> {
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
      final token = ref.read(authProvider).token;
      final loadedApps = await _appLoader.loadApps(token);
      setState(() {
        apps = loadedApps;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load apps'),
          backgroundColor: Colors.red,
        ),
      );
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