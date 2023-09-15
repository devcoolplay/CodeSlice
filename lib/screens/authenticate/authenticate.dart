
/// The Authenticate widget either shows the login or registration page.
/// Default: Register
/// Set default by changing _showSignIn

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/authenticate/sign_in.dart';
import 'package:mobile_app/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool _showSignIn = true;
  void toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _showSignIn ? SignIn(toggleViewFunction: toggleView) : Register(toggleViewFunction: toggleView),
    );
  }
}
