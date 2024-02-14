import "package:flutter/material.dart";
import "package:frontend/util/file.dart";

class GroupManagePageWidget extends StatefulWidget {
  const GroupManagePageWidget({super.key});

  @override
  State<GroupManagePageWidget> createState() => _GroupManagePageWidgetState();
}

class _GroupManagePageWidgetState extends State<GroupManagePageWidget> {
  FileUtil fileUtil = const FileUtil("./group.json");

  TextButton createNewGroup(Map<String, dynamic> data) {
    return TextButton(
        onPressed: () {
          setState(() {
            data["새 그룹 ${data.length + 1}"] = [];

            fileUtil.writeFileJSON(data);
          });
        },
        child: const Text("새 그룹 추가"));
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

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
                    Map<String, dynamic> data = snapshot.data;

                    return Center(
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        heightFactor: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: data.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("생성된 그룹이 없습니다."),
                                      createNewGroup(data)
                                    ],
                                  ),
                                )
                              : ListView(
                                  shrinkWrap: true,
                                  children: [
                                    GroupWidget(data: data),
                                    createNewGroup(data),
                                  ],
                                ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text("로딩중..."),
                    );
                  }
                }),
          );
        } else {
          return const Center(
            child: Text("로딩중..."),
          );
        }
      },
    );
  }
}

class GroupWidget extends StatefulWidget {
  const GroupWidget({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  FileUtil fileUtil = const FileUtil("./group.json");

  @override
  Widget build(BuildContext context) {
    List<Widget> groupList = [];

    widget.data.forEach((key, value) {
      groupList.add(buildGroup(key, value));
    });

    return Column(children: groupList);
  }

  Widget buildGroup(String groupName, List<dynamic> memberList) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(groupName),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      TextEditingController renameTextController =
                          TextEditingController(text: groupName);

                      return AlertDialog(
                        content: SizedBox(
                          width: 300,
                          height: 75,
                          child: TextField(
                            controller: renameTextController,
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text("삭제"),
                            onPressed: () {
                              setState(() {
                                widget.data.remove(groupName);
                                fileUtil.writeFileJSON(widget.data);
                                Navigator.pop(context);
                              });
                            },
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("취소"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                widget.data[renameTextController.text] =
                                    widget.data[groupName];
                                widget.data.remove(groupName);

                                debugPrint("${widget.data}");

                                fileUtil.writeFileJSON(widget.data);

                                Navigator.pop(context);
                              });
                            },
                            child: const Text("변경"),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(
                Icons.edit,
                size: 15,
              ))
        ],
      ),
      children: [
        Column(
          children: [
            ...memberList
                .map((member) => Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ListTile(
                        title: Text(member.toString()),
                        trailing: IconButton(
                          onPressed: () {
                            buildRemoveMemberDialog(groupName, member);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                    ))
                .toList(),
            TextButton(
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
                                    widget.data[groupName]
                                        .add(int.parse(textController.text));
                                    fileUtil.writeFileJSON(widget.data);
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
                child: const Text("멤버 추가"))
          ],
        )
      ],
    );
  }

  Future<dynamic> buildRemoveMemberDialog(String groupName, int member) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: const SizedBox(
                width: 200,
                height: 75,
                child: Center(child: Text("이 멤버를 제거하시겠습니까?")),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("취소")),
                TextButton(
                  onPressed: () => setState(() {
                    // 멤버 제거
                    widget.data[groupName].remove(member);
                    fileUtil.writeFileJSON(widget.data);
                    Navigator.pop(context);
                  }),
                  child: const Text("제거"),
                ),
              ],
            ));
  }
}
