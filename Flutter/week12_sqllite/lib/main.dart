import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Screen1(),
    );
  }
}

class Screen1 extends StatelessWidget {
  Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("This is Screen 1"),
      ),
      body: Center(
        // when the button is pressed, navigate to Screen2
        child: FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                List<String> namesList = ["Amara", "Lakmishi", "William"];
                return Screen2(price:3.99, isRaining:true, friends:namesList);
              }),
            );
          },
          child: Text("Go to next screen"),
        ),
      ),
    );
  }
}

// code for Screen 2
class Screen2 extends StatelessWidget {
  // a. create a class property
  double price;
  bool isRaining;
  List<String> friends;

  // b. update the constructor to set the value of the "price" class property
  Screen2({super.key, required this.price, required this.isRaining, required this.friends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("This is Screen 2"),
        ),
        body: Center(child:
        Column(
            children:[
              Text("Welcome to Screen 2!", style:TextStyle(fontSize: 20)),
              Text("Price is: ${this.price}", style:TextStyle(fontSize: 20)),
              Text("Is it raining?: ${this.isRaining}", style:TextStyle(fontSize: 20)),
              Text("Friends: ${this.friends.toString()}", style:TextStyle(fontSize: 20)),
              // when button pressed, go back to previous screen
              FilledButton(onPressed:() {
                Navigator.pop(context);
              }, child:Text("Go back"))
            ]
        ),
        )
    );
  }
}



