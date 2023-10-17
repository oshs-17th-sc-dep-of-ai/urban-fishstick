import "dart:io";

import "package:flutter/material.dart";
import "package:frontend/page/settings.dart";

class AllergyPageWidget extends StatefulWidget {
  const AllergyPageWidget({super.key});

  @override
  State<AllergyPageWidget> createState() => _MyWidgetState();
}

List<bool> allergy = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];
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
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    '난류',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[0],
                    onChanged: (value) {
                      setState(() {
                        allergy[0] = !allergy[0];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '우유',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[1],
                    onChanged: (value) {
                      setState(() {
                        allergy[1] = !allergy[1];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '메밀',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[2],
                    onChanged: (value) {
                      setState(() {
                        allergy[2] = !allergy[2];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '땅콩',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[3],
                    onChanged: (value) {
                      setState(() {
                        allergy[3] = !allergy[3];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '대두',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[4],
                    onChanged: (value) {
                      setState(() {
                        allergy[4] = !allergy[4];
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    '밀',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[5],
                    onChanged: (value) {
                      setState(() {
                        allergy[5] = !allergy[5];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '고등어',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[6],
                    onChanged: (value) {
                      setState(() {
                        allergy[6] = !allergy[6];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '게',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[7],
                    onChanged: (value) {
                      setState(() {
                        allergy[7] = !allergy[7];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '새우',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[8],
                    onChanged: (value) {
                      setState(() {
                        allergy[8] = !allergy[8];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '돼지고기',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[9],
                    onChanged: (value) {
                      setState(() {
                        allergy[9] = !allergy[9];
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    '복숭아',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[10],
                    onChanged: (value) {
                      setState(() {
                        allergy[10] = !allergy[10];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '토마토',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[11],
                    onChanged: (value) {
                      setState(() {
                        allergy[11] = !allergy[11];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '아황산류',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[12],
                    onChanged: (value) {
                      setState(() {
                        allergy[12] = !allergy[12];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '호두',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[13],
                    onChanged: (value) {
                      setState(() {
                        allergy[13] = !allergy[13];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '닭고기',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[14],
                    onChanged: (value) {
                      setState(() {
                        allergy[14] = !allergy[14];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '쇠고기',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[15],
                    onChanged: (value) {
                      setState(() {
                        allergy[15] = !allergy[15];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '오징어',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[16],
                    onChanged: (value) {
                      setState(() {
                        allergy[16] = !allergy[16];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '조개류',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[17],
                    onChanged: (value) {
                      setState(() {
                        allergy[17] = !allergy[17];
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    '잣',
                    style: TextStyle(color: Colors.black),
                  ),
                  Checkbox(
                    activeColor: Colors.white,
                    checkColor: Colors.red,
                    value: allergy[18],
                    onChanged: (value) {
                      setState(() {
                        allergy[18] = !allergy[18];
                      });
                    },
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
