import 'package:flutter/material.dart';

import '../../../models/app_item.dart';
import '../../pages/score/app_detail.dart';
import '../../pages/score/app_list.dart';


class AppListItem extends StatelessWidget {
  final AppItem app;

  const AppListItem({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
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
  }
}