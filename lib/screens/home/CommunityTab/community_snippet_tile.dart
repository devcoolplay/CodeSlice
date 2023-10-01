
/// The SnippetTile widget builds the individual snippet tiles.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/models/community_snippet.dart';
import 'package:mobile_app/shared/constants.dart';
import 'package:mobile_app/shared/profile_picture.dart';
import 'package:provider/provider.dart';

class CommunitySnippetTile extends StatelessWidget {
  const CommunitySnippetTile({super.key, required this.snippet, required this.username});

  final CommunitySnippet snippet;
  final String username;

  /*Future<String> _getName() async {
    return await _db.getNameById(snippet.from);
  }*/

  @override
  Widget build(BuildContext context) {
    final selectedSnippetsProvider = Provider.of<SelectedSnippetsProvider>(context);
    final controller = CodeController(
      text: snippet.content,
      language: availableLanguageHighlighting.containsKey(snippet.language.toLowerCase().replaceAll(" ", "")) ? availableLanguageHighlighting[snippet.language.toLowerCase().replaceAll(" ", "")] : availableLanguageHighlighting["other"],
    );
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Container(
            color: selectedSnippetsProvider.selectedSnippets.contains(snippet.id) ? Theme.of(context).highlightColor : null, // Change color to blue if this snippet is selected,,
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: () {
                if (selectedSnippetsProvider.selectedSnippets.isNotEmpty) {
                  selectedSnippetsProvider.toggleSnippet(snippet.id);
                }
              },
              onLongPress: () {
                selectedSnippetsProvider.toggleSnippet(snippet.id);
              },
              child: Ink(
                child: IgnorePointer(
                  ignoring: selectedSnippetsProvider.selectedSnippets.isNotEmpty ? true : false, // If selection mode, disable expansion tile
                  child: ExpansionTile(
                    textColor: Theme.of(context).highlightColor,
                    iconColor: Theme.of(context).highlightColor,
                    backgroundColor: selectedSnippetsProvider.selectedSnippets.contains(snippet.id) ? Theme.of(context).highlightColor : null, // Change color to blue if this snippet is selected,
                    leading: SizedBox(height: 40, width: 40, child: ProfilePicture(userId: snippet.from, size: 10.0)),
                    title: Text(snippet.name),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        username,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    children: [
                      Column(
                        children: [
                          ListTile(
                            leading: Icon(availableLanguageIcons.containsKey(snippet.language.toLowerCase()) ? availableLanguageIcons[snippet.language.toLowerCase()] : availableLanguageIcons["other"]),
                            title: const Divider(),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snippet.language,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                                snippet.description == "empty" ? const SizedBox(height: 10.0) :
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                                  child: Text(
                                    snippet.description,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      //color: ,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: snippet.content));
                                Fluttertoast.showToast(
                                  msg: "Snippet copied to clipboard!",
                                  webBgColor: "linear-gradient(to right, #0c18fb, #0c18fb)",
                                );
                              },
                            ),
                          ),
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
