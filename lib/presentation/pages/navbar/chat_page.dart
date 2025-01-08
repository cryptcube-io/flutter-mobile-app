import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/custom_navbar.dart';
import 'dart:convert';

class ChatPage extends StatefulWidget {
  final String appName;
  const ChatPage({super.key, required this.appName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  final Dio _dio = Dio();
  bool _isTyping = false;
  String _currentlyTypingText = '';
  int _currentIndex = 0;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('auth_token');
    });
  }

  Future<String?> _getPrivacyResponse(String question) async {
    try {
      print('\n=== Request Details ===');
      print('Question: $question');
      print('App Name: ${widget.appName}');
      print('Token Status: ${_token != null ? 'Present' : 'Missing'}');

      if (_token == null) return 'Please sign in first';

      final response = await _dio.get(
        'https://privacydoctor.cryptcube.io/api/privacyConverse',
        queryParameters: {
          'appName': widget.appName,
          'question': question,
          'documentType': 'txt'
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_token'},
          validateStatus: (status) => true,
        ),
      );

      print('\n=== Response Details ===');
      print('Status Code: ${response.statusCode}');

      if (response.data != null && response.data['response'] != null) {
        final responseStr = response.data['response'] as String;

        // Extract everything between response=' and the last '}
        final startIndex = responseStr.indexOf("response='") + 10;
        final endIndex = responseStr.lastIndexOf("'}");

        if (startIndex > 9 && endIndex != -1) {
          final jsonStr = responseStr.substring(startIndex, endIndex);
          final responseJson = json.decode(jsonStr);

          if (responseJson['inferenceResponse'] != null) {
            String inferenceStr = responseJson['inferenceResponse'].toString();

            try {
              // Try to find the answer in the cleaned string
              if (inferenceStr.contains('"answer"')) {
                final answerStart = inferenceStr.indexOf('"answer"') + 9;
                String answer = inferenceStr.substring(answerStart);

                // Clean up the answer
                answer = answer
                    .replaceAll('"', '')
                    .replaceAll('{', '')
                    .replaceAll('}', '')
                    .replaceAll('\\n', ' ')
                    .trim();

                // Remove any residual JSON syntax
                if (answer.endsWith('} }')) {
                  answer = answer.substring(0, answer.length - 4).trim();
                }

                print('\n=== Final Processed Answer ===');
                print(answer);
                return answer;
              }
              return inferenceStr;
            } catch (e) {
              print('\n=== Processing Error ===');
              print('Error processing answer: $e');
              return inferenceStr.replaceAll('"', '').trim();
            }
          }
        }
      }
      return 'Could not process the response';
    } catch (e) {
      print('\n=== Error ===');
      print('Exception occurred: $e');
      return 'Connection error: $e';
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
        _scrollToBottom();
      }
    }

    typeNextCharacter();
  }

  void _handleSubmit(String text) async {
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

    final response = await _getPrivacyResponse(text);
    if (response != null) {
      _startTypingResponse(response);
    } else {
      setState(() {
        _isTyping = false;
        _messages.add({
          'text': 'Sorry, I encountered an error. Please try again.',
          'isUser': false,
        });
      });
      _scrollToBottom();
    }
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
                  widget.appName,
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
                      ..._messages
                          .map((message) =>
                              _buildMessageBubble(message, context))
                          .toList(),
                      if (_isTyping && _currentlyTypingText.isEmpty)
                        _buildTypingIndicator(),
                      if (_currentlyTypingText.isNotEmpty)
                        _buildMessageBubble({
                          'text': _currentlyTypingText,
                          'isUser': false,
                        }, context),
                    ],
                  ),
                ),
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }

  Widget _buildMessageBubble(
      Map<String, dynamic> message, BuildContext context) {
    return Align(
      alignment:
          message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
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
          color: message['isUser'] ? Color(0xFF4A4A4A) : Colors.grey[200],
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
            color: message['isUser'] ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
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
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
