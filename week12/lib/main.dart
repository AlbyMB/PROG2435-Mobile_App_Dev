import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();
  bool isGraduating = false;
  String results = "Results go here";

  @override
  void dispose() {
    nameController.dispose();
    gpaController.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    String name = nameController.text;
    double gpa = double.parse(gpaController.text);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('NAME', name);
    await prefs.setDouble('GPA', gpa);
    await prefs.setBool('IS_GRADUATING', isGraduating);
    setState(() {
      results = "Data saved successfully";
    });
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('NAME') ?? "No Name";
    double gpa = prefs.getDouble('GPA') ?? 0.0;
    bool isGraduating = prefs.getBool('IS_GRADUATING') ?? false;
    setState(() {
      nameController.text = name;
      gpaController.text = gpa.toString();
      this.isGraduating = isGraduating;
      results = "Data loaded successfully";
    });
  }

  Future<void> deleteData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      nameController.text = "";
      gpaController.text = "";
      isGraduating = false;
      results = "Data deleted successfully";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(children: [
        FilledButton(onPressed: () {deleteData();}, child: Text("Delete all data")),
        FilledButton(onPressed: () {
          loadData();
        }, child: Text("Load data")),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter Student Name'),
        ),
        TextField(
          controller: gpaController,
          decoration: const InputDecoration(hintText: 'Enter Student GPA'),
        ),
        SwitchListTile(
            value: isGraduating,
            onChanged: (bool value) {
              setState(() {
                isGraduating = value;
              });
            },
            title: Text("Is Student Graduating?")),
        FilledButton(
            onPressed: () {
              saveData();
            },
            child: Text("Save Data")),
        Text(results)
      ]),
    );
  }
}
