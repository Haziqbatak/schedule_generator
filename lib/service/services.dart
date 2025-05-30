import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiServices {
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  static final String _baseURL =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

  static Future<String> generateSchedule(
    String scheduleName,
    String duration,
    String priority,
    String fromDate,
    String untilDate,
  ) async {
    //cek kondisi API Key
    if (_apiKey.isEmpty) {
      return 'API Key not found';
    }
    // baseURL + API Key
    final String url = _baseURL + _apiKey;

    //Request Body
    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Buatkan jadwal $scheduleName, "
                  "berdasrkan prioritas $priority, "
                  "dengan durasi $duration jam dari $fromDate sampai $untilDate",
            },
          ],
        },
      ],
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Terjadi kesalahan ${response.statusCode} + ${response.body}';
      }
    } catch (e) {
      return "Terjadi kesalahan $e";
    }
  }
}
