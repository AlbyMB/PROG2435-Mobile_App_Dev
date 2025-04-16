import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topRight,
          child: Icon(Icons.forward, size: 50.0, color: Colors.red),
        ),
        appBar: AppBar(
          title: Text('Hello World App')
        ),
      ),
    );
  }
}
