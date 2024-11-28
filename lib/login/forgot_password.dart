import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _usernameController = TextEditingController();
  String _passwordStatus = '';

  void _retrievePassword() async {
    final String username = _usernameController.text;

    if (username.isEmpty) {
      setState(() {
        _passwordStatus = 'Please enter a username';
      });
      return;
    }

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(username)
        .get();

    if (userDoc.exists) {
      setState(() {
        _passwordStatus = 'Password: ${userDoc['Password']}';
      });
    } else {
      setState(() {
        _passwordStatus = 'User does not exist';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              Image.asset('assets/images/team-hot-dog-logo.png', height: 100),
              const SizedBox(height: 40),
              const Text(
                'Retrieve Your Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _retrievePassword,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Retrieve Password'),
              ),
              const SizedBox(height: 20),
              Text(
                _passwordStatus,
                style: const TextStyle(color: Colors.blue, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
