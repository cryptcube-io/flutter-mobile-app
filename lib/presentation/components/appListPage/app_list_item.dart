import 'package:flutter/material.dart';
import '../../../models/app_item.dart';
import '../../pages/score/app_detail.dart';

class AppListItem extends StatelessWidget {
  final AppItem app;

  const AppListItem({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: app.iconBytes != null
              ? Image.memory(
                  app.iconBytes!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("Error loading icon for ${app.name}: $error");
                    return Icon(
                      Icons.android,
                      color: Colors.white,
                      size: 24,
                    );
                  },
                )
              : Icon(
                  Icons.android,
                  color: Colors.white,
                  size: 24,
                ),
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
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: '/${app.score.split('/')[1]}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
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
    );
  }
}