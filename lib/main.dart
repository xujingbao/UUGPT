import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async' show Future;

import 'package:flutter/material.dart';

import 'home_page.dart';

Future<void> main() async {
  runApp(UUApp());
}

class UUApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
