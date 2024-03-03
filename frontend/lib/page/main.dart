import "package:flutter/material.dart";

import "package:frontend/util/diet.dart";
import "package:frontend/util/file.dart";

Map? dietInfo;
List<bool>? allergy;

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({super.key});

  @override
  State<MainPageWidget> createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    debugPrint("$dietInfo");

    return FutureBuilder(
      future: dietInfo == null
          ? getDiet("97deea74959e4608a2c9d7255beb71c0")
          : Future(() => dietInfo),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          dietInfo = snapshot.data;

          debugPrint("$dietInfo");

          return Padding(
              padding: const EdgeInsets.all(20),
              child: dietInfo == null
                  ? const Center(child: Text("중식이 제공되지 않습니다."))
                  : FutureBuilder(
                      future: Future(() async => await fileUtil.exists()
                          ? await fileUtil.readFileJSON()
                          : List.filled(19, false)),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          debugPrint("${snapshot.data}");

                          // (snapshot.data as List<bool>).forEach((element) { allergy?[element-1] });

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                ...dietInfo!["diet"]
                                    .map((e) => ListTile(
                                  title: Container(
                                    child: Text(e),
                                  ),
                              ))
                                    .toList()
                            ],
                          ),
                          );
                        } else {
                          return const Placeholder();
                        }
                      }));
        } else {
          return const Center(
            child: Text("받는 중..."),
          );
        }
      },
    );
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
    // 순번 업데이트 함수 백그라운드에서 실행? 호출 위치 미정, 이 함수 아닐수도 있음.

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '남은 대기 인원 :',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
