
/// The SnippetList widget builds the list of snippets for the My Snippets tab

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/folder.dart';
import '../../../shared/loading.dart';
import 'folder_tile.dart';

class FolderList extends StatefulWidget {
  FolderList({super.key, required this.search});

  String search;

  @override
  State<FolderList> createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
  @override
  Widget build(BuildContext context) {

    final folders = Provider.of<List<Folder>?>(context);

    var size = MediaQuery.of(context).size;
    const divisionFactor = 125;

    // folderList to apply search filter
    final folderList = folders?.where((fol) => fol.name.toLowerCase().contains(widget.search) && fol.name != "").toList();

    return folders == null ? const SizedBox(height: 1.0) : Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8.0, bottom: 0.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: size.width ~/ divisionFactor, // number of items in each row
          mainAxisSpacing: 5.0, // spacing between rows
          crossAxisSpacing: 5.0, // spacing between columns
          mainAxisExtent: 100
        ),
        itemCount: folderList!.length,
        itemBuilder: (context, index) {
          /*snippetList?.sort((a,b) {
            var adate = a.timestamp; //before -> var adate = a.expiry;
            var bdate = b.timestamp; //var bdate = b.expiry;
            return -adate.compareTo(bdate);
          });*/
          /*if (folderList![index].name == "") {
            return null;
          }*/
          return FolderTile(folder: folderList![index]);
        },
      ),
    );
  }
}
