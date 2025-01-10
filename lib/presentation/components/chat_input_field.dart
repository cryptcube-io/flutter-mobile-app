import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmit;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
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
                  controller: controller,
                  onSubmitted: onSubmit,
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
              onTap: () => onSubmit(controller.text),
              child: Icon(Icons.send, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}