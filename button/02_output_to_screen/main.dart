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
// 1. When button pressed, update the Text
// --------------------------------------
class HomeScreenState extends State<HomeScreen> {
  String output = "Hello world!";

  void doSomething() {
    print("DEBUG: 1. Calling setState()...");
    setState(() {
      output = "Here is a new message!";
    });
  }

  @override
  Widget build(BuildContext context) {
    print("DEBUG: 2. The build() function is executing.");
    print("DEBUG: Check screen for updates");
    return Scaffold(
        appBar: AppBar(
          title: Text("Button Demo"),
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FilledButton(onPressed: doSomething, child: Text("Push Me")),
              Text("${output}", style: TextStyle(fontSize: 20)),
            ])));
  }
}

// --------------------------------------
// 2. When button pressed, increase the counter
// --------------------------------------
// class HomeScreenState extends State<HomeScreen> {
//   int counter = 50;

//   void increase() {
//     setState(() {
//       counter = counter + 1;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Button Demo"),
//         ),
//         body: Container(
//             padding: EdgeInsets.all(16),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               FilledButton(onPressed: increase, child: Text("Push Me")),
//               Text("Current value is: ${counter}",
//                   style: TextStyle(fontSize: 20)),
//             ])));
//   }
// }

// --------------------------------------
// 3. Add a Reset button
// --------------------------------------
// class HomeScreenState extends State<HomeScreen> {
//   int counter = 50;

//   void increase() {
//     setState(() {
//       counter = counter + 1;
//     });
//   }

//   void reset() {
//     setState(() {
//       counter = 50;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Button Demo"),
//         ),
//         body: Container(
//             padding: EdgeInsets.all(16),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               FilledButton(onPressed: increase, child: Text("Push Me")),
//               FilledButton(
//                   onPressed: reset, child: Text("Reset to initial value")),
//               Text("Current value is: ${counter}",
//                   style: TextStyle(fontSize: 20)),
//             ])));
//   }
// }

// --------------------------------------
// 4. The maximum displayed value is 60
// --------------------------------------
// class HomeScreenState extends State<HomeScreen> {
//   int counter = 50;
//   String errorMessage = "";

//   void increase() {
//     setState(() {
//       if (counter < 60) {
//         // if under the maximium: increase counter
//         counter = counter + 1;
//       } else {
//         // if maximum reached: update error message
//         errorMessage = "ERROR: Maximum reached.";
//       }
//     });
//   }

//   void reset() {
//     setState(() {
//       // reset counter
//       counter = 50;
//       // clear any error messages
//       errorMessage = "";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Button Demo"),
//         ),
//         body: Container(
//             padding: EdgeInsets.all(16),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               FilledButton(onPressed: increase, child: Text("Push Me")),
//               FilledButton(
//                   onPressed: reset, child: Text("Reset to initial value")),
//               Text("Current value is: ${counter}",
//                   style: TextStyle(fontSize: 20)),
//               Text("${errorMessage}",
//                   style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.pink,
//                       fontStyle: FontStyle.italic)),
//             ])));
//   }
// }

// --------------------------------------
// 5. Changing the font size
// --------------------------------------
// class HomeScreenState extends State<HomeScreen> {
//   double currFontSize = 20;

//   void increase() {
//     setState(() {
//       if (currFontSize < 80) {
//         currFontSize = currFontSize + 5.0;
//       }
//     });
//   }

//   void reset() {
//     setState(() {
//       currFontSize = 20;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Button Demo"),
//         ),
//         body: Container(
//             padding: EdgeInsets.all(16),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               FilledButton(onPressed: increase, child: Text("Push Me")),
//               FilledButton(
//                   onPressed: reset, child: Text("Reset to initial value")),
//               Text("Here is some text",
//                   style: TextStyle(fontSize: currFontSize)),
//             ])));
//   }
// }
