import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  final String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  final _dio = Dio();
  
  Future<String> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY']}',
          },
        ),
        data: {
          'messages': [
            {'role': 'user', 'content': message}
          ],
          'model': 'llama-3.3-70b-versatile'
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
