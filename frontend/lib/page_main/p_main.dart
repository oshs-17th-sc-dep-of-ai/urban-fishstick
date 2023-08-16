import "package:flutter/material.dart";

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.all(50)),
        Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "남은 대기 인원: nn",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Divider(
            height: 1,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.black38,
          ),
        ),
        Expanded(child: Placeholder()) // ListView 사용해 식단 출력
      ],
    );
  }
}
