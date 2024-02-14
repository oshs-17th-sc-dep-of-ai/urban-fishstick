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
        Text(
          text[index],
          style: TextStyle(color: Colors.black),
        ),
        Checkbox(
          activeColor: Colors.white,
          checkColor: Colors.red,
          value: allergy[index],
          onChanged: (value) {
            setState(() {
              allergy[index] = !allergy[index];
            });
          },
        ),
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
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildColumn(0, 8),
          buildColumn(9, 18),
        ],
      ),
    );
  }
}
