import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:mobile_app/shared/constants.dart';

import '../../../services/auth.dart';
import '../../../services/database.dart';

class AddSnippet extends StatefulWidget {
  const AddSnippet({super.key});

  @override
  State<AddSnippet> createState() => _AddSnippetState();
}

class _AddSnippetState extends State<AddSnippet> {

  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  // Snippet data
  String _name = "";
  String _description = "empty";
  String _language = "other";

  final _controller = CodeController(
    text: "",
    language: availableLanguageHighlighting["other"],
  );

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

  String _hintText = "Language";
  void _typeAheadFilter(String value) {
    if (value.isEmpty) {
      setState(() {
        _hintText = "Language";
      });
      return;
    }

    var availableLanguages = availableLanguageHighlighting.keys.toList();
    availableLanguages.sort((a, b) => a.length.compareTo(b.length));
    for (String lang in availableLanguages) {
      if (lang.contains(value.toLowerCase())) {
        setState(() {
          _hintText = lang;
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Add Snippet"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Name"),
                  validator: (val) => val!.isEmpty ? "Please enter a name" : null,
                  onChanged: (val) => setState(() {
                    _name = val;
                  }),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Description (Optional)"),
                  onChanged: (val) => setState(() {
                    _description = val;
                  }),
                  maxLines: 5,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    hintText: _hintText,
                    //alignLabelWithHint: true,
                    //labelText: _hintText == "Language" ? null : _hintText,
                  ),
                  validator: (val) => val!.isEmpty ? "Please enter a language" : null,
                  onChanged: (val) => setState(() {
                    _language = val;
                    _typeAheadFilter(val);
                    if (availableLanguageHighlighting.containsKey(_language.toLowerCase().replaceAll(" ", ""))) {
                      _controller.language = availableLanguageHighlighting[_language.toLowerCase().replaceAll(" ", "")];
                    }
                  }),
                  enableSuggestions: true,
                ),
                const SizedBox(height: 30.0),
                const Text(
                  "Code:",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                CodeTheme(
                  data: CodeThemeData(styles: monokaiSublimeTheme),
                  child: SingleChildScrollView(
                    child: CodeField(
                      controller: _controller,
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
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveSnippet(_name, "${_controller.fullText} ", _language, _description);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Save Snippet"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
