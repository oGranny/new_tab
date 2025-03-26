import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiApiRequest {
  final Future<String> apiKey = SharedPreferences.getInstance()
      .then((prefs) => prefs.getString('geminiApiKey') ?? '');
  final String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  Future<String> generateContent(String text) async {
    print('Generating content with text: $text');
    final key = await apiKey;
    final response = await http.post(
      Uri.parse('$apiUrl?key=$key'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': '$text'}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');
      return jsonDecode(response.body)['candidates'][0]['content']['parts'][0]
          ['text'];
    } else {
      print('Request failed with status: ${response.statusCode}');
      return 'Error: ${response.statusCode}';
    }
  }
}
