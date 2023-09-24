import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/loading.dart';
import 'friend_request_tile.dart';

class FriendRequestsList extends StatefulWidget {
  const FriendRequestsList({super.key});

  @override
  State<FriendRequestsList> createState() => _FriendRequestsListState();
}

class _FriendRequestsListState extends State<FriendRequestsList> {
  @override
  Widget build(BuildContext context) {
    final friendRequests = Provider.of<List<String>?>(context);
    return friendRequests == null ? const Loading() : ListView.builder(
      itemCount: friendRequests.length,
      itemBuilder: (context, index) {
        return FriendRequestTile(id: friendRequests[index]);
      },
    );
  }
}
