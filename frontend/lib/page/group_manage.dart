import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:frontend/popup/group_create.dart";

import "package:frontend/util/file.dart";

class GroupManagePageWidget extends StatefulWidget {
  const GroupManagePageWidget({super.key});

  @override
  State<GroupManagePageWidget> createState() => _GroupManagePageWidgetState();
}

class _GroupManagePageWidgetState extends State<GroupManagePageWidget> {
  final popupActions = <Dialog>[];

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
                                            builder: (BuildContext context) =>
                                                item);
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return [
                                          PopupMenuItem(child: Text("Edit")),
                                          PopupMenuItem(child: Text("Delete")),
                                        ];
                                      },
                                    ))))
                            .toList(),
                        IconButton.outlined(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GroupCreatePageWidget()));
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
}
