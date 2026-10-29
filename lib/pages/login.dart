import 'package:flutter/material.dart';

import '../user_store.dart';
import 'landing.dart';
import 'register.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // 1. Check for empty fields first.
    final List<String> errors = [
      if (_usernameController.text.trim().isEmpty) 'Username is required.',
      if (_passwordController.text.isEmpty) 'Password is required.',
    ];
    if (errors.isNotEmpty) {
      _showErrorDialog(errors);
      return;
    }

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text;

    // 2. Check if the user exists.
    if (!UserStore.usernameExists(username)) {
      _showErrorDialog([
        'User "$username" does not exist. Please register first.',
      ]);
      return;
    }

    // 3. Check if the password matches.
    if (!UserStore.validateCredentials(
      username: username,
      password: password,
    )) {
      _showErrorDialog(['Incorrect password. Please try again.']);
      return;
    }

    // 4. Credentials are valid — proceed.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LandingPage(username: username, password: password),
      ),
    );
  }

  void _showErrorDialog(List<String> errors) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 8),
              Text('Login Failed'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...errors.map(
                (error) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('\u2022 '),
                      Expanded(child: Text(error)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Rosalada_Task 6')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _login,
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _register,
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.blue),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
