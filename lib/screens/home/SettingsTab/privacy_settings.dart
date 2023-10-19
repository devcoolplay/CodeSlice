import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
              leading: const Icon(CupertinoIcons.smiley),
              title: const Text("You have no Privacy.")
          ),
        ],
      ),
    );
  }
}
