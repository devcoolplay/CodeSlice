
/// The SnippetTile widget builds the individual snippet tiles.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/snippet.dart';
import 'package:mobile_app/shared/constants.dart';
import 'package:provider/provider.dart';

import '../../../models/folder.dart';

class FolderTile extends StatefulWidget {
  const FolderTile({super.key, required this.folder});

  final Folder folder;

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  @override
  Widget build(BuildContext context) {
    final selectedFoldersProvider = Provider.of<SelectedFoldersProvider>(context);
    final selectedSnippetsProvider = Provider.of<SelectedSnippetsProvider>(context);

    return Card(
      child: Container(
        color: selectedFoldersProvider.selectedFolders.contains(widget.folder.name) ? Theme.of(context).highlightColor : null, // Change color to grey if this snippet is selected,,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () {
            if (selectedFoldersProvider.selectedFolders.isNotEmpty) {
              selectedFoldersProvider.toggleFolder(widget.folder.name);
            }
          },
          onLongPress: () {
            if (selectedSnippetsProvider.selectedSnippets.isEmpty) {
              selectedFoldersProvider.toggleFolder(widget.folder.name);
            }
          },
          child: Ink(
            child: IgnorePointer(
              ignoring: selectedFoldersProvider.selectedFolders.isNotEmpty ? true : false, // If selection mode, disable expansion tile
              child: Container(
                color: selectedFoldersProvider.selectedFolders.contains(widget.folder.name) ? Theme.of(context).highlightColor : null, // Change color to grey if this snippet is selected,
                child: Center(child: Text(widget.folder.name)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
