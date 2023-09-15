
/// The MySnippets widget shows the screen for the My Snippets tab.
/// Here, users can see their snippets and create/delete/edit them

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/MySnippetsTab/snippet_list.dart';
import 'package:mobile_app/services/auth.dart';
import 'package:mobile_app/services/database.dart';
import 'package:provider/provider.dart';

import '../../../models/snippet.dart';

class MySnippets extends StatefulWidget {
  MySnippets({super.key, required this.search});

  String search;

  @override
  State<MySnippets> createState() => _MySnippetsState();
}

class _MySnippetsState extends State<MySnippets> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Snippet>?>.value(
      value: DatabaseService(uuid: _auth.userId).snippets,
      initialData: null,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: SnippetList(search: widget.search),
      ),
    );
  }
}
