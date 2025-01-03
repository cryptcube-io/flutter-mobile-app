import 'package:flutter/material.dart';
import '../../components/custom_navbar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  String _currentlyTypingText = '';
  int _currentIndex = 0;
  final String _responseText = "LinkedIn's privacy policy can feel a bit dense, so here's a simpler breakdown of what it generally means:\n\n1. What data they collect:\nLinkedIn gathers information you provide when you sign up (like your name, email, and job details) and when you use the platform (your posts, messages, and job applications).";

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

  void _startTypingResponse() {
    _currentlyTypingText = '';
    _currentIndex = 0;
    
    void typeNextCharacter() {
      if (_currentIndex < _responseText.length) {
        setState(() {
          _currentlyTypingText += _responseText[_currentIndex];
          _currentIndex++;
        });
        _scrollToBottom();
        Future.delayed(Duration(milliseconds: 50), typeNextCharacter);
      } else {
        setState(() {
          _messages.add({
            'text': _responseText,
            'isUser': false,
          });
          _isTyping = false;
          _currentlyTypingText = '';
        });
        _scrollToBottom();
      }
    }
    
    typeNextCharacter();
  }

  void _handleSubmit(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
      });
      _isTyping = true;
    });
    _textController.clear();
    _scrollToBottom();

    Future.delayed(Duration(seconds: 2), () {
      _startTypingResponse();
    });
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 16, right: 32),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            SizedBox(width: 4),
            _buildDot(1),
            SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: (value + (index * 0.2)) % 1,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Privacy Doc',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ..._messages.map((message) => Align(
                        alignment: message['isUser'] 
                            ? Alignment.centerRight 
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(
                            bottom: 16,
                            left: message['isUser'] ? 32 : 0,
                            right: message['isUser'] ? 0 : 32,
                          ),
                          decoration: BoxDecoration(
                            color: message['isUser'] 
                                ? Color(0xFF4A4A4A)
                                : Colors.grey[200],
                            borderRadius: message['isUser']
                                ? BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  )
                                : BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(
                              color: message['isUser'] 
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )).toList(),
                      if (_isTyping && _currentlyTypingText.isEmpty) _buildTypingIndicator(),
                      if (_currentlyTypingText.isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(right: 32),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              _currentlyTypingText,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.attach_file, color: Colors.grey),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _textController,
                          onSubmitted: _handleSubmit,
                          decoration: InputDecoration(
                            hintText: 'Enter Text',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.mic, color: Colors.grey),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _handleSubmit(_textController.text),
                      child: Icon(Icons.send, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}