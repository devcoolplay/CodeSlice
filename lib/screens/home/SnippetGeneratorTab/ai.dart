
/// The AI widget returns the screen for the Snippet Generation tab.
/// Here, users can type a prompt for a code snippet they want to get created by ChatGPT.
/// The app then makes an API request.

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_app/screens/home/SnippetGeneratorTab/ai_snippet_tile.dart';
import 'package:mobile_app/shared/constants.dart';

import '../../../models/snippet.dart';
import '../../../services/chat_gpt.dart';

class AI extends StatefulWidget {
  const AI({super.key});

  @override
  State<AI> createState() => _AIState();
}

class _AIState extends State<AI> {
  final _formKey = GlobalKey<FormState>();
  final _promptController = TextEditingController();
  final _languageController = TextEditingController();
  final _chatGPT = ChatGPT();

  bool _loading = false;
  String _generatedSnippet = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _promptController,
                      decoration: textInputDecoration.copyWith(hintText: "Prompt"),
                      validator: (val) => val!.isEmpty ? "Please enter a prompt" : null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _languageController,
                      decoration: textInputDecoration.copyWith(hintText: "Language"),
                      validator: (val) => val!.isEmpty ? "Please enter a language" : null,
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          final codeSnippet = await _chatGPT.generateCodeSnippet(_promptController.text, _languageController.text);
                          setState(() {
                            _loading = false;
                            _generatedSnippet = codeSnippet;
                          });
                        }
                      },
                      child: const Text("Generate Snippet"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: _loading ?
              const Padding(padding: EdgeInsets.only(top: 50), child: SpinKitThreeBounce(color: Colors.grey, size: 20.0)) :
              (_generatedSnippet != "" ?
                AiSnippetTile(snippet: Snippet(id: "", name: "AI Generated", description: "empty", language: _languageController.text, content: _generatedSnippet, path: "/", timestamp: DateTime.now())) :
                const Padding(padding: EdgeInsets.only(top: 50.0), child: Text("Powered by OpenAI", style: TextStyle(color: Colors.grey)),)
              ),
          ),
          const SizedBox(height: 100.0)
        ],
      ),
    );
  }
}
