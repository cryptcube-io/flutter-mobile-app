
import 'package:flutter/material.dart';
import '../../../core/theme/colors/app_colors.dart';
import '/services/logger_service.dart';

class ConversationItem {
  final String appName;
  final String question;
  final String timestamp;

  ConversationItem({
    required this.appName,
    required this.question,
    required this.timestamp,
  });

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    String appName = 'Unknown';
    if (json['documentName'] != null && json['documentName'].toString().contains('/')) {
      appName = json['documentName'].toString().split('/')[1];
    }
    
    String question = 'No question';
    if (json['conversation'] != null && json['conversation'].isNotEmpty) {
      question = json['conversation'][0]['userDialogue'] ?? 'No question';
    }
    
    return ConversationItem(
      appName: appName,
      question: question,
      timestamp: '02/15/2025, 12:35',
    );
  }
}

class RecentConversationsWidget extends StatefulWidget {
  final List<ConversationItem> conversationItems;
  final bool isLoading;
  final String? error;

  const RecentConversationsWidget({
    Key? key,
    required this.conversationItems,
    this.isLoading = false,
    this.error,
  }) : super(key: key);

  @override
  State<RecentConversationsWidget> createState() => _RecentConversationsWidgetState();
}

class _RecentConversationsWidgetState extends State<RecentConversationsWidget> with LoggerMixin {
  bool _isExpanded = false;
  final int _maxInitialItems = 3;

  @override
  void initState() {
    super.initState();
    logInfo('RecentConversationsWidget initialized');
  }

  IconData _getAppIcon(String appName) {
    logDebug('Getting icon for app: $appName');
    switch (appName.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'facebook':
        return Icons.facebook;
      case 'tiktok':
        return Icons.music_note;
      case 'whatsapp':
        return Icons.message;
      case 'doordash':
        return Icons.delivery_dining;
      default:
        logDebug('No specific icon found for $appName, using default');
        return Icons.app_shortcut;
    }
  }

  Color _getAppColor(String appName) {
    switch (appName.toLowerCase()) {
      case 'instagram':
        return Colors.pink;
      case 'facebook':
        return Colors.blue;
      case 'tiktok':
        return Colors.black;
      case 'whatsapp':
        return Colors.green;
      case 'doordash':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildIntroText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              children: [
                const TextSpan(text: "Hi, I am "),
                TextSpan(
                  text: "Bagheera",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Ask me anything related to privacy policy.",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIntroText(),
        const SizedBox(height: 15),
        Card(
          elevation: 1,
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Recent Conversation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: 12),
                _buildContent(),
                if (widget.conversationItems.length > _maxInitialItems) ...[
                  // SizedBox(height: 1),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(
                        _isExpanded ? 'Show Less' : 'View All Converstation',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return Container(
        height: 150,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.error != null) {
      return Container(
        height: 150,
        child: Center(
          child: Text(widget.error!, style: TextStyle(color: Colors.red)),
        ),
      );
    }

    if (widget.conversationItems.isEmpty) {
      return Container(
        height: 150,
        child: Center(
          child: Text('No recent conversations found.'),
        ),
      );
    }

    List<ConversationItem> displayItems = _isExpanded 
      ? widget.conversationItems 
      : widget.conversationItems.length > _maxInitialItems 
        ? widget.conversationItems.sublist(0, _maxInitialItems) 
        : widget.conversationItems;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: displayItems.map((item) {
        String truncatedQuestion = item.question.length > 30 
          ? '${item.question.substring(0, 30)}...' 
          : item.question;
          
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              decoration: BoxDecoration(
                color: _getAppColor(item.appName),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                _getAppIcon(item.appName), 
                color: Colors.white, 
                size: 24,
              ),
            ),
            title: Text(
              truncatedQuestion,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              item.timestamp,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            trailing: Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        );
      }).toList(),
    );
  }
}