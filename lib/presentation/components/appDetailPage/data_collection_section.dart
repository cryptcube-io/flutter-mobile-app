import 'package:flutter/material.dart';

class DataCollectionSection extends StatefulWidget {
  const DataCollectionSection({super.key});

  @override
  State<DataCollectionSection> createState() => _DataCollectionSectionState();
}

class _DataCollectionSectionState extends State<DataCollectionSection> {
  bool isExpanded = false;

  Widget _buildDataItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        children: [
          ListTile(
            title: const Text(
              'Data collected',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              'Data this app may collect',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded) ...[
            _buildDataItem(
              'Location',
              'Approximate Location',
              Icons.location_on_outlined,
            ),
            _buildDataItem(
              'Personal Info',
              'Email address and Phone number',
              Icons.person_outline,
            ),
          ],
        ],
      ),
    );
  }
}