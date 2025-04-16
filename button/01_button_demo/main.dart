import "package:flutter/material.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

// --------------------------------------
// Button attached to an anonymous click handler function
// --------------------------------------
class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Button Demo"),
        ),
        body: Column(children: [
          FilledButton(
              onPressed: () {
                print("You pressed the button!");
              },
              child: Text("Push Me")),
          Text("Here is a label", style: TextStyle(fontSize: 20)),
        ]));
  }
}

// --------------------------------------
// 2. Button attached to a named click handler function
// --------------------------------------
// class HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     void doSomething() {
//       print("You pressed the button!");
//     }

//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Button Demo"),
//         ),
//         body: Column(children: [
//           FilledButton(onPressed: doSomething, child: Text("Push Me")),
//           Text("Here is a label", style: TextStyle(fontSize: 20)),
//         ]));
//   }
// }

// --------------------------------------
// 3. Calling a Named function with parameters
// --------------------------------------
// class HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     void sayHelloTo(String name) {
//       print("Hello ${name}");
//     }

//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Button Demo"),
//         ),
//         body: Column(children: [
//           FilledButton(
//               onPressed: () {
//                 sayHelloTo("Lisa");
//               },
//               child: Text("Push Me")),
//           Text("Here is a label", style: TextStyle(fontSize: 20)),
//         ]));
//   }
// }
