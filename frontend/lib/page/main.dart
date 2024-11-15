import "package:flutter/material.dart";
import "dart:async";

import "package:frontend/util/diet.dart";
import "package:frontend/util/file.dart";
import "package:frontend/util/network.dart";
import "package:http/http.dart";

Map? dietInfo;

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({super.key});

  @override
  State<MainPageWidget> createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer; // _timer를 null로 초기화
  int waitingCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.reset();
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      //updateWaitingCount();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  //TODO : 대기 인원 구현
  Future<void> updateWaitingCount() async {
    try {
      final response = await httpGet("http://localhost:8720/queue/status");

      if (response != null) {
        setState(() {
          waitingCount = response['waiting_count']; //받아온 대기 인원 수
        });
      } else {
        print("Error: Null response received");
      }
    } catch (e) {
      print("Error fetching waiting count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: const Text(
            "홈",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Padding(padding: EdgeInsets.all(50)),
            buildHeader(),
            buildHorizontalDivider(),
            buildDietPanel(deviceSize)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // 클릭시 새로고침
            if (_controller.isAnimating) {
              return;
            }

            _controller.forward();
          },
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ));
  }

  FutureBuilder buildDietPanel(Size deviceSize) {
    const fileUtil = FileUtil("./allergy.json");

    return FutureBuilder(
      future: dietInfo == null
          ? getDiet("97deea74959e4608a2c9d7255beb71c0")
          : Future(() => dietInfo),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          dietInfo = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: dietInfo == null
                ? const Center(child: Text("중식이 제공되지 않습니다."))
                : FutureBuilder(
                    future: Future(() async => await fileUtil.exists()
                        ? await fileUtil.readFileJSON()
                        : List.filled(19, false)),
                    builder:
                        (BuildContext context, AsyncSnapshot allergySnapshot) {
                      if (allergySnapshot.connectionState ==
                          ConnectionState.done) {
                        final userAllergies =
                            allergySnapshot.data ?? List.filled(19, false);
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            children: [
                              for (int i = 0;
                                  i < (dietInfo!["diet"] as List).length;
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dietInfo!["diet"][i],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: (dietInfo!["allergy"][i]
                                                      as List<int>)
                                                  .any((allergen) =>
                                                      userAllergies[
                                                          allergen - 1] ==
                                                      true)
                                              ? Colors.red
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        (dietInfo!["allergy"][i] as List<int>)
                                                    .isNotEmpty &&
                                                dietInfo!["allergy"][i][0] != -1
                                            ? (dietInfo!["allergy"][i]
                                                    as List<int>)
                                                .join(", ")
                                            : "",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      } else {
                        return const Placeholder();
                      }
                    },
                  ),
          );
        } else {
          return const Center(
            child: Text("받는 중..."),
          );
        }
      },
    );
  }

  String getAllergyInfoText(List<int> allergyInfo) {
    if (allergyInfo.isEmpty || allergyInfo.contains(-1)) {
      return "알레르기 정보 없음";
    }
    return allergyInfo.join(", ");
  }

  Future<dynamic> buildAllergyInfoDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: SizedBox(
                  child: ListView(
                children: const [Text("테스트")],
              )),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text("확인"),
                )
              ],
            ));
  }

  Padding buildHorizontalDivider() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Divider(
        height: 1,
        thickness: 1,
        indent: 20,
        endIndent: 20,
        color: Colors.black38,
      ),
    );
  }

  Widget buildHeader() {
    //TODO :  순번 업데이트 함수 백그라운드에서 실행? 호출 위치 미정, 이 함수 아닐수도 있음.

    return Container(
      margin: const EdgeInsets.all(20),
      color: Colors.green,
      child: Text(
        '남은 대기 인원 : $waitingCount',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
