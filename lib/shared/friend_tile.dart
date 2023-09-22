
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/services/social.dart';
import 'package:mobile_app/shared/profile_picture.dart';
import 'package:mobile_app/shared/user_data.dart';
import 'package:mobile_app/shared/user_profile.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/snippet.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../services/notification.dart';

class FriendTile extends StatelessWidget {
  FriendTile({super.key, required this.id, required this.isShareMenu});

  final String id;
  final bool isShareMenu;

  final AuthService _auth = AuthService();
  late final DatabaseService _db = DatabaseService(uuid: _auth.userId);
  late final SocialService _social = SocialService(uuid: _auth.userId);

  Future<String> _getName() async {
    return await _db.getNameById(id);
  }

  @override
  Widget build(BuildContext context) {

    final selectedSnippetsProvider = Provider.of<SelectedSnippetsProvider>(context);

    void showProfilePage(String username) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => UserProfile(appBarTitle: "User Profile", userId: id, username: username, isFriend: true))
      );
    }

    return FutureBuilder<String>(
      future: _getName(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return const SizedBox(height: 30.0);
          default:
            if (snapshot.hasError) {
              return const Text("Error while loading names of friends");
            }
            else {
              return GestureDetector(
                child: ListTile(
                  //leading: ProfilePicture(userId: id, size: 10.0),
                  title: Text(
                    snapshot.data!,
                    style: const TextStyle(
                      fontSize: 18.0
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right)
                ),
                onTap: () async {
                  if (!isShareMenu) {
                    showProfilePage(snapshot.data!);
                  }
                  else {
                    for (String snippetId in selectedSnippetsProvider.selectedSnippets) {
                      Snippet snippet = await _db.getSnippetById(snippetId);
                      _social.shareSnippet(userId: id, snippet: snippet);
                    }
                    Fluttertoast.showToast(
                      msg: "Shared!",
                      webBgColor: "linear-gradient(to right, #0c18fb, #0c18fb)",
                    );
                    selectedSnippetsProvider.unselectAllSnippets();
                    Navigator.of(context).pop();
                  }
                },
              );
            }
        }
      },
    );
  }
}
