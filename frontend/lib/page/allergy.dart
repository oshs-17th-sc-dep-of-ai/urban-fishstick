import "dart:io";

import "package:flutter/material.dart";
import "package:frontend/page/settings.dart";

class AllergyPageWidget extends StatefulWidget {
  const AllergyPageWidget({super.key});

  @override
  State<AllergyPageWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AllergyPageWidget> {
  List<bool> allergy = List.filled(19, false);
  List<String> text = [
    "난류",
    "우유",
    "메밀",
    "땅콩",
    "대두",
    "밀",
    "고등어",
    "게",
    "새우",
    "돼지고기",
    "복숭아",
    "토마토",
    "아황산류",
    "호두",
    "닭고기",
    "쇠고기",
    "오징어",
    "조개류",
    "잣",
  ];

  Widget buildCheckbox(int index) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              text[index],
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Checkbox(
            activeColor: Colors.blue,
            checkColor: Colors.white,
            value: allergy[index],
            onChanged: (value) {
              setState(() {
                allergy[index] = !allergy[index];
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: CircleBorder()),
      ],
    );
  }

  Widget buildColumn(int start, int end) {
    return Column(
      children: List.generate(
        end - start + 1,
        (index) => buildCheckbox(index + start),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 236, 236, 236),
        title: Text(
          '알레르기 설정',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        leadingWidth: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: buildColumn(0, 8),
            ),
            const SizedBox(width: 16),
            const VerticalDivider(
                color: Color.fromARGB(255, 209, 209, 209), width: 1),
            const SizedBox(width: 16),
            Expanded(
              child: buildColumn(9, 18),
            ),
          ],
        ),
      ),
    );
  }
}
