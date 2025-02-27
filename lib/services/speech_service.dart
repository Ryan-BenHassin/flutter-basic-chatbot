import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpeechService {
  final String _baseUrl = 'https://api.groq.com/openai/v1/audio/transcriptions';
  final _dio = Dio();

  Future<String> transcribeAudio(String audioFilePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(audioFilePath),
        'model': 'whisper-large-v3-turbo',
      });

      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY']}',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['text'];
      } else {
        throw Exception('Failed to transcribe: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error transcribing audio: $e');
    }
  }
}
