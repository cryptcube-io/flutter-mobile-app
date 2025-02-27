import 'package:Cryptcube_mobile_app/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/chat_service.dart';
import '../../../services/logger_service.dart';
import '../../components/chatPage/chat_input_field.dart';
import '../../components/chatPage/chat_message_bubble.dart';
import '../../components/custom_navbar.dart';
import '../../components/chatPage/typing_indicator.dart';

class ChatPage extends StatefulWidget with LoggerMixin {
  final String appName;
  final Uint8List? iconBytes;

  const ChatPage({super.key, required this.appName, this.iconBytes});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with LoggerMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final ChatService _chatService = ChatService();

  bool _isTyping = false;
  String _currentlyTypingText = '';
  int _currentIndex = 0;
  String? _token;

  @override
  void initState() {
    super.initState();
    logInfo('Initializing ChatPage for app: ${widget.appName}');
    _loadToken();
  }

  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _token = prefs.getString('auth_token');
      });
      logInfo('Auth token loaded successfully');
    } catch (e, stackTrace) {
      logError('Failed to load auth token', e, stackTrace);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startTypingResponse(String response) {
    logDebug('Starting typing animation for response');
    _currentlyTypingText = '';
    _currentIndex = 0;

    void typeNextCharacter() {
      if (_currentIndex < response.length) {
        setState(() {
          _currentlyTypingText += response[_currentIndex];
          _currentIndex++;
        });
        _scrollToBottom();
        Future.delayed(Duration(milliseconds: 50), typeNextCharacter);
      } else {
        setState(() {
          _messages.add({
            'text': response,
            'isUser': false,
          });
          _isTyping = false;
          _currentlyTypingText = '';
        });
        logDebug('Typing animation completed');
        _scrollToBottom();
      }
    }

    typeNextCharacter();
  }

  void _handleSubmit(String text) async {
    if (text.isEmpty) return;
    
    logInfo('Processing new message for ${widget.appName}');
    
    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
      });
      _isTyping = true;
    });
    
    _textController.clear();
    _scrollToBottom();

    try {
      final response = await _chatService.getPrivacyResponse(text, widget.appName, _token);
      if (response != null) {
        logInfo('Received response from chat service');
        _startTypingResponse(response);
      } else {
        logError('Received null response from chat service');
        setState(() {
          _isTyping = false;
          _messages.add({
            'text': 'Sorry, I encountered an error. Please try again.',
            'isUser': false,
          });
        });
      }
    } catch (e, stackTrace) {
      logError('Error getting chat response', e, stackTrace);
      setState(() {
        _isTyping = false;
        _messages.add({
          'text': 'Sorry, I encountered an error. Please try again.',
          'isUser': false,
        });
      });
    }
    _scrollToBottom();
  }

  Widget _buildAppHeader() {
    logDebug('Building app header');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: widget.iconBytes != null && widget.iconBytes!.isNotEmpty
                  ? Image.memory(
                      widget.iconBytes!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        logError('Failed to load app icon', error, stackTrace);
                        return _fallbackIcon();
                      },
                    )
                  : _fallbackIcon(),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.appName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackIcon() {
    logDebug('Using fallback icon');
    return Container(
      width: 40,
      height: 40,
      color: const Color(0xFF6044DE),
      child: Icon(
        Icons.apps,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logDebug('Building ChatPage widget');
    return Scaffold(
      backgroundColor: AppColors.contentAreaBackground,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppHeader(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._messages.map((message) => ChatMessageBubble(
                            message: message['text'],
                            isUser: message['isUser'],
                          )),
                      if (_isTyping && _currentlyTypingText.isEmpty)
                        TypingIndicator(),
                      if (_currentlyTypingText.isNotEmpty)
                        ChatMessageBubble(
                          message: _currentlyTypingText,
                          isUser: false,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            ChatInputField(
              controller: _textController,
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }

  @override
  void dispose() {
    logInfo('Disposing ChatPage for ${widget.appName}');
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}