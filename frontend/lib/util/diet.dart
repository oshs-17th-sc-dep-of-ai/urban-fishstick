import "package:http/http.dart" as http;
import "dart:convert";

Map getDiet() {
  Future<String> fetchData() async {
    // N10 교육청 코드
    // 8140246 학교 코드
    // 97deea74959e4608a2c9d7255beb71c0 API 키
    final url = Uri.parse(
        "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=97deea74959e4608a2c9d7255beb71c0&Type=json&ATPT_OFCDC_SC_CODE=N10&SD_SCHUL_CODE=8140246&MLSV_YMD=20230816");
    final response = await http.get(url);

    Map json_response = jsonDecode(response.body);
  }

  fetchData().then((value) => print(value));
}
