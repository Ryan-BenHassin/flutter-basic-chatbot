import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/message.dart';

class ChatService {
  final String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  final _dio = Dio();
  
  List<Map<String, String>> _prepareMessages(List<Message> messages) {
    final List<Map<String, String>> formattedMessages = [];

    formattedMessages.add(
      {
        "role" : "system",
        "content" : "You are an assitant of an app named Binomi, to find near appartments or places to rent. answer briefly"
      }
    );
    
    for (final message in messages) {
      String role = (message.isUser) ? 'user' : 'assistant';
      
      formattedMessages.add({
        'role': role,
        'content': message.content
      });
    }
    
    return formattedMessages;
  }
  
  Future<String> sendMessage(List<Message> messages) async {
    try {
      final formattedMessages = _prepareMessages(messages);
      
      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY']}'
          },
        ),
        data: {
          'messages': formattedMessages,
          'model': 'llama-3.3-70b-versatile',
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}
