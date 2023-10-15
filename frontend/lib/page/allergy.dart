import "dart:io";

import "package:flutter/material.dart";
import "package:frontend/page/settings.dart";

class AllergyPageWidget extends StatefulWidget {
  const AllergyPageWidget({super.key});

  @override
  State<AllergyPageWidget> createState() => _MyWidgetState();
}

bool b = false;
List<bool> allergy = [];
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

class _MyWidgetState extends State<AllergyPageWidget> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    for (int i = 0; i < 19; i++) {
      allergy[i] = false;
    }
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '난류',
            style: TextStyle(color: Colors.black),
          ),
          Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.red,
            value: b,
            onChanged: (value) {
              setState(() {
                allergy[0] = !allergy[0];
              });
            },
          )
        ],
      ),
    );
  }
}
