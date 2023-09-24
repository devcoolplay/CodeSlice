
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/services/auth.dart';
import 'package:mobile_app/services/social.dart';
import 'package:mobile_app/shared/constants.dart';
import 'package:mobile_app/shared/profile_picture.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key, required this.appBarTitle, required this.userId, required this.username, required this.isFriend});

  final String appBarTitle;
  final String userId;
  final String username;
  bool isFriend;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _auth = AuthService();

  late final SocialService _social = SocialService(uuid: _auth.userId);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfilePicture(userId: widget.userId, size: 50.0),
                ],
              ),
              const SizedBox(height: 30.0),
              ListTile(
                leading: const Icon(CupertinoIcons.person),
                title: const Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey
                  ),
                ),
                subtitle: TextField(
                  decoration: settingsInputDecoration,
                  enabled: false,
                  controller: TextEditingController(text: widget.username),
                ),
              ),
              FutureBuilder<String>(
                future: _social.getUserInfo(widget.userId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return const SpinKitThreeBounce(color: Colors.grey, size: 20);
                    default:
                      if (snapshot.hasError) {
                        return const Text("Error while trying to fetch bio");
                      }
                      return ListTile(
                        leading: const Icon(CupertinoIcons.info),
                        title: const Text(
                          "Bio",
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey
                          ),
                        ),
                        subtitle: TextField(
                          decoration: settingsInputDecoration,
                          enabled: false,
                          maxLines: 5,
                          controller: TextEditingController(text: snapshot.data!),
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: !widget.isFriend ?
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primarySwatchColor,
          ),
            onPressed: () {
              _social.sendFriendRequest(friendUsername: widget.username);
              Fluttertoast.showToast(
                msg: "Request sent!",
                webBgColor: "linear-gradient(to right, #0c18fb, #0c18fb)",
              );
            },
            child: const Text("Send Friend Request")
        ),
      ) :
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
        child: ElevatedButton(
          onPressed: () {
            showUnfriendDialog();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text("Unfriend")
        ),
      ),
    );
  }

  Future showUnfriendDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.only(top: 40.0, bottom: 20.0, left: 20.0, right: 20.0),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      content: const Text(
        "Are you sure you want to remove this user from your friends list?",
        textAlign: TextAlign.center,
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _social.removeFriend(friendId: widget.userId);
            setState(() {
              widget.isFriend = false;
            });
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text("Yes, unfriend"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[600],
          ),
          child: const Text("Cancel"),
        ),
      ],
    ),
  );
}
