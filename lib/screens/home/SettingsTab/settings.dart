
/// The Settings widget shows the screen for the Settings tab.
/// Here, users can change their settings and log out

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/SettingsTab/account.dart';
import 'package:mobile_app/screens/home/SettingsTab/privacy_settings.dart';
import 'package:mobile_app/shared/constants.dart';

import '../../../shared/user_data.dart';
import 'about.dart';
import 'appearance.dart';
import 'friends.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

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

    void showPrivacyPage() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PrivacySettings())
      );
    }
    void showAboutPage() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AboutPage())
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
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    radius: 30.0,
                    backgroundImage: MemoryImage(UserData.profilePicture),
                  ) :
                  CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    radius: 30.0,
                    backgroundImage: const AssetImage("assets/images/DefaultProfile.jpg"),
                  ),
                  const SizedBox(width: 20.0),
                  Text(
                    UserData.username,
                    style: const TextStyle(
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
            child: ListTile(
              leading: Icon(
                color: Theme.of(context).iconTheme.color,
                CupertinoIcons.person,
              ),
              title: const Text("Account"),
              //subtitle: Text("Change your personal user data such as your username"),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              showAccountPage();
            },
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: ListTile(
              leading: Icon (
                color: Theme.of(context).iconTheme.color,
                CupertinoIcons.person_2
              ),
              title: const Text("Friends"),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              showFriendsPage();
            },
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: ListTile(
              leading: Icon(
                  color: Theme.of(context).iconTheme.color,
                  CupertinoIcons.lock
              ),
              title: const Text("Privacy"),
              //subtitle: Text("Change your personal user data such as your username"),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              showPrivacyPage();
            },
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: ListTile(
              leading: Icon(
                  color: Theme.of(context).iconTheme.color,
                  Icons.color_lens_outlined
              ),
              title: const Text("Appearance"),
              //subtitle: Text("Change your personal user data such as your username"),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              showAppearancePage();
            },
          ),
          TextButton(
            style: settingsTextButtonStyle,
            child: ListTile(
              leading: Icon(
                  color: Theme.of(context).iconTheme.color,
                  CupertinoIcons.info
              ),
              title: const Text("About CodeSlice"),
              //subtitle: Text("Change your personal user data such as your username"),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              showAboutPage();
            },
          ),
        ]
      ),
    );
  }
}
