import "package:http/http.dart" as http;
import "dart:convert";

Future<dynamic> httpGet(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  return jsonDecode(response.body);
}
