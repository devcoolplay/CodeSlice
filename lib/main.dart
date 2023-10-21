
/// The starting point of this app.
/// Here we make sure to initialize everything before showing any content.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobile_app/screens/wrapper.dart';
import 'package:mobile_app/services/auth.dart';
import 'package:mobile_app/shared/app_data.dart';
import 'package:mobile_app/themes/light_theme.dart';
import 'package:mobile_app/themes/dark_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class SelectedFoldersProvider extends ChangeNotifier {
  List<String> selectedFolders = [];

  void toggleFolder(String name) {
    if (selectedFolders.contains(name)) {
      selectedFolders.remove(name);
    }
    else {
      selectedFolders.add(name);
    }
    notifyListeners(); // Notify listeners about the change
  }

  void unselectAllFolders() {
    selectedFolders.clear();
    notifyListeners(); // Notify listeners about the change
  }
}

class MySnippetsPathProvider extends ChangeNotifier {
  String path = "/";

  void setPath(String newPath) {
    path = newPath;
    AppData.mySnippetsPath = newPath;
    notifyListeners();
  }
}

class ThemeProvider extends ChangeNotifier {
  // TODO: Save theme the user selected
  ThemeMode selectedTheme = ThemeMode.system;

  void setTheme(String theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (theme == "dark") {
      selectedTheme = ThemeMode.dark;
      AppData.darkMode = true;
      prefs.setBool("dark_mode", true);
    }
    else if (theme == "light") {
      selectedTheme = ThemeMode.light;
      AppData.darkMode = false;
      prefs.setBool("dark_mode", false);
    }
    else {
      selectedTheme = ThemeMode.system;
    }
    notifyListeners();
  }

  void getMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("dark_mode") != null) {
      selectedTheme = prefs.getBool("dark_mode")! ? ThemeMode.dark : ThemeMode.light;
      if (selectedTheme == ThemeMode.dark) {
        AppData.darkMode = true;
      }
      else {
        AppData.darkMode = false;
      }
    }
    else {
      if (SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark) {
        prefs.setBool("dark_mode", true);
        AppData.darkMode = true;
      }
      else {
        prefs.setBool("dark_mode", false);
        AppData.darkMode = false;
      }
    }
    notifyListeners();
  }

  ThemeProvider() {
    getMode();
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SelectedSnippetsProvider()),
        ChangeNotifierProvider(create: (context) => SelectedFoldersProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MySnippetsPathProvider())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
        themeMode: themeProvider.selectedTheme,
        home: const Wrapper(),
      ),
    );
  }
}
