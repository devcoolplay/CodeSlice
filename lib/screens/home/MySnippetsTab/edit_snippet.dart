import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:mobile_app/shared/constants.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../models/snippet.dart';
import '../../../services/auth.dart';
import '../../../services/database.dart';

class EditSnippet extends StatefulWidget {
  const EditSnippet({super.key, required this.snippetId});

  final String snippetId;

  @override
  State<EditSnippet> createState() => _EditSnippetState();
}

class _EditSnippetState extends State<EditSnippet> {

  final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  final _controller = CodeController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _languageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSnippetData();
  }

  void _loadSnippetData() async {
    final databaseService = DatabaseService(uuid: AuthService().userId);
    Snippet? snippet = await databaseService.getSnippetById(widget.snippetId);
    setState(() {
      _controller.language = availableLanguageHighlighting[snippet.language.toLowerCase().replaceAll(" ", "")];
      _controller.text = snippet.content;
      _nameController.text = snippet.name;
      _languageController.text = snippet.language;
      if (snippet.description != "empty") {
        _descriptionController.text = snippet.description;
      }
    });
  }

  void _saveSnippet(String name, String content, String language, String description) async {
    if (description == "") {
      description = "empty";
    }
    try {
      await DatabaseService(uuid: _auth.userId).updateSnippet(widget.snippetId, name, content, language, description);
    } catch (e) {
      print("Failed to save snippet in database!");
      print(e);
    }
  }

  //String _hintText = "Language";
  /*void _typeAheadFilter(String value) {
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
  }*/

  @override
  Widget build(BuildContext context) {
    final selectedSnippetsProvider = Provider.of<SelectedSnippetsProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Edit Snippet"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                  controller: _nameController,
                  decoration: textInputDecoration.copyWith(hintText: "Name"),
                  validator: (val) => val!.isEmpty ? "Please enter a name" : null,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: textInputDecoration.copyWith(hintText: "Description (Optional)"),
                  maxLines: 5,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _languageController,
                  decoration: textInputDecoration.copyWith(
                    hintText: _hintText,
                    //alignLabelWithHint: true,
                    //labelText: _hintText == "Language" ? null : _hintText,
                  ),
                  validator: (val) => val!.isEmpty ? "Please enter a name" : null,
                  onChanged: (val) {
                    if (availableLanguageHighlighting.containsKey(val.toLowerCase().replaceAll(" ", ""))) {
                      _controller.language = availableLanguageHighlighting[val.toLowerCase().replaceAll(" ", "")];
                    }
                  },
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
                      _saveSnippet(_nameController.text, "${_controller.fullText} ", _languageController.text, _descriptionController.text);
                      selectedSnippetsProvider.unselectAllSnippets();
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
