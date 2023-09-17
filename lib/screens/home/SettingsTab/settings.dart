
/// The Settings widget shows the screen for the Settings tab.
/// Here, users can change their settings and log out

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/SettingsTab/account.dart';
import 'package:mobile_app/shared/constants.dart';

import '../../../services/auth.dart';
import '../../../shared/user_data.dart';
import 'blablub.dart';
import 'friends.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void showAccountPage() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Account())
      ).then((_) => setState(() {}));
    }

    void showFriendsPage() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const Friends())
      );
    }

    void showAppearancePage() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AppearanceSettings())
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            child: Container(
              padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
              decoration: settingsContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 20.0),
                  UserData.profilePicture != null ?
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30.0,
                    backgroundImage: MemoryImage(UserData.profilePicture),
                  ) :
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30.0,
                    backgroundImage: AssetImage("assets/images/DefaultProfile.jpg"),
                  ),
                  const SizedBox(width: 20.0),
                  Text(
                    UserData.username,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: const ListTile(
              leading: Icon(CupertinoIcons.person),
              title: Text("Account"),
              //subtitle: Text("Change your personal user data such as your username"),
              trailing: Icon(Icons.chevron_right),
            ),
            onPressed: () {
              showAccountPage();
            },
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: const ListTile(
              leading: Icon (CupertinoIcons.person_2),
              title: Text("Friends"),
              trailing: Icon(Icons.chevron_right),
            ),
            onPressed: () {
              showFriendsPage();
            },
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: const ListTile(
              leading: Icon(CupertinoIcons.lock),
              title: Text("Privacy"),
              //subtitle: Text("Change your personal user data such as your username"),
              trailing: Icon(Icons.chevron_right),
            ),
            onPressed: () {

            },
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: const ListTile(
              leading: Icon(Icons.color_lens_outlined),
              title: Text("blablub"),
              //subtitle: Text("Change your personal user data such as your username"),
              trailing: Icon(Icons.chevron_right),
            ),
            onPressed: () {
              showAppearancePage();
            },
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: const ListTile(
              leading: Icon(CupertinoIcons.info),
              title: Text("About CodeSlice"),
              //subtitle: Text("Change your personal user data such as your username"),
              trailing: Icon(Icons.chevron_right),
            ),
            onPressed: () {

            },
          ),
        ]
      ),
    );
  }
}
