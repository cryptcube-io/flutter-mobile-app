import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/theme/colors/app_colors.dart';
import '../../../models/app_data.dart';
import '../../../constants/api_endpoints.dart';
import '../../../services/auth_notifier_service.dart';
import '../../../services/logger_service.dart';
import '../../components/custom_navbar.dart';
import '../../components/navbarChatPage/frequently_used_apps_card.dart';
import '../../components/navbarChatPage/introduction_text_section.dart';
import '../../components/navbarChatPage/recent_conv_widget.dart';
import '../../pages/score/app_detail.dart';
import 'chat_page.dart';

class IntroductionPage extends ConsumerStatefulWidget {
  const IntroductionPage({super.key});
  
  @override
  ConsumerState<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends ConsumerState<IntroductionPage> with LoggerMixin {
  late Future<List<ConversationItem>> _conversationsFuture;
  
  @override
  void initState() {
    super.initState();
    logInfo('Initializing IntroductionPage');
    _conversationsFuture = _fetchConversations();
  }
  
  Future<List<ConversationItem>> _fetchConversations() async {
    logInfo('Fetching conversation history');
    final token = ref.read(authProvider).token;
    
    if (token == null) {
      logError('Auth token is null, cannot fetch conversation history');
      return [];
    }
    
    try {
      final Uri apiUrl = Uri.parse(ApiEndpoints.getAllConversationHistory);
      logDebug('Making API request to ${ApiEndpoints.getAllConversationHistory}');
      
      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        logInfo('Successfully fetched conversation history. Count: ${data.length}');
        
        List<ConversationItem> items = [];
        for (var entry in data) {
          if (entry['documentName'] != null && 
              entry['documentName'].toString().contains('/') &&
              entry['conversation'] != null && 
              entry['conversation'].isNotEmpty) {
            items.add(ConversationItem.fromJson(entry));
          }
        }
        
        logInfo('Parsed ${items.length} conversation items');
        return items;
      }
      
      logError('Failed to fetch conversation history. Status code: ${response.statusCode}');
      return [];
    } catch (e, stackTrace) {
      logError('Error fetching conversations', e, stackTrace);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    logDebug('Building IntroductionPage');
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder<List<ConversationItem>>(
                future: _conversationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    logDebug('Waiting for conversations data');
                    return const RecentConversationsWidget(
                      conversationItems: [],
                      isLoading: true,
                    );
                  } else if (snapshot.hasError) {
                    logError('Error loading conversations', snapshot.error);
                    return RecentConversationsWidget(
                      conversationItems: [],
                      error: 'Error: ${snapshot.error}',
                    );
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    logInfo('Displaying ${snapshot.data!.length} conversations');
                    return RecentConversationsWidget(
                      conversationItems: snapshot.data!,
                    );
                  } else {
                    logInfo('No conversations found, showing IntroductionTextSection');
                    return const IntroductionTextSection();
                  }
                },
              ),
              Expanded(
                child: FrequentlyUsedAppsCard(
                  onAppSelected: (AppData app) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          appName: app.name,
                          iconBytes: app.iconBytes,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}