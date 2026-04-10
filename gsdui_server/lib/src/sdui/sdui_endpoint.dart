import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'gemini_service.dart';

class SduiEndpoint extends Endpoint {
  
  /// Generates a dynamic UI based on the user's prompt using Gemini
  Future<GeneratedWidget> generateUi(Session session, String prompt) async {
    // Retrieve API key from Serverpod's password management (config/passwords.yaml)
    final apiKey = session.passwords['geminiApiKey'];
    
    if (apiKey == null || apiKey.isEmpty) {
      session.log('geminiApiKey is missing in passwords.yaml.', level: LogLevel.error);
      throw Exception('Server misconfiguration: Gemini API Key is not set in passwords.yaml.');
    }

    final service = GeminiService(apiKey);
    
    try {
      final jsonSchemaString = await service.generateWidgetJson(prompt);
      return GeneratedWidget(jsonSchema: jsonSchemaString);
    } catch (e) {
      session.log('Error generating UI: $e', level: LogLevel.error);
      rethrow;
    }
  }
}
