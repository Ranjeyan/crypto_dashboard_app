import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyDjwosc0lYuZSudtucQyXgtVFLJ5vQemV8';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  final List<Map<String, dynamic>> _conversationHistory = [];

  GeminiService() {
    _initializeChat();
  }

  void _initializeChat() {
    _conversationHistory.clear();
    _conversationHistory.add({
      'role': 'user',
      'parts': [
        {
          'text': '''You are a helpful cryptocurrency assistant. Your role is to:
              1. Provide accurate information about cryptocurrencies
              2. Explain crypto concepts in simple terms
              3. Answer questions about market trends, prices, and blockchain technology
              4. Be conversational and friendly
              5. Keep responses concise but informative
              6. Use emojis occasionally to be engaging

              When users ask about specific crypto prices or data, acknowledge that you can see the current market data they're viewing in their dashboard.'''
        }
      ]
    });
    _conversationHistory.add({
      'role': 'model',
      'parts': [
        {
          'text': 'Hello! 👋 I\'m your crypto assistant. I can help you understand cryptocurrencies, market trends, and answer any questions you have. What would you like to know?'
        }
      ]
    });
  }

  Future<String> sendMessage(String message, {String? cryptoContext}) async {
    try {
      String contextualMessage = message;

      if (cryptoContext != null && cryptoContext.isNotEmpty) {
        contextualMessage = '''Current Market Data: $cryptoContext 
        User Question: $message

        Please provide a helpful response based on the current market data and the user's question.''';
      }

      _conversationHistory.add({
        'role': 'user',
        'parts': [
          {'text': contextualMessage}
        ]
      });

      final url = Uri.parse('$_baseUrl?key=$_apiKey');

      final requestBody = {
        'contents': _conversationHistory,
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          final content = candidate['content'];
          final parts = content['parts'];

          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'];

            _conversationHistory.add({
              'role': 'model',
              'parts': [
                {'text': text}
              ]
            });

            return text;
          }
        }

        return 'I apologize, but I couldn\'t generate a response. Please try asking your question again.';
      } else {
        print('Gemini API Error: ${response.statusCode} - ${response.body}');
        return 'I\'m having trouble connecting right now 🤔. Please try again in a moment.';
      }
    } catch (e) {
      print('Gemini API Error: $e');
      return 'I\'m having trouble connecting to my AI brain right now 🤔. Please try again in a moment.';
    }
  }

  void resetChat() {
    _initializeChat();
  }

  void dispose() {
    _conversationHistory.clear();
  }
}