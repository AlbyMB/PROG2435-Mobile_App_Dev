import 'dart:convert';
import 'package:albyb_final_project/database/category_repository.dart';
import 'package:albyb_final_project/database/food_repository.dart';
import 'package:albyb_final_project/database/user_repository.dart';
import 'package:albyb_final_project/models/category_model.dart';
import 'package:albyb_final_project/models/food_model.dart';
import 'package:albyb_final_project/models/user_model.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import "package:http/http.dart" as http;
import "package:http/http.dart";

void main() {
  databaseFactory = databaseFactoryFfiWeb;
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginCheck(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        FoodsPage.routeName: (context) => FoodsPage(),
        ShoppingScreen.routeName: (context) => ShoppingScreen(),
        SettingsPage.routeName: (context) => SettingsPage(),
        HomeScreen.routeName: (context) => HomeScreen(),
        AddFood.routeName: (context) => AddFood(),
        BarcodePage.routeName: (context) => BarcodePage(),

      }
    );
  } 
}

class LoginCheck extends StatefulWidget {
  const LoginCheck({super.key});

  @override
  State<LoginCheck> createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    List<User> loggedInUser = await UserRepository().getLoggedInUser();
    if (loggedInUser.isNotEmpty) {
      print("Logged IN");
      Navigator.pushReplacementNamed(context, FoodsPage.routeName);
    } else {
      print("NOT LOGGED IN");
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
    Future.delayed(const Duration(seconds: 1), () {
      FlutterNativeSplash.remove();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for email and password fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {

    final prefs = await SharedPreferences.getInstance();

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final user = await UserRepository().getUserByEmail(email);
      if (user.isNotEmpty) {
        
        if (user[0].password == password) {
          user[0].isLoggedIn = 'true';
          await UserRepository().updateUser(user[0], user[0].id!);
        } else {
          // Show a SnackBar or dialog for invalid credentials.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password')),
          );
        }
      } else {
        // Show a SnackBar or dialog for invalid credentials.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }

      
      if (user.isNotEmpty && user[0].isLoggedIn == 'true') {
        prefs.setString('userID', user[0].id.toString());
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constrain the width so that text fields don't span the whole screen.
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 320, // Adjust width as needed to mimic normal app inputs.
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Email input field.
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      // Simple email regex validation.
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password input field.
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Login button.
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  // Link to registration page.
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterPage.routeName);
                    },
                    child: const Text('Don\'t have an account? Register here'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static const String routeName = '/register';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for registration inputs.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // A simple function to check password complexity.
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // Require a minimum of 8 characters, at least one uppercase, one lowercase and one digit.
    // Adjust the regex pattern based on your complexity requirements.
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(value)) {
      return 'Password must be at least 8 characters, include upper and lower case letters and a number';
    }
    return null;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      // Check if the password and confirmation match.
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      // Create a new user model (modify to match your User model requirements).
      final user = User(
        email: email,
        password: password,
        createdAt: DateTime.now().toString(),
      );

      // Insert user into your database.
      final result = await UserRepository().insertUser(user);
      if (result != 0) { 
        final newUser = await UserRepository().getUserByEmail(email);

        CategoryRepository().insertCategory(Category(
          name: 'Fridge',
          userId: newUser[0].id!,
        ));

        CategoryRepository().insertCategory(Category(
          name: 'Freezer',
          userId: newUser[0].id!,
        ));

        CategoryRepository().insertCategory(Category(
          name: 'Pantry',
          userId: newUser[0].id!,
        ));
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful! Please log in.')),
        );
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed, please try again')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constrain the width similar to LoginPage.
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email input.
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password input.
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  // Confirm password input.
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Register button.
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 10),
                  // Optionally, a link to go back to login.
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, LoginPage.routeName);
                    },
                    child: const Text('Already have an account? Login here'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// MainScreen with bottom navigation.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const FoodsPage(),
    const ShoppingScreen(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Foods',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shopping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// FoodsPage with list, search/filter option, and floating action button.
class FoodsPage extends StatefulWidget {
  const FoodsPage({super.key});

  static const String routeName = '/foods';

  @override
  State<FoodsPage> createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {

  List<Food> _foods = [];
  List<Category> _categories = [];
  
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final prefs = await SharedPreferences.getInstance();

    String? userID = prefs.getString('userID');

    List<Food> foods = await FoodRepository().getAllFoods(int.parse(userID!));
    List<Category> categories = await CategoryRepository().getAllCategories(int.parse(userID!));

    setState(() {
      _foods = foods; // Update the state to reflect the fetched foods.
      _categories = categories; // Update the state to reflect the fetched categories.
    });

    
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Foods'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              debugPrint('Search or filter by category tapped');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _foods.length,
        itemBuilder: (context, index) {
          final food = _foods[index];
          final category = _categories.firstWhere(
            (category) => category.id == food.categoryId,
            orElse: () => Category(id: 0, name: 'Unknown', userId: 0), // Fallback if no category is found.
          );
          return ListTile(
            leading: food.imageUrl != null && food.imageUrl!.isNotEmpty
          ? Image.network(
              food.imageUrl!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.fastfood, size: 50, color: Colors.grey);
              },
            )
          : const Icon(Icons.fastfood, size: 50, color: Colors.grey), 
            title: Text(food.name), // Display the food's name as the title.
            subtitle: Text(
              '${category.name} \nQuantity: ${food.quantity ?? 'N/A'} ${food.unit ?? ''}', // Display category and quantity in smaller font.
              style: const TextStyle(fontSize: 14, color: Colors.grey), // Optional styling for subtitle.
            ),
            onTap: () {
              // Open food item details or edit options.
              debugPrint('Tapped on ${food.name}');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.pushNamed(context, AddFood.routeName);
          _initialize();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ShoppingScreen placeholder.
class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  static const String routeName = '/shopping';

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Shopping List'),
      ),
      body: const Center(
        child: Text('Your shopping list items will appear here'),
      ),
    );
  }
}

// SettingsPage placeholder.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings options go here'),
      ),
    );
  }
}

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  static const String routeName = '/addFood';

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields.
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Sample list of categories. Replace or extend as necessary.
  List<Category> _categories = [];
  String? _selectedCategoryId;

  // List of units.
  final List<String> _units = ['g', 'ml', 'kg', 'L', 'no.'];
  String? _selectedUnit;

  String? _userID;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final prefs = await SharedPreferences.getInstance();

    _userID = prefs.getString('userID');

    if (_userID != null) {
      final categories = await CategoryRepository().getAllCategories(int.parse(_userID!));
      setState(() {
        _categories = categories;
        if (_categories.isNotEmpty) {
          _selectedCategoryId = _categories.first.id.toString(); // Default to the first category.
        }
        _selectedUnit = _units.first; // Default to the first unit.
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed.
    _foodNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addFood() {
    if (_formKey.currentState!.validate()) {

      final foodName = _foodNameController.text.trim();
      final description = _descriptionController.text.trim();
      final quantityText = _quantityController.text.trim();
      final quantity = quantityText.isNotEmpty ? double.tryParse(quantityText) : null;
      final category = _selectedCategoryId;
      final unit = _selectedUnit;
      final createdAt = DateTime.now().toString();
      final updatedAt = DateTime.now().toString();
      final userId = _userID;

      Food newFood = Food(
        name: foodName,
        description: description,
        quantity: quantity,
        unit: unit,
        categoryId: int.parse(category!),
        createdAt: createdAt,
        updatedAt: updatedAt,
        userId: int.parse(userId!),
      );

      FoodRepository().insertFood(newFood);


      // Optionally, clear form or navigate away:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food item added successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Food name input. Required field.
              TextFormField(
                controller: _foodNameController,
                decoration: const InputDecoration(
                  labelText: 'Food Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Food name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Category dropdown.
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id.toString(),
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    _selectedCategoryId = newVal;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Optional description input.
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Row for quantity input and unit dropdown.
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      items: _units.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _selectedUnit = newVal;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Button to add new food item.
              ElevatedButton(
                onPressed: _addFood,
                child: const Text('Add Food'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, BarcodePage.routeName);
                },
                child: const Text('Have a barcode instead?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class BarcodePage extends StatelessWidget {
  const BarcodePage({super.key});

  static const String routeName = '/barcode';

  Future<dynamic> fetchData(String barcode) async{
    String URL = "https://world.openfoodfacts.org/api/v3/product/$barcode.json";
    Response responseFromAPI = await http.get(Uri.parse(URL));

    dynamic response = jsonDecode(responseFromAPI.body);
    print(response["product"]["product_name"]);

    return response;

  }

  Future<Food> createFood(dynamic response, context) async{
    int loggedInUserId=0;
    final prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    if (userID != null) {
      loggedInUserId = int.parse(userID);}
    
    Food newFood = Food(
      name: response["product"]["product_name"],
      categoryId: 1,
      userId: loggedInUserId,
      imageUrl: response["product"]["selected_images"]["front"]["thumb"]["en"],
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      description: response["product"]["ingredients_text_en"],
      quantity: double.tryParse(response["product"]["serving_quantity"]),
      unit: response["product"]["serving_quantity_unit"],
    );

    FoodRepository().insertFood(newFood);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food item added successfully!')),
      );
    return newFood;

  }
  @override
  Widget build(BuildContext context) {
    final TextEditingController _barcodeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Enter Barcode')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _barcodeController,
              decoration: const InputDecoration(
                labelText: 'Enter Barcode',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final barcode = _barcodeController.text.trim();
                if (barcode.isNotEmpty) {
                  dynamic response = fetchData(barcode);
                  response.then((value) {
                    if (value["result"]["name"]== 'Product found') {
                      createFood(value, context);
                      
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid barcode')),
                      );
                    }
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a barcode')),
                  );
                }
              },
              child: const Text('Submit Barcode'),
            ),
          ],
        ),
      ),
    );
  }
}