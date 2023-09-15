
/// The starting point of this app.
/// Here we make sure to initialize everything before showing any content.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_app/screens/wrapper.dart';
import 'package:mobile_app/services/auth.dart';
import 'package:mobile_app/themes/light_theme.dart';
import 'package:mobile_app/themes/dark_theme.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Create a ChangeNotifier to hold the selected snippets list
class SelectedSnippetsProvider extends ChangeNotifier {
  List<String> selectedSnippets= [];

  void toggleSnippet(String id) {
    if (selectedSnippets.contains(id)) {
      selectedSnippets.remove(id);
    }
    else {
      selectedSnippets.add(id);
    }
    notifyListeners(); // Notify listeners about the change
  }

  void unselectAllSnippets() {
    selectedSnippets.clear();
    notifyListeners(); // Notify listeners about the change
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => SelectedSnippetsProvider(),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CodeSlice',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const Wrapper(),
      ),
    );
  }
}
