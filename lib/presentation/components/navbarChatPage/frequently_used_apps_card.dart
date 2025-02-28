import 'package:Cryptcube_mobile_app/presentation/pages/score/app_list.dart';
import 'package:flutter/material.dart';
import '../../../models/app_data.dart';
import '../../../services/app_icon_manager.dart';
import '../../../services/app_loader_service.dart';
import '../../../core/theme/app_button_theme.dart';
import '../shared/standard_button.dart';


class FrequentlyUsedAppsCard extends StatefulWidget {
  final Function(AppData) onAppSelected;

  const FrequentlyUsedAppsCard({
    super.key,
    required this.onAppSelected,
  });

  @override
  State<FrequentlyUsedAppsCard> createState() => _FrequentlyUsedAppsCardState();
}

class _FrequentlyUsedAppsCardState extends State<FrequentlyUsedAppsCard> {
  final AppLoaderService _appLoader = AppLoaderService();
  final AppIconManager _iconManager = AppIconManager();
  List<AppData> apps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      final appItems = await _appLoader.loadApps('your_token_here', pageSize: 5);
      setState(() {
        apps = appItems
            .map((item) => AppData(
                  item.name,
                  0,
                  item.packageName,
                  item.iconBytes,
                ))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select from frequently used apps",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: apps.map((app) => _buildAppIcon(app)).toList(),
                ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "OR",
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 20),
          StandardButton(
            text: "Select an App",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>  AppList(),
                ),
              );
            },
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAppIcon(AppData app) {
    return GestureDetector(
      onTap: () => widget.onAppSelected(app),
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.white,
            child: app.iconBytes != null
                ? Image.memory(
                    app.iconBytes!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        _iconManager.getFallbackIcon(app.name),
                        color: Colors.white,
                        size: 24,
                      );
                    },
                  )
                : Icon(
                    _iconManager.getFallbackIcon(app.name),
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}