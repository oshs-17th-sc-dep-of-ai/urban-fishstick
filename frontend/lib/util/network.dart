import "dart:async";
import "dart:convert";

import "package:http/http.dart" as http;
import "package:flutter_client_sse/flutter_client_sse.dart";
import "package:flutter_client_sse/constants/sse_request_type_enum.dart";

Future<dynamic> httpGet(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);

  return jsonDecode(response.body);
}

Future<int> httpPost(String url, String data) async {
  // http.post 메소드로 Map이나 List가 들어갈 경우 컨텐츠 타입이 고정되기 때문에 보낼 데이터는 문자열로 변환 후 보내야 함.
  final uri = Uri.parse(url);
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: data,
  );

  return response.statusCode;
}

class SSEClientManager {
  static final SSEClientManager _instance = SSEClientManager._constructor();

  SSEClientManager._constructor();

  StreamController streamController = StreamController();

  factory SSEClientManager() {
    return _instance;
  }

  Stream? listen() {
    try {
      SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: "http://223.130.151.247:8720/group/index/sse?sid=20002",
        header: {"Accept": "text/event-stream", "Cache-Control": "no-cache"},
      ).listen((event) {
        streamController.sink.add(event.data);
      });

      return streamController.stream;
    } catch (e) {
      return null;
    }
  }

  void close() async {
    SSEClient.unsubscribeFromSSE();
    await streamController.close();
  }
}
