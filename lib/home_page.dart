import 'package:flutter/material.dart';
import 'dart:async';

import 'openai.dart';
import 'openai_message.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<OpenAIMessage> _messages = [];

  final _scrollController = ScrollController();
  bool _isScrollToBottom = false; // 是否自动滚动到最底部
  Timer? _timer; // 定时器

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScrollExtent = _scrollController.position.pixels;
      final delta = maxScrollExtent - currentScrollExtent;
      // 判断是否需要自动滚动
      if (delta < 50) {
        setState(() {
          _isScrollToBottom = true;
        });
      } else {
        setState(() {
          _isScrollToBottom = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 释放定时器资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 左侧列表
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 标题
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '会话列表',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 列表
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('Evan'),
                          ),
                          title: Text('会话 $index'),
                          subtitle: Text('Last message from Contact $index'),
                          onTap: () {
                            // TODO: 点击列表项后打开会话窗口
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 右侧会话窗口
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // 聊天内容
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (OpenAIMessage _openAIMessage in _messages)
                            MessageBubble(
                              message: _openAIMessage.content,
                              isSentByMe: _openAIMessage.isSentByMe,
                            ),
                        ],
                      ),
                    ),
                  ),
                  // 输入框和发送按钮
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: '随便问我点什么',
                            ),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            // 点击发送按钮后发送消息
                            final message = _textEditingController.text.trim();
                            print('Sending message: $message'); // 添加日志
                            if (message.isNotEmpty) {
                              _textEditingController.clear();
                              setState(() {
                                _messages.add(OpenAIMessage(
                                  content: message,
                                  time: DateTime.now(),
                                  isSentByMe: true,
                                ));
                                _scrollToBottom();
                              });

                              // setState(() {
                              //   _messages.add(OpenAIMessage(
                              //     content: '正在输入...',
                              //     time: DateTime.now(),
                              //     isSentByMe: false,
                              //   ));
                              //   _scrollToBottom();
                              // });

                              // 调用OpenAI聊天API
                              final openAIChat = OpenAIChat();
                              final chat = await openAIChat.chatWithGPT(message);
                              print('Received message: $chat.toString()'); // 添加日志
                              _messages.removeLast();
                              setState(() {
                                _messages.add(OpenAIMessage(
                                  content: chat.toString(),
                                  time: DateTime.now(),
                                  isSentByMe: false,
                                ));
                                _scrollToBottom();
                              });
                            }
                          },
                          child: Text('发送'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    setState(() {
      _isScrollToBottom = true;
    });
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
