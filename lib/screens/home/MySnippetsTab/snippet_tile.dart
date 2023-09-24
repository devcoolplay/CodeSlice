
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

class SnippetTile extends StatefulWidget {
  const SnippetTile({super.key, required this.snippet});

  final Snippet snippet;

  @override
  State<SnippetTile> createState() => _SnippetTileState();
}

class _SnippetTileState extends State<SnippetTile> {
  @override
  Widget build(BuildContext context) {
    final selectedSnippetsProvider = Provider.of<SelectedSnippetsProvider>(context);
    final controller = CodeController(
      text: widget.snippet.content,
      language: availableLanguageHighlighting.containsKey(widget.snippet.language.toLowerCase().replaceAll(" ", "")) ? availableLanguageHighlighting[widget.snippet.language.toLowerCase().replaceAll(" ", "")] : availableLanguageHighlighting["other"],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Container(
          color: selectedSnippetsProvider.selectedSnippets.contains(widget.snippet.id) ? Theme.of(context).highlightColor : null, // Change color to grey if this snippet is selected,,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {
              if (selectedSnippetsProvider.selectedSnippets.isNotEmpty) {
                selectedSnippetsProvider.toggleSnippet(widget.snippet.id);
              }
            },
            onLongPress: () {
              selectedSnippetsProvider.toggleSnippet(widget.snippet.id);
            },
            child: Ink(
              child: IgnorePointer(
                ignoring: selectedSnippetsProvider.selectedSnippets.isNotEmpty ? true : false, // If selection mode, disable expansion tile
                child: ExpansionTile(
                  textColor: Theme.of(context).highlightColor,
                  iconColor: Theme.of(context).highlightColor,
                  backgroundColor: selectedSnippetsProvider.selectedSnippets.contains(widget.snippet.id) ? Theme.of(context).highlightColor : null, // Change color to grey if this snippet is selected,
                  leading: Icon(availableLanguageIcons.containsKey(widget.snippet.language.toLowerCase()) ? availableLanguageIcons[widget.snippet.language.toLowerCase()] : availableLanguageIcons["other"]),
                  title: Text(widget.snippet.name),
                  subtitle: widget.snippet.description == "empty" ? Text(widget.snippet.language, style: const TextStyle(fontSize: 14.0)) :Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snippet.language,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          widget.snippet.description,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      )
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.snippet.content));
                        Fluttertoast.showToast(
                          msg: "Snippet copied to clipboard!",
                          webBgColor: "linear-gradient(to right, #0c18fb, #0c18fb)",
                        );
                    },
                  ),
                  children: [
                    CodeTheme(
                      data: CodeThemeData(styles: monokaiSublimeTheme),
                      child: SingleChildScrollView(
                        child: CodeField(
                          controller: controller,
                          readOnly: true,
                          gutterStyle: const GutterStyle(
                            showLineNumbers: false,
                            showErrors: false,
                            margin: 1.0,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}
