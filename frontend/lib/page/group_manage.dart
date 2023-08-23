import "package:flutter/material.dart";

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

    fileUtil.exists().then((exists) {
      if (!exists) {
        fileUtil.createFile("{}");
      }
    });

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
                                  return AlertDialog(
                                    content: const FractionallySizedBox(
                                        widthFactor: 1,
                                        heightFactor: 0.4,
                                        child: Center(
                                            child: Text("Hello, world!"))),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: const Text("확인")),
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: const Text("취소"))
                                    ],
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                  );
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
}
