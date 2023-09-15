import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/CommunityTab/community_snippet_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/community_snippet.dart';
import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../shared/loading.dart';

class SharedSnippetsList extends StatefulWidget {
  const SharedSnippetsList({super.key});

  @override
  State<SharedSnippetsList> createState() => _SharedSnippetsListState();
}

class _SharedSnippetsListState extends State<SharedSnippetsList> {
  final AuthService _auth = AuthService();
  late final DatabaseService _db = DatabaseService(uuid: _auth.userId);

  Future<Map<String, String>> _getNames(List<CommunitySnippet> snippets) async {
    Map<String, String> usernames = {};
    for (CommunitySnippet snippet in snippets) {
      usernames[snippet.from] = await _db.getNameById(snippet.from);
    }
    return usernames;
  }

  @override
  Widget build(BuildContext context) {
    final snippets = Provider.of<List<CommunitySnippet>?>(context);
    return snippets == null ? const Loading() : FutureBuilder(
      future: _getNames(snippets),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return const Loading();
          default:
            if (snapshot.hasError) {
              return const Text("Error while trying to load shared snippets");
            }
            else {
              return ListView.builder(
                itemCount: snippets.length,
                itemBuilder: (context, index) {
                  return CommunitySnippetTile(snippet: snippets[index], username: snapshot.data![snippets[index].from]!,);
                },
              );
            }
        }
      }
    );
  }
}
