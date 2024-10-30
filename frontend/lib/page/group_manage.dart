import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:frontend/util/file.dart";

class GroupManagePageWidget extends StatefulWidget {
  const GroupManagePageWidget({super.key});

  @override
  State<GroupManagePageWidget> createState() => _GroupManagePageWidgetState();
}

class _GroupManagePageWidgetState extends State<GroupManagePageWidget> {
  FileUtil fileUtil = const FileUtil("./group.json");
  late Map<String, dynamic> data;

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

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: const Icon(
                Icons.group,
                color: Colors.black,
              ),
              title: const Text(
                "그룹 관리",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: FutureBuilder(
              future: fileUtil.readFileJSON(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  data = snapshot.data;

                  return Center(
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: data.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("생성된 그룹이 없습니다."),
                                  ],
                                ),
                              )
                            : ListView(
                                shrinkWrap: true,
                                children: [
                                  GroupWidget(data: data),
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
              },
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          if (!data.containsKey("새 그룹 ${data.length + 1}")) {
                            data["새 그룹 ${data.length + 1}"] = [];
                          } else {
                            List<String> newGroups = data.keys
                                .where((element) => element.startsWith("새 그룹 "))
                                .toList();
                            newGroups.sort((a, b) =>
                                int.parse(a.replaceRange(0, 5, "")).compareTo(
                                    int.parse(b.replaceRange(0, 5, ""))));

                            data["새 그룹 ${int.parse(newGroups.last.replaceRange(0, 5, "")) + 1}"] =
                                [];
                          }

                          fileUtil.writeFileJSON(data);
                        });
                      },
                      backgroundColor: const Color.fromARGB(255, 0, 120, 215),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
          SizedBox(
            child: IconButton(
              onPressed: () {
                setState(() {
                  widget.data.remove(groupName);
                  fileUtil.writeFileJSON(widget.data);
                });
              },
              icon: const Icon(Icons.close),
            ),
          ),
          Expanded(
            child: Text(groupName),
          ),
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
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    actions: [
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
                },
              );
            },
            icon: const Icon(
              Icons.edit,
              size: 15,
            ),
          ),
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
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
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
