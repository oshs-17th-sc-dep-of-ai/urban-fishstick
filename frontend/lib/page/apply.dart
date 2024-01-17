import "package:flutter/material.dart";
import "package:frontend/util/file.dart";

List currentMemberList = [];

class ApplyPageWidget extends StatefulWidget {
  const ApplyPageWidget({super.key});

  @override
  State<ApplyPageWidget> createState() => ApplyPageWidgetState();
}

class ApplyPageWidgetState extends State<ApplyPageWidget> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(12),
        child: ApplyPageWidgetBody(),
      ),
      floatingActionButton: buildApplyButton(),
    );
  }

  TextButton buildLoadGroupButton() {
    return TextButton(
      child: const Text("그룹 불러오기"),
      onPressed: () {
        const fileUtil = FileUtil("./group.json");

        fileUtil
            .readFileJSON()
            .then((value) => {currentMemberList.addAll(value)});
      },
    );
  }

  IconButton buildApplyButton() {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                width: 200,
                height: 100,
                child: Center(
                  child: Text("신청하시겠습니까?"),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      // httpGet("http://ohsung.hs.kr/") // HTTP? HTTPS?
                      //     .then((value) {
                      //   Fluttertoast.showToast(msg: "신청되었습니다.");
                      // }).onError((error, stackTrace) {
                      //   debugPrint(error.toString());
                      //   debugPrintStack(stackTrace: stackTrace);
                      // });
                      Navigator.pop(context);
                    },
                    child: const Text("예")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("아니오"))
              ],
            );
          },
        );
      },
    );
  }
}

class ApplyPageWidgetBody extends StatefulWidget {
  const ApplyPageWidgetBody({super.key});

  @override
  State<ApplyPageWidgetBody> createState() => _ApplyPageWidgetBodyState();
}

class _ApplyPageWidgetBodyState extends State<ApplyPageWidgetBody> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return SizedBox(
      width: deviceSize.width,
      height: deviceSize.height,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        children: [
          ...buildMemberList(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController textController =
                        TextEditingController();

                    return AlertDialog(
                      content: SizedBox(
                        width: 300,
                        height: 75,
                        child: Center(
                            child: TextField(
                          controller: textController,
                        )),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("취소"),
                        ),
                        TextButton(
                          onPressed: () {
                            if (textController.text.isNotEmpty) {
                              setState(() {
                                currentMemberList
                                    .add(int.parse(textController.text));
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: const Text("추가"),
                        ),
                      ],
                    );
                  });
            },
          )
        ],
      ),
    );
  }

  List<ListTile> buildMemberList() {
    return currentMemberList
        .map((e) => ListTile(
              title: Text(e.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {},
              ),
            ))
        .toList();
  }
}
