import 'package:doctor_robo/ui/widgets/option.dart';
import 'package:flutter/material.dart';

class LoginRegisterView extends StatelessWidget {
  final String loginText;
  final String registerText;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  const LoginRegisterView({
    Key? key,
    required this.onLogin,
    required this.onRegister,
    required this.loginText,
    required this.registerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Option(
            name: loginText,
            onTap: onLogin,
            file: 'assets/lottie/login.json',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Option(
            name: registerText,
            onTap: onRegister,
            file: 'assets/lottie/register.json',
          ),
        ),
      ],
    );
  }
}
