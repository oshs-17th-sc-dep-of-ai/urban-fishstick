import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:frontend/util/file.dart";

class GroupManagePageWidget extends StatefulWidget {
  const GroupManagePageWidget({super.key});

  @override
  State<GroupManagePageWidget> createState() => _GroupManagePageWidgetState();
}

class _GroupManagePageWidgetState extends State<GroupManagePageWidget> {
  @override
  Widget build(BuildContext context) {
    const fileUtil = FileUtil("./group.json");

    return FutureBuilder(
      future: fileUtil.exists(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!(snapshot.data!)) {
            fileUtil.createFile("{}");
          }

          return Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
                future: fileUtil.readFileJSON(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data;
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        ...(data as Map)
                            .keys
                            .map((e) => ListTile(title: Text(e.toString())))
                            .toList(),
                        IconButton.outlined(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  final tempMemberList = <int>[];
                                  final textController =
                                      TextEditingController();
                                  final scrollController = ScrollController();

                                  return buildAlertDialog(tempMemberList,
                                      textController, scrollController);
                                });
                            setState(() {});
                          },
                          icon: const Icon(Icons.add),
                        )
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text("Loading group data file..."),
                    );
                  }
                }),
          );
        } else {
          return const Center(
            child: Text("Loading group data file..."),
          );
        }
      },
    );
  }

  AlertDialog buildAlertDialog(List<int> tempMemberList,
      TextEditingController textController, ScrollController scrollController) {
    return AlertDialog(
      content: SizedBox(
        width: 500,
        height: 300,
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 170,
              child: ListView(
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  shrinkWrap: true,
                  children: tempMemberList
                      .map((e) => ListTile(title: Text(e.toString())))
                      .toList()),
            ),
            Row(
              children: [
                SizedBox(
                    width: 235,
                    height: 10,
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        textFieldSubmitAction(tempMemberList, textController,
                            scrollController); // 중복 검사 필요
                      },
                    )),
                IconButton(
                    onPressed: () {
                      textFieldSubmitAction(
                          tempMemberList, textController, scrollController);
                    },
                    icon: const Icon(Icons.add))
              ],
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: () {}, child: const Text("확인")),
        ElevatedButton(onPressed: () {}, child: const Text("취소"))
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    );
  }

  void textFieldSubmitAction(List<int> tempMemberList,
      TextEditingController textController, ScrollController scrollController) {
    setState(() {
      tempMemberList.add(int.parse(textController.value.text));
    });
    scrollController.animateTo(scrollController.position.extentTotal,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }
}
