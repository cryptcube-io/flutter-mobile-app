import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFc9c5f4), Color(0xFFfecdd3)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                SvgPicture.asset(
                  'lib/icons/svg/sparkles.svg',
                  height: 24,
                  width: 24,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: onSubmit,
                    decoration: const InputDecoration(
                      hintText: 'Ask Bagheera anything',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SvgPicture.asset(
                  'lib/icons/svg/microphone.svg',
                  height: 24,
                  width: 24,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}