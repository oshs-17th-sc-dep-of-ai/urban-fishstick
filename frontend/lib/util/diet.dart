import "package:frontend/util/network.dart";
import "package:intl/intl.dart";

Future<Map<String, List>> getDiet(String apiKey) async {
  try {
    final date = DateFormat("yyyyMMdd").format(DateTime(2024, 11, 8));
    final url =
        "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=$apiKey&Type=json&ATPT_OFCDC_SC_CODE=N10&SD_SCHUL_CODE=8140246&MLSV_YMD=$date";

    Map diet = await httpGet(url);

    List<String> dietData =
        diet["mealServiceDietInfo"][1]["row"][0]["DDISH_NM"].split("<br/>");

    return {
      "diet": dietData.map((e) => e.split(' ')[0]).toList(),
      "allergy": dietData.map((e) {
        final a = e.split(' ')[1];
        return a.isNotEmpty
            ? a
                .substring(1, a.length - 1)
                .split(".")
                .map((e) => int.tryParse(e))
                .where((element) => element != null)
                .cast<int>() // 정확한 List<int> 반환
                .toList()
            : [];
      }).toList()
    };
  } catch (e) {
    print("getDiet 오류: $e");
    return {"diet": [], "allergy": []};
  }
}
