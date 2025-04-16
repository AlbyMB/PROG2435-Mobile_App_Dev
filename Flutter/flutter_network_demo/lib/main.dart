import "package:flutter/material.dart";
// imports for working with the API response
import "package:http/http.dart" as http;
import "package:http/http.dart";
import "dart:convert";

// Create a custom class
// Normally, you would place this in a separate file
// But for simplicity it is included in the main.dart file.
class Quote {
  Quote({
    required this.author,
    required this.quote,
  });

  final String author;
  final String quote;

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      author: json["author"] ?? "",
      quote: json["quote"] ?? "",
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  // displays a message in a Text()
  String output = "output goes here";
  List<Quote> listItems = [];

  Future<void> getData() async {
    // define the API endpoint
    String URL = "https://qapi.vercel.app/api/quotes";

    // connect to the endpoint
    Response responseFromAPI = await http.get(Uri.parse(URL));

    // Assuming the response from the API is successful:
    // Get the data out of the response
    dynamic response = jsonDecode(responseFromAPI.body);

    List<Quote> quotes = [];
    for (dynamic item in response) {
      Quote q = Quote.fromJson(item);
      quotes.add(q);
    }


    // output data to screen
    setState(() {
      output = "Number of quotes: ${quotes.length}\n\n";
      listItems.clear();
      listItems.addAll(quotes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Demo"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FilledButton(onPressed: getData, child: Text("Get API Data")),
          Expanded(child: ListView.builder(itemCount: listItems.length , itemBuilder: (context, index) {
            return ListTile(
              title: Text(listItems[index].quote),
              subtitle: Text(listItems[index].author),
            );
          })),
        ],
      ),
    );
  }
}
