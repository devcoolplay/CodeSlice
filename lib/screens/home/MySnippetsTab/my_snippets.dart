
/// The MySnippets widget shows the screen for the My Snippets tab.
/// Here, users can see their snippets and create/delete/edit them

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/MySnippetsTab/snippet_list.dart';
import 'package:mobile_app/services/auth.dart';
import 'package:mobile_app/services/database.dart';
import 'package:provider/provider.dart';

import '../../../models/folder.dart';
import '../../../models/snippet.dart';
import 'folder_list.dart';

class MySnippets extends StatefulWidget {
  MySnippets({super.key, required this.search});

  String search;

  @override
  State<MySnippets> createState() => _MySnippetsState();
}

class _MySnippetsState extends State<MySnippets> {

  final AuthService _auth = AuthService();
  late final DatabaseService _db = DatabaseService(uuid: _auth.userId);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamProvider<List<Folder>?>.value(
              value: _db.folders,
              initialData: null,
              child: FolderList(search: widget.search),
            ),
            Divider(),
            StreamProvider<List<Snippet>?>.value(
              value: _db.snippets,
              initialData: null,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: SnippetList(search: widget.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
