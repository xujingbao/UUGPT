import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async' show Future;

import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:openai_client/openai_client.dart';
import 'package:openai_client/src/model/openai_chat/chat_message.dart';

Future<void> main() async {
  runApp(MyApp());

  // Load app credentials from environment variables or file.
  final configuration = await loadConfig();
  print(configuration.apiKey);
  // Create a new client.
  final client = OpenAIClient(
    configuration: configuration,
    enableLogging: true,
  );
  print(client);
  // Fetch the models.
  final models = await client.models.list().data;
  // Print the models list.
  print(models.toString());

  // Create a chat.
  final chat = await client.chat
      .create(
          model: 'gpt-3.5-turbo',
          message: const ChatMessage(
            role: 'user',
            content: '你是谁?',
          ))
      .data;
  // Print the chat.
  print(chat.toString());
}

Future<OpenAIConfiguration> loadConfig() async {
  final configJson = await rootBundle.loadString('assets/openai-key.json');
  final json =  jsonDecode(configJson) as Map<String, dynamic>;

  return OpenAIConfiguration(
    apiKey: json['API_KEY'] as String,
    organizationId: json['ORG_ID'] as String,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UUGPT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'UUGPT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = [
    '会话1',
    '会话1',
    '会话1',
    '会话1',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
    'Item 10'
  ];
  String selectedItem = '';
  String inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(items[index]),
                  onTap: () {
                    setState(() {
                      selectedItem = items[index];
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Enter text here'),
                  onChanged: (text) {
                    setState(() {
                      inputText = text;
                    });
                  },
                ),
                SizedBox(height: 16),
                selectedItem.isNotEmpty
                    ? AlertDialog(
                        title: Text('Selected Item'),
                        content: Text(selectedItem + '\n\n' + inputText),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedItem = '';
                                inputText = '';
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
