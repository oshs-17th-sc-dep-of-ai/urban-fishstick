import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:frontend/page/group_edit.dart";
import "package:frontend/popup/group_create.dart";

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
    final deviceSize = MediaQuery.of(context).size;

    return FutureBuilder(
      future: fileUtil.exists(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!(snapshot.data!)) {
            fileUtil.createFile("{}");
          }

          return Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: FutureBuilder(
                    future: fileUtil.readFileJSON(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data;

                        return Column(
                          children: [
                            ...(data.keys.map((e) {
                              final titleTextController =
                                  TextEditingController(text: e.toString());
                              final addMemberTextController =
                                  TextEditingController();

                              return ExpansionTile(
                                  title: TextField(
                                    controller: titleTextController,
                                  ),
                                  children: [
                                    ...(data[e] as List)
                                        .map((c) => Text(c))
                                        .toList(),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: SizedBox(
                                            height: 50,
                                            width: deviceSize.width - 50,
                                            child: IconButton.outlined(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AddMemberDialog(
                                                          addMemberTextController:
                                                              addMemberTextController,
                                                          data: data,
                                                          dataKey: e.toString(),
                                                          fileUtil: fileUtil,
                                                        );
                                                      });
                                                },
                                                icon: const Icon(Icons.add)),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]);
                            }).toList()),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: SizedBox(
                                height: 50,
                                width: deviceSize.width,
                                child: IconButton.outlined(
                                    onPressed: () {},
                                    icon: const Icon(Icons.add)),
                              ),
                            )
                          ],
                        );
                      } else {
                        return const Center(
                          child: Text("Loading group data file..."),
                        );
                      }
                    }),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text("Loading group data file..."),
          );
        }
      },
    );
  }
}

class AddMemberDialog extends StatelessWidget {
  const AddMemberDialog({
    super.key,
    required this.addMemberTextController,
    required this.data,
    required this.dataKey,
    required this.fileUtil,
  });

  final TextEditingController addMemberTextController;
  final Map<String, dynamic> data;
  final String dataKey;
  final FileUtil fileUtil;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: 75,
        child: TextField(
          controller: addMemberTextController,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("취소"),
        ),
        TextButton(
          onPressed: () {
            data.update(
                dataKey, (value) => int.parse(addMemberTextController.text));
            fileUtil.writeFileJSON(data);
            Navigator.pop(context);
          },
          child: const Text("추가"),
        )
      ],
    );
  }
}
