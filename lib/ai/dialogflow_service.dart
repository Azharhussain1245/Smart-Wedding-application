import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class DialogflowService {
  static const String _functionUrl =
      "https://us-central1-smartwed-b8a99.cloudfunctions.net/dialogflowChat";

  /// Send message to Dialogflow Cloud Function
  static Future<String> sendMessage(String message) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return "Please login to continue.";
      }

      final response = await http.post(
        Uri.parse(_functionUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": message,
          "uid": user.uid,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["reply"] ?? "No response from AI.";
      } else {
        return "AI service error. Try again.";
      }
    } catch (e) {
      return "Unable to connect to AI service.";
    }
  }
}
