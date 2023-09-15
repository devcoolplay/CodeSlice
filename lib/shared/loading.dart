
/// The loading widget shows a loading animation.

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: const Center(
        child: SpinKitThreeBounce(
          color: Colors.grey,
          size: 20.0,
        ),
      ),
    );
  }
}
