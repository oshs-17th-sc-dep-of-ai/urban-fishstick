import "package:frontend/util/network.dart";

Future<Map> getDiet() async {
  // N10 교육청 코드
  // 8140246 학교 코드
  // 97deea74959e4608a2c9d7255beb71c0 API 키
  Map diet = await httpGet(
      "https://open.neis.go.kr/hub/mealServiceDietInfo?KEY=97deea74959e4608a2c9d7255beb71c0&Type=json&ATPT_OFCDC_SC_CODE=N10&SD_SCHUL_CODE=8140246&MLSV_YMD=20230818");

  List<String> dietData;
  try {
    dietData = diet["mealServiceDietInfo"][1]["row"][0]["DDISH_NM"]
        .split("<br/>") as List<String>; // try로 감싸기
  } catch (err) {
    return {"diet": [], "alergy": []};
  }
  return {
    "diet": dietData,
    "alergy": dietData.map((e) {
      final a = e.split(' ')[1];
      return a.isNotEmpty ? a.substring(1, a.length - 1).split('.') : [];
    })
  };
}
