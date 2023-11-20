import "package:flutter/material.dart";
import "package:frontend/util/file.dart";

Set<int> currentGroupMembers = {};

class ApplyPageWidget extends StatefulWidget {
  const ApplyPageWidget({super.key});

  @override
  State<ApplyPageWidget> createState() => _ApplyPageWidgetState();
}

class _ApplyPageWidgetState extends State<ApplyPageWidget> {
  FileUtil fileUtil = const FileUtil("./group.json");

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
                            child: ListView(
                              children: [
                                ...buildCurrentGroupMember(),
                                buildAddMemberButton(),
                                buildLoadGroupButton(),
                              ],
                            )),
                      ),
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

  TextButton buildLoadGroupButton() {
    return TextButton(
      child: const Text("그룹 불러오기"),
      onPressed: () {},
    );
  }

  IconButton buildAddMemberButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController textController = TextEditingController();

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
                          currentGroupMembers
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
    );
  }

  List<ListTile> buildCurrentGroupMember() {
    return currentGroupMembers
        .map((member) => ListTile(
              title: Text(member.toString()),
              trailing: IconButton(
                onPressed: () {
                  buildRemoveMemberDialog(member);
                },
                icon: const Icon(Icons.close),
              ),
            ))
        .toList();
  }

  dynamic buildRemoveMemberDialog(int member) {
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
                    currentGroupMembers.remove(member);
                    Navigator.pop(context);
                  }),
                  child: const Text("제거"),
                ),
              ],
            ));
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
      title: const Text("신청 인원 목록"),
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
            IconButton(
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
                icon: const Icon(Icons.add))
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
