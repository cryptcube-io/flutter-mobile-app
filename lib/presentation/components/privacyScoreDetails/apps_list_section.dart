import 'package:flutter/material.dart';

import '../../../models/app_data.dart';

class AppListItem extends StatelessWidget {
  final AppData app;
  final VoidCallback onTap;

  const AppListItem({
    required this.app,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 0,
      ),
      leading: SizedBox(
        width: 48,
        height: 48,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: app.iconBytes != null
              ? Image.memory(
                  app.iconBytes!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                )
              : const SizedBox(),
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
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: '${app.score}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const TextSpan(
              text: '/800',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
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
      onTap: onTap,
    );
  }
}