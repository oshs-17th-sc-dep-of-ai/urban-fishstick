import "package:frontend/util/network.dart";
import "package:intl/intl.dart";

Future<Map<String, List>> getDiet(String apiKey) async {
  // N10 교육청 코드
  // 8140246 학교 코드
  // 97deea74959e4608a2c9d7255beb71c0 API 키

  // final date = DateTime(2023, 11, 15);
  final date = DateFormat("yyyyMMdd").format(DateTime.now());
  Map diet = await httpGet(
      "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=$apiKey&Type=json&ATPT_OFCDC_SC_CODE=N10&SD_SCHUL_CODE=8140246&MLSV_YMD=$date"); // 날짜 수정 필요

  List<String> dietData;
  try {
    dietData =
        diet["mealServiceDietInfo"][1]["row"][0]["DDISH_NM"].split("<br/>");

    return {
      "diet": dietData.map((e) => e.split(' ')[0]).toList(),
      "allergy": dietData.map((e) {
        final a = e.split(' ')[1];

        // return a.isNotEmpty ? a.substring(1, a.length - 1).split('.') : ["-1"];
        return a.isNotEmpty ? a.substring(1, a.length-1).split(".").map((e) => int.parse(e)).toList() : -1;
      }).toList()
    };
  } catch (err) {
    return {"diet": [], "allergy": []};
  }
}
