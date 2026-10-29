import 'package:flutter/material.dart';

import '../user_store.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _civilStatusController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  static const List<String> _allowedGenders = ['Male', 'Female', 'Other'];
  static const List<String> _allowedCivilStatuses = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _genderController.dispose();
    _civilStatusController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  // Validations

  String? _validateFullname(String? value) {
    final String fullname = value?.trim() ?? '';
    if (fullname.isEmpty) {
      return 'Full name is required.';
    }
    if (fullname.length < 2) {
      return 'Full name must be at least 2 characters long.';
    }
    if (!RegExp(r"^[a-zA-Z .'-]+$").hasMatch(fullname)) {
      return 'Full name can only contain letters, spaces, dots, apostrophes and hyphens.';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    final String username = value?.trim() ?? '';
    if (username.isEmpty) {
      return 'Username is required.';
    }
    if (username.length < 4) {
      return 'Username must be at least 4 characters long.';
    }
    if (username.contains(' ')) {
      return 'Username must not contain spaces.';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Username can only contain letters, numbers and underscores.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';
    if (password.isEmpty) {
      return 'Password is required.';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return 'Password must contain at least one letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final String confirmPassword = value ?? '';
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password.';
    }
    if (confirmPassword != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  String? _validateGender(String? value) {
    final String gender = value?.trim() ?? '';
    if (gender.isEmpty) {
      return 'Gender is required.';
    }
    final bool isValid = _allowedGenders.any(
      (allowed) => allowed.toLowerCase() == gender.toLowerCase(),
    );
    if (!isValid) {
      return 'Gender must be one of: ${_allowedGenders.join(', ')}.';
    }
    return null;
  }

  String? _validateCivilStatus(String? value) {
    final String civilStatus = value?.trim() ?? '';
    if (civilStatus.isEmpty) {
      return 'Civil status is required.';
    }
    final bool isValid = _allowedCivilStatuses.any(
      (allowed) => allowed.toLowerCase() == civilStatus.toLowerCase(),
    );
    if (!isValid) {
      return 'Civil status must be one of: ${_allowedCivilStatuses.join(', ')}.';
    }
    return null;
  }

  String? _validateBirthday(String? value) {
    final String birthday = value?.trim() ?? '';
    if (birthday.isEmpty) {
      return 'Birthday is required.';
    }
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(birthday) ||
        DateTime.tryParse(birthday) == null) {
      return 'Birthday must be a valid date in YYYY-MM-DD format.';
    }
    if (DateTime.parse(birthday).isAfter(DateTime.now())) {
      return 'Birthday cannot be in the future.';
    }
    return null;
  }

  // Submit

  void _register() {
    // Run every rule so the dialog lists ALL problems, not just the first one.
    final List<String> errors = [
      _validateFullname(_fullnameController.text),
      _validateUsername(_usernameController.text),
      _validatePassword(_passwordController.text),
      _validateConfirmPassword(_confirmPasswordController.text),
      _validateGender(_genderController.text),
      _validateCivilStatus(_civilStatusController.text),
      _validateBirthday(_birthdayController.text),
    ].whereType<String>().toList();

    if (errors.isNotEmpty) {
      _showErrorDialog(errors);
      return;
    }

    // Prevent duplicate accounts.
    final String username = _usernameController.text.trim();
    if (UserStore.usernameExists(username)) {
      _showErrorDialog([
        'Username "$username" is already taken. Please choose another.',
      ]);
      return;
    }

    UserStore.addUser(username: username, password: _passwordController.text);

    _showSuccessDialog();
  }

  // Error and success dialogs

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
              Text('Validation Error'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please fix the following:'),
                const SizedBox(height: 8),
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

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: const Text(
            'Account registered successfully! Please log in.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close the dialog
                Navigator.of(context).pop(); // return to the login page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(icon),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _fullnameController,
                keyboardType: TextInputType.name,
                decoration: _inputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  icon: Icons.badge,
                ),
                validator: _validateFullname,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                decoration: _inputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  icon: Icons.person,
                ),
                validator: _validateUsername,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration(
                  labelText: 'Password',
                  hintText: 'Min. 8 chars, 1 letter, 1 number',
                  icon: Icons.lock,
                ),
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: _inputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  icon: Icons.lock_outline,
                ),
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genderController,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration(
                  labelText: 'Gender',
                  hintText: 'Male / Female / Other',
                  icon: Icons.transgender,
                ),
                validator: _validateGender,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _civilStatusController,
                textCapitalization: TextCapitalization.words,
                decoration: _inputDecoration(
                  labelText: 'Civil Status',
                  hintText: 'Single / Married / Divorced / Widowed',
                  icon: Icons.favorite_border,
                ),
                validator: _validateCivilStatus,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthdayController,
                readOnly: true,
                decoration: _inputDecoration(
                  labelText: 'Birthday',
                  hintText: 'YYYY-MM-DD',
                  icon: Icons.cake,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickBirthday,
                  ),
                ),
                onTap: _pickBirthday,
                validator: _validateBirthday,
              ),
              const SizedBox(height: 32),
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
      ),
    );
  }
}
