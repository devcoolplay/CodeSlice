
/// The SnippetTile widget builds the individual snippet tiles.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_app/models/snippet.dart';
import 'package:mobile_app/shared/constants.dart';

import '../../../services/auth.dart';
import '../../../services/database.dart';

class AiSnippetTile extends StatefulWidget {
  const AiSnippetTile({super.key, required this.snippet});

  final Snippet snippet;

  @override
  State<AiSnippetTile> createState() => _AiSnippetTileState();
}

class _AiSnippetTileState extends State<AiSnippetTile> {
  final _nameController = TextEditingController();
  final _languageController = TextEditingController();
  final _descriptionController = TextEditingController();

  final AuthService _auth = AuthService();

  void _saveSnippet(String name, String content, String language, String description) async {
    if (description == "") {
      description = "empty";
    }
    try {
      await DatabaseService(uuid: _auth.userId).addSnippet(name, content, language, description);
    } catch (e) {
      print("Failed to save snippet in database!");
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _languageController.text = widget.snippet.language;
    _descriptionController.text = "AI generated";
  }

  @override
  Widget build(BuildContext context) {
    final controller = CodeController(
      text: widget.snippet.content,
      language: availableLanguageHighlighting.containsKey(widget.snippet.language.toLowerCase().replaceAll(" ", "")) ? availableLanguageHighlighting[widget.snippet.language.toLowerCase().replaceAll(" ", "")] : availableLanguageHighlighting["other"],
    );

    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Card(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: Icon(availableLanguageIcons.containsKey(widget.snippet.language.toLowerCase()) ? availableLanguageIcons[widget.snippet.language.toLowerCase()] : availableLanguageIcons["other"]),
                  title: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      helperText: "*Name",
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _languageController,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                        decoration: const InputDecoration(
                          helperText: "*Language",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          controller: _descriptionController,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                          decoration: const InputDecoration(
                            helperText: "Description"
                          ),
                        ),
                      ),
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
                ),
                CodeTheme(
                  data: CodeThemeData(styles: monokaiSublimeTheme),
                  child: SingleChildScrollView(
                    child: CodeField(
                      controller: controller,
                      readOnly: false,
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
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    child: const Text("Save Snippet"),
                    onPressed: () {
                      if (_languageController.text != "" && _nameController.text != "") {
                        _saveSnippet(_nameController.text, controller.fullText, _languageController.text, _descriptionController.text);
                        Fluttertoast.showToast(
                          msg: "Snippet saved!",
                          webBgColor: "linear-gradient(to right, #0c18fb, #0c18fb)",
                        );
                      }
                      else {
                        Fluttertoast.showToast(
                          msg: "Please enter a name and a language first.",
                          webBgColor: "linear-gradient(to right, #0c18fb, #0c18fb)",
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
