
import 'dart:convert';
import 'api_secrets.dart';

import 'package:http/http.dart' as http;

class ChatGPT {
  // Generate a code snippet
  Future<String> generateCodeSnippet(String prompt, String language) async {
    prompt += " in $language";
    const apiKey = openAIApiKey;
    const apiUrl = "https://api.openai.com/v1/chat/completions";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "You are a an api endpoint for an app that generates code snippets for a user's prompt. You only respond with the code snippet! No explanations, the code should be able to run when directly pasting it"
          },
          {
            "role": "user",
            "content": prompt
          }
        ]
      }),
    );
    if (response.statusCode == 200) {
      //print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);
      //print(data);
      String code = data["choices"][0]["message"]["content"];

      return code;
    }
    else {
      throw Exception("Failed to generate code snippet!");
    }
  }
}