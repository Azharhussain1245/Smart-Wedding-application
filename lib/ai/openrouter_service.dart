import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  static const String _apiKey = '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';
  static const String _endpoint = 'https://openrouter.ai/api/v1/chat/completions';

  static Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://smartwed.app', // required by OpenRouter
          'X-Title': 'SmartWed AI Assistant',
        },
        body: jsonEncode({
          "model": "mistralai/mistral-7b-instruct", // FREE / LOW COST
          "messages": [
            {
              "role": "system",
              "content":
                  "You are SmartWed AI Assistant. Help couples plan weddings, budgets, vendors, timelines, and checklists."
            },
            {
              "role": "user",
              "content": message
            }
          ],
          "temperature": 0.7,
          "max_tokens": 300
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "Sorry, I couldn't process your request right now.";
      }
    } catch (e) {
      return "Network error. Please try again.";
    }
  }
}
