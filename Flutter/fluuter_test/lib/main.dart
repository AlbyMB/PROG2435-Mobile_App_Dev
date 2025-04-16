import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: Center(
          child: FilledButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) { return Screen2(message: "Hello page 2"); }),
            );
          }, child: Text("Go to Screen 2")),
        ));
  }
}

class Screen2 extends StatelessWidget {
  String message;

  Screen2({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Screen 2'),
        ),
        body: Center(
            child: Column(
          children: [
            Text("Welcome to Screen 2"),
            Text("Message from Screen 1: $message"),
            FilledButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text('Go to Home Screen'))
          ],
        )));
  }
}
