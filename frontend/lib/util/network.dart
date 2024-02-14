import "package:http/http.dart" as http;
import "dart:convert";

Future<dynamic> httpGet(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  return jsonDecode(response.body);
}

Future<int> httpPost(String url, String data) async {
  // http.post 메소드로 Map이나 List 들어가면 컨텐츠 타입이 고정되어서 보낼 데이터는 JSON 문자열로 변환해서 보내야 함.
  final uri = Uri.parse(url);
  final response =
      await http.post(uri, headers: {"application": "json"}, body: data);

  return response.statusCode;
}
