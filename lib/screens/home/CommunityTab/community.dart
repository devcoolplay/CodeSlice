
/// The Feed widget shows the screen for the Community Feed tab.
/// Here, users can share their snippets with other users.
/// In the future, they'll also be able to like and comment.

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/CommunityTab/friends_tab.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return FriendsTab();
  }
}
