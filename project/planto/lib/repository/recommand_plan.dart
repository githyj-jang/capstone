import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchItinerary({
  required String location,
  required String startDate, // 형식: YYYY-MM-DD
  required String endDate,   // 형식: YYYY-MM-DD
}) async {

  final String apiUrl = 'https://api.perplexity.ai/chat/completions'; // 올바른 엔드포인트
  //final String apiKey = dotenv.env['API_KEY'].toString(); // 실제 API 키로 교체
  String apiKey = dotenv.env['API_KEY'].toString();
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception('API 키가 .env 파일에 설정되어 있지 않습니다.');
  }

  final Map<String, dynamic> body = {
    "model": "llama-3.1-sonar-small-128k-online", // 필요한 경우 모델 변경
    "messages": [
      {
        "role": "system",
        "content": "Be precise and concise."
      },
      {
        "role": "user",
        "content": """

$location에서 $startDate부터 $endDate까지의 여행 일정을 생성하세요. 각 날짜별로 다음과 같은 JSON 형식으로 일정을 작성해주세요:
{
  "itinerary": [
    {
      "day": "YYYY-MM-DD",
      "activities": [
        {
          "place": "장소 이름",
          "placeInfo": [위도, 경도],
          "startTime": "HH:MM",
          "endTime": "HH:MM",
          "route": 순서
          "description": "추천 활동"
        }
      ]
    },
  ]
}

data들의 place, description은 한글이어야만 합니다. 각 날짜마다 시간대별로 추천 활동을 포함하고, 활동 장소의 좌표(위도 및 경도), 시작 시간, 종료 시간, 그리고 해당 활동의 순서, 추천 활동을 반드시 포함해주세요. 이 형식은 매일 동일하게 유지되어야 합니다. 부가설명 없이 json 형태만 결과에 있어야합니다.
"""
      }
    ],
    "max_tokens": 1000,
    "temperature": 0.7,
    "top_p": 0.9,
    "return_citations": true,
    "search_domain_filter": ["perplexity.ai"],
    "return_images": false,
    "return_related_questions": false,
    "search_recency_filter": "month",
    "top_k": 0,
    "stream": false,
    "presence_penalty": 0,
    "frequency_penalty": 1
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    // API 응답 구조에 맞게 처리 필요
    return data;
  } else {
    throw Exception('일정 로드 실패: ${response.body}');
  }
}