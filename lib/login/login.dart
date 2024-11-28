import 'package:flutter/material.dart';
import 'package:food_tracker_app/viewmodel/homepage_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/home_page_view.dart';
import 'signup.dart';
import 'forgot_password.dart';
import '../service/firestore_service.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hot Dog Food Tracking Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurpleAccent,
          brightness: Brightness.dark,
        ),
        primarySwatch: Colors.blue,
        unselectedWidgetColor: Colors.red,
      ),
      home: const MyLoginPage(title: 'Login Page'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key, required this.title});

  final String title;

  @override
  State<MyLoginPage> createState() => _MyLoginPage();
}

class _MyLoginPage extends State<MyLoginPage> {
  List<Map<String, String>> _users = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  String _loginStatus = '';
  FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final users = await firestoreService.getUsersFromFirestore();
    setState(() {
      _users = users;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool _validateUser(String username, String password) {
    for (var user in _users) {
      if (user['username'] == username && user['password'] == password) {
        return true;
      }
    }
    return false;
  }

  void _handleSubmitted(String value) {
    _login();
  }

  void _login() async {
    if (_validateUser(_usernameController.text, _passwordController.text)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', _usernameController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  username: _usernameController.text,
                  title: '',
                  viewModel: Provider.of<HomePageViewModel>(context),
                )),
      );
    } else {
      setState(() {
        _loginStatus = 'Incorrect username or password';
      });
    }
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const LoginApp(title: 'Login Page')),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Food Tracking',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ClipRRect(
                child: Image.asset('assets/images/team-hot-dog-logo.png',
                    height: 180),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onFieldSubmitted: (term) {
                  _fieldFocusChange(
                      context, FocusScope.of(context), _passwordFocusNode);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                onFieldSubmitted: _handleSubmitted,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              Text(
                _loginStatus,
                style: TextStyle(
                    color: _loginStatus == 'You have been logged in'
                        ? Colors.green
                        : Colors.red),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage()),
                  );
                },
                child: const Text('Forgot Password?'),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              const Text('Don\'t have an account?'),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
