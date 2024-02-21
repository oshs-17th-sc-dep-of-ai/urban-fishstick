import "package:flutter/material.dart";

import "package:frontend/util/diet.dart";

List diet = [];
List alrg = [];

const int _seq = 10;

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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.all(50)),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '남은 대기 인원 : $_seq',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Divider(
              height: 1,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black38,
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<Map>(
              future: diet.isEmpty
                  ? getDiet()
                  : Future(() => {"diet": diet, "alergy": alrg}),
              builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data?["diet"].length,
                      itemBuilder: (context, index) {
                        diet = snapshot.data?["diet"].toList();
                        alrg = snapshot.data?["alergy"].toList();

                        return SizedBox(
                          width: deviceSize.width - 20,
                          height: 30,
                          child: Text(diet[index]),
                        );
                      });
                } else {
                  return const Center(
                    child: Text("받는 중..."),
                  );
                }
              },
            ),
          ))
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
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class YourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageWidget(),
    );
  }
}

void main() {
  runApp(YourApp());
}
