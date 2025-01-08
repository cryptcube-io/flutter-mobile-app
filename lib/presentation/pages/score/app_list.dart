import 'package:flutter/material.dart';
import 'package:my_app2/presentation/components/custom_navbar.dart';
import 'dart:math';
import '../../../services/installed_apps_service.dart';
import 'app_detail.dart';

class AppItem {
  final String name;
  final String packageName;
  final String score;
  final Color color;
  final IconData icon;

  AppItem({
    required this.name,
    required this.packageName,
    required this.score,
    required this.color,
    required this.icon,
  });
}

class AppList extends StatefulWidget {
  const AppList({super.key});

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  final Random random = Random();
  final InstalledAppsService _appsService = InstalledAppsService();
  List<AppItem> apps = [];
  bool isLoading = true;
  
  final List<IconData> icons = [
    Icons.apps, Icons.android, Icons.phone_android, Icons.app_blocking,
    Icons.app_registration, Icons.app_settings_alt, Icons.toys, Icons.extension,
    Icons.widgets, Icons.dashboard, Icons.grid_view, Icons.view_module,
    Icons.web, Icons.web_asset, Icons.web_stories, Icons.devices,
    Icons.phone_iphone, Icons.tablet_android, Icons.laptop, Icons.desktop_windows
  ];
  
  @override
  void initState() {
    super.initState();
    _loadApps();
  }
  
  Color getRandomColor() {
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }
  
  IconData getRandomIcon() {
    return icons[random.nextInt(icons.length)];
  }

  Future<void> _loadApps() async {
    try {
      final appInfoList = await _appsService.getInstalledAppsWithUsage();
      setState(() {
        apps = appInfoList.map((appInfo) => AppItem(
          name: appInfo.appName,
          packageName: appInfo.packageName,
          score: '${600 + (appInfo.appName.hashCode % 200)}/800',
          color: getRandomColor(),
          icon: getRandomIcon(),
        )).toList();
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
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: app.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            app.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          app.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                            text: 'Privacy Score: ',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: app.score.split('/')[0],
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '/${app.score.split('/')[1]}',
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppDetail(appName: app.name),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}