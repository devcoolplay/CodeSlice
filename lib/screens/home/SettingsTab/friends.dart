
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/screens/home/SettingsTab/friend_request_tile.dart';
import 'package:mobile_app/screens/home/SettingsTab/friend_requests_list.dart';
import 'package:mobile_app/services/database.dart';
import 'package:mobile_app/services/notification.dart';
import 'package:mobile_app/shared/friend_tile.dart';
import 'package:mobile_app/services/social.dart';
import 'package:mobile_app/shared/constants.dart';
import 'package:provider/provider.dart';

import '../../../services/auth.dart';
import '../../../shared/user_data.dart';
import '../../../shared/friends_list.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final AuthService _auth = AuthService();
  late final SocialService _social = SocialService(uuid: _auth.userId);
  late final DatabaseService _db = DatabaseService(uuid: _auth.userId);

  String _error = "";

  @override
  Widget build(BuildContext context) {
    void showAddFriendPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Send a friend request to another user",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          TextFormField(
                            controller: _nameController,
                            inputFormatters: <TextInputFormatter>[
                              //FilteringTextInputFormatter.allow(RegExp("[0-9\.a-zA-Z_]")),
                            ],
                            decoration: authInputDecoration.copyWith(hintText: "Username"),
                            validator: (val) => val!.isEmpty ? "Please enter a username" : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (!await _auth.checkUsername(_nameController.text)) {
                            setState(() {
                              _error = "This user does not exist!";
                            });
                          }
                          else {
                            _social.sendFriendRequest(friendUsername: _nameController.text);
                            NotificationService().sendFriendRequestNotification(await _db.getIdByName(_nameController.text), UserData.username);
                            setState(() {
                              _error = "";
                            });
                            Fluttertoast.showToast(
                              msg: "Request sent!",
                              webBgColor: "linear-gradient(to right, #0c18fb, #0c18fb)",
                            );
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Send Request",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      _error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Friends"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.add),
              onPressed: () => showAddFriendPanel(),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  "My Friends",
                ),
              ),
              Tab(
                child: Text(
                  "Requests",
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamProvider<List<String>?>.value(
              value: _social.friends,
              initialData: null,
              child: const FriendsList(isShareMenu: false),
            ),
            StreamProvider<List<String>?>.value(
              value: _social.friendRequests,
              initialData: null,
              child: FriendRequestsList(),
            )
          ],
        ),
      ),
    );
  }
}
