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
        appBar: AppBar(
          title: Text("Take Courses"),
        ),
        body: Container(
          color: Colors.yellow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('shape01.png'),
              Text("Welcome", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              
            ],
          ),
        )
      ),
    );
  }
}
