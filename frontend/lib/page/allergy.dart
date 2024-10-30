import "package:flutter/material.dart";
import "package:frontend/page/settings.dart";
import "package:frontend/util/file.dart";

class AllergyPageWidget extends StatefulWidget {
  const AllergyPageWidget({super.key});

  @override
  State<AllergyPageWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AllergyPageWidget> {
  final fileUtil = const FileUtil("./allergy.json");

  // List<bool> allergy = List.filled(19, false);
  List? allergy;
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Checkbox(
            activeColor: Colors.blue,
            checkColor: Colors.white,
            value: allergy![index],
            onChanged: (value) {
              setState(() {
                allergy![index] = !allergy![index];
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const CircleBorder()),
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
    if (allergy == null) {
      return FutureBuilder(
          future: allergyListInitilize(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              allergy = snapshot.data ?? List.filled(19, false);

              return buildAllergyPage();
            } else {
              return const Scaffold(
                body: Center(
                  child: Text("알레르기 정보 로딩중..."),
                ),
              );
            }
          });
    } else {
      return buildAllergyPage();
    }
  }

  Scaffold buildAllergyPage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        title: const Text(
          '알레르기 설정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        leadingWidth: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(child: buildColumn(0, 9)),
            const SizedBox(width: 16),
            const VerticalDivider(
              color: Color.fromARGB(255, 209, 209, 209),
              width: 1,
            ),
            const SizedBox(width: 16),
            Expanded(child: buildColumn(10, 18)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: FloatingActionButton(
                onPressed: () {
                  fileUtil.writeFileJSON(allergy);
                },
                backgroundColor: const Color.fromARGB(255, 0, 120, 215),
                child: const Text(
                  '적용',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<List> allergyListInitilize() async {
    return await fileUtil.exists()
        ? await fileUtil.readFileJSON()
        : List.filled(19, false);
  }
}
