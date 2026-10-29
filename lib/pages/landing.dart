import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final String username;
  final String password;
  const LandingPage({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rosalada_Task 6')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Landing Page!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Username: $username', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Password: $password', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Clear the stack so Back cannot return to the dashboard.
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
