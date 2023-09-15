
/// The Wrapper widget desides whether to show the home screen or the authentication screens

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // Return either home or authentication page
    if (user == null) {
      return Authenticate();
    }
    else {
      return Home();
    }
  }
}
