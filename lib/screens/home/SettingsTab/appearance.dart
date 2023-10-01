import 'package:flutter/material.dart';
import 'package:mobile_app/shared/app_data.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text("Dark Mode"),
            trailing: Switch(
              onChanged: (val) {
                setState(() {
                  AppData.darkMode = val;
                  if(AppData.darkMode) {
                    themeProvider.setTheme("dark");
                  } else {
                    themeProvider.setTheme("light");
                  }
                });
              },
              value: AppData.darkMode,
            ),
          )
        ],
      ),
    );
  }
}
