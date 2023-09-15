import 'package:flutter/material.dart';
import 'package:mobile_app/models/community_snippet.dart';
import 'package:mobile_app/screens/home/CommunityTab/shared_snippets_list.dart';
import 'package:mobile_app/services/social.dart';
import 'package:provider/provider.dart';

import '../../../services/auth.dart';

class FriendsTab extends StatelessWidget {
  FriendsTab({super.key});

  final AuthService _auth = AuthService();
  late final SocialService _social = SocialService(uuid: _auth.userId);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CommunitySnippet>?>.value(
      value: _social.sharedSnippets,
      initialData: null,
      child: const SharedSnippetsList(),
    );
  }
}
