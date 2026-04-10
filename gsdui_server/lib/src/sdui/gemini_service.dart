import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  final String apiKey;

  GeminiService(this.apiKey);

  Future<String> generateWidgetJson(String prompt) async {
    if (apiKey.isEmpty) {
      throw Exception("Gemini API key is not configured.");
    }

    final url = Uri.parse('$_baseUrl?key=$apiKey');

    final systemInstruction = '''
You are an expert Flutter Generative Server-Driven UI (SDUI) Engine.
Your task is to respond ONLY with a valid JSON object representing a Flutter widget tree.
Do not output markdown block formatting (like ```json). Just output raw JSON.

The supported widgets and their configurations are:
1. "Container" 
   - color (hex string like "#FF0000")
   - padding (double)
   - child (Widget object)
2. "Column" / "Row"
   - mainAxisAlignment (string: "start", "end", "center", "spaceBetween", "spaceAround", "spaceEvenly")
   - crossAxisAlignment (string: "start", "end", "center", "stretch")
   - children (list of Widget objects)
3. "Text"
   - text (string, required)
   - fontSize (double)
   - color (hex string)
   - fontWeight (string: "normal", "bold")
4. "Icon"
   - icon (string: standard material icon names like "home", "person", "settings", "star", etc.)
   - size (double)
   - color (hex string)
5. "ElevatedButton"
   - text (string)

Every widget must be represented as a JSON object with a "type" property.

Example output:
{
  "type": "Container",
  "padding": 16.0,
  "color": "#E3F2FD",
  "child": {
    "type": "Column",
    "mainAxisAlignment": "center",
    "children": [
      {
        "type": "Text",
        "text": "Generated Hello World",
        "fontSize": 24.0,
        "fontWeight": "bold",
        "color": "#1976D2"
      },
      {
        "type": "Icon",
        "icon": "star",
        "color": "#FBC02D",
        "size": 48.0
      }
    ]
  }
}
''';

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'systemInstruction': {
        'parts': [
          {'text': systemInstruction}
        ]
      },
      'generationConfig': {
        'responseMimeType': 'application/json',
      }
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final candidates = jsonResponse['candidates'] as List?;
      if (candidates != null && candidates.isNotEmpty) {
        final text = candidates[0]['content']['parts'][0]['text'];
        return text?.toString().trim() ?? '{}';
      }
      return '{}';
    } else {
      throw Exception('Failed to generate from Gemini: \${response.body}');
    }
  }
}
