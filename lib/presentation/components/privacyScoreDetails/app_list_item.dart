import 'package:flutter/material.dart';

import '../../../models/app_data.dart';
import '../../pages/score/app_detail.dart';
import '../shared/standard_button.dart';
import 'apps_list_section.dart';

class AppsListSection extends StatelessWidget {
  final List<AppData> apps;
  final bool isLoading;
  final VoidCallback onViewAllTapped;

  const AppsListSection({
    required this.apps,
    required this.isLoading,
    required this.onViewAllTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Text(
              'Apps Affecting Your Score (${isLoading ? "..." : apps.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            ...apps.map((app) => AppListItem(
              app: app,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppDetail(
                    appName: app.name,
                    iconBytes: app.iconBytes,
                  ),
                ),
              ),
            )),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StandardButton(
                text: 'View All Apps',
                onTap: onViewAllTapped,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
