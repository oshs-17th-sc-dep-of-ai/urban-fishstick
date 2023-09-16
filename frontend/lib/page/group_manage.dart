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

          return Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
                future: fileUtil.readFileJSON(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data;
                    return buildGroupList(data, context, fileUtil);
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

  ListView buildGroupList(data, BuildContext context, FileUtil fileUtil) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        ...(data as Map)
            .keys
            .map((e) => Card(
                child: ListTile(
                    title: Text(e.toString()),
                    trailing: PopupMenuButton(
                      onSelected: (dynamic item) {
                        // TODO: 선택 시 동작 구현
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => item);
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: const Text("편집"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroupEditPageWidget(
                                          selectedGroup: e.toString())));
                            },
                          ),
                          PopupMenuItem(
                            child: const Text("삭제"),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return buildDeleteDialog(
                                        context, data, e, fileUtil);
                                  });
                            },
                          ),
                        ];
                      },
                    ))))
            .toList(),
        IconButton.outlined(
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GroupCreatePageWidget()))
                .whenComplete(() => setState(() {}));
            // setState(() {});
          },
          icon: const Icon(Icons.add),
        )
      ],
    );
  }

  AlertDialog buildDeleteDialog(
      BuildContext context, Map<dynamic, dynamic> data, e, FileUtil fileUtil) {
    return AlertDialog(
      content: const SizedBox(
        width: 75,
        height: 50,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("삭제하시겠습니까?"),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("아니오")),
        TextButton(
          onPressed: () {
            setState(() {
              data.remove(e);
              fileUtil.writeFileJSON(data);
              Navigator.pop(context);
            });
          },
          child: const Text("예"),
        )
      ],
    );
  }
}
