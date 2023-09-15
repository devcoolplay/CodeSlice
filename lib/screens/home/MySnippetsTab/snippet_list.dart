
/// The SnippetList widget builds the list of snippets for the My Snippets tab

import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home/MySnippetsTab/snippet_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/snippet.dart';
import '../../../shared/loading.dart';

class SnippetList extends StatefulWidget {
  SnippetList({super.key, required this.search});

  String search;

  @override
  State<SnippetList> createState() => _SnippetListState();
}

class _SnippetListState extends State<SnippetList> {
  @override
  Widget build(BuildContext context) {

    final snippets = Provider.of<List<Snippet>?>(context);

    // snippetList to apply search filter
    final snippetList = snippets?.where((snip) => snip.name.toLowerCase().contains(widget.search) || snip.description.toLowerCase().contains(widget.search)).toList();

    return snippets == null ? const Loading() : ListView.builder(
      itemCount: snippetList?.length,
      itemBuilder: (context, index) {
        snippetList?.sort((a,b) {
          var adate = a.timestamp; //before -> var adate = a.expiry;
          var bdate = b.timestamp; //var bdate = b.expiry;
          return -adate.compareTo(bdate);
        });
        return SnippetTile(snippet: snippetList![index]);
      },
    );
  }
}
