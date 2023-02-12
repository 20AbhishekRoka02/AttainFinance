import 'package:flutter/material.dart';
import '../../../core/common/singInButton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 10),
          const Column(
            children: [
              Text(
                "AttainFinance",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 34),
              ),
              SizedBox(height: 10),
              CircleAvatar(
                radius: 40,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "'Track Save Grow'",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          SignInButton(),
        ],
      ),
    );
  }
}
