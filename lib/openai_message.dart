import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class OpenAIMessage {
  final String content;
  final DateTime time;
  final bool isSentByMe;

  OpenAIMessage({
    required this.content,
    required this.time,
    required this.isSentByMe,
  });
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isSentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSentByMe)
          Container(
            margin: EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: 40.0,
              height: 40.0,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/other.png'),
              ),
            ),
          ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: isSentByMe ? 51.0 : 8.0,
              right: isSentByMe ? 8.0 : 16.0,
              top: 8.0,
              bottom: 8.0,
            ),
            decoration: BoxDecoration(
              color: isSentByMe ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Wrap(
              children: [
                // if (!isSentByMe)
                 
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: AnimatedTextKit(
                //       animatedTexts: [
                //         TypewriterAnimatedText(
                //           message,
                //           speed: const Duration(milliseconds: 100),
                //           textStyle: TextStyle(
                //             color: Colors.black,
                //             fontSize: 16.0,
                //           ),
                //         ),
                //       ],
                //       totalRepeatCount: 1,
                //       pause: const Duration(milliseconds: 300),
                //     ),
                //   ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            alignment:
                isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 8.0),
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/me.png'),
            ),
          ),
        ),
      ],
    );
  }
}
