import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'loading.dart';
import 'friend_tile.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({super.key, required this.isShareMenu});

  final bool isShareMenu;

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {

  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<String>?>(context);
    return friends == null ? (widget.isShareMenu ? const SizedBox(height: 20.0, width: 20.0) : const Loading()) : ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return FriendTile(id: friends[index], isShareMenu: widget.isShareMenu);
      },
    );
  }
}
