
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/services/auth.dart';

import '../../../services/database.dart';
import '../../../services/social.dart';

class FriendRequestTile extends StatefulWidget {
  FriendRequestTile({super.key, required this.id});

  String id;

  @override
  State<FriendRequestTile> createState() => _FriendRequestTileState();
}

class _FriendRequestTileState extends State<FriendRequestTile> {
  final AuthService _auth = AuthService();
  late final DatabaseService _db = DatabaseService(uuid: _auth.userId);
  late final SocialService _social = SocialService(uuid: _auth.userId);

  Future<String> _getName() async {
    return await _db.getNameById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    void accept() {
      _social.acceptFriendRequest(friendId: widget.id);
    }

    void reject() {
      _social.rejectFriendRequest(friendId: widget.id);
    }

    return FutureBuilder<String>(
      future: _getName(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return const SizedBox(height: 20.0);
          default:
            if (snapshot.hasError) {
              return const Text("Error while loading names of friends");
            }
            else {
              return ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  snapshot.data!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green,),
                  onPressed: accept,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red,),
                  onPressed: reject,
                ),
              );
            }
        }
      },
    );
  }
}
