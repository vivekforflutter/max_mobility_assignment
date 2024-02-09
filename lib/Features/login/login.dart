import 'package:flutter/material.dart';
import 'package:max_assignment/Features/customer/presentation/customer_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String userIdErrorText = '';
  String passwordErrorText = '';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(
                labelText: 'User ID',
                errorText: userIdErrorText,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: passwordErrorText,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                validateLogin();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),

    );
  }
  void validateLogin() {
    String validUserId = 'user@maxmobility.in';
    String validPassword = 'Abc@#123';

    setState(() {
      userIdErrorText = '';
      passwordErrorText = '';

      if (userIdController.text != validUserId) {
        userIdErrorText = 'Invalid User ID';
      }

      if (passwordController.text != validPassword) {
        passwordErrorText = 'Invalid Password';
      }

      if (userIdErrorText.isEmpty && passwordErrorText.isEmpty) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CustomerScreen()));
        print('Login Successful!');
      }
    });
  }
}
