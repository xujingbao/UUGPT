import 'package:openai_client/openai_client.dart';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

import 'dart:convert';

import 'package:flutter/services.dart';

class OpenAIChat {
  OpenAIConfiguration _configuration =
      OpenAIConfiguration(apiKey: '', organizationId: '');

  Future<void> _loadConfig() async {
    final configJson = await rootBundle.loadString('assets/openai-key.json');
    final json = jsonDecode(configJson) as Map<String, dynamic>;

    _configuration = OpenAIConfiguration(
      apiKey: json['API_KEY'] as String,
      organizationId: json['ORG_ID'] as String,
    );
  }

  Future<String> chatWithGPT(String message) async {
    if (_configuration.apiKey == '' || _configuration.organizationId == '') {
      await _loadConfig();
    }
    print('Chatting with GPT: $message'); // 添加日志信息
    final client = OpenAIClient(
      configuration: _configuration,
      enableLogging: true,
    );

    final chat = await client.chat.create(
      model: 'gpt-3.5-turbo',
      messages: [ChatMessage(role: 'user', content: message)],
    ).data;
    print('Received GPT response: $chat'); // 添加日志信息
    return chat.toString();
  }
}
