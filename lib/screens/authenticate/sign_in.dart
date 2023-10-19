
/// The SignIn widget shows a log in form.
/// The user can enter an email address with the corresponding password.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mobile_app/shared/constants.dart';

import '../../services/auth.dart';
import '../../shared/loading.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.toggleViewFunction});

  final Function toggleViewFunction;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Text field state
  String _email = "";
  String _password = "";
  String _error = "";

  late StreamSubscription<bool> _keyboardSubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    _keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading ? const Loading() : Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: _isKeyboardVisible ? const ClampingScrollPhysics() : const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 55.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: const Image(
                    image: AssetImage("assets/images/AppIcon_7.png"),
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                const SizedBox(height: 50.0),
                Text(
                  "Welcome back to CodeSlice!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  decoration: authInputDecoration.copyWith(hintText: "Email"),
                  validator: (value) => value!.isEmpty ? "Enter an Email" : null,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: authInputDecoration.copyWith(hintText: "Password"),
                  validator: (value) => value!.isEmpty ? "Enter a Password" : null,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  onFieldSubmitted: (val) async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _loading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPass(_email, _password);
                      if (result == null) {
                        setState(() {
                          _loading = false;
                          _error = "Email or Password incorrect";
                        });
                      }
                    }
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {},
                    )
                  ],
                ),
                const SizedBox(height: 30.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 13.0),
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          dynamic result = await _auth.signInWithEmailAndPass(_email, _password);
                          if (result == null) {
                            setState(() {
                              _loading = false;
                              _error = "Email or Password incorrect";
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  _error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Divider(thickness: 1.0),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: const Text(
                  "Don't have an Account yet? Register Now",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              onTap: () {
                widget.toggleViewFunction();
              },
            ),
          ],
        )
      ),
    );
  }
}
