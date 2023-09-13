import "package:flutter/material.dart";

import "package:frontend/util/file.dart";

class GroupEditPageWidget extends StatefulWidget {
  const GroupEditPageWidget({
    super.key,
    required this.selectedGroup,
  });

  final String selectedGroup;

  @override
  State<GroupEditPageWidget> createState() => _GroupEditPageWidgetState();
}

class _GroupEditPageWidgetState extends State<GroupEditPageWidget> {
  @override
  Widget build(BuildContext context) {
    const fileUtil = FileUtil("./group.json");

    final selectedGroup = widget.selectedGroup;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: FutureBuilder(
                  future: fileUtil.readFileJSON(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      List data = snapshot.data[selectedGroup];

                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            ...(data
                                .map((e) => Card(
                                      child: ListTile(
                                        title: Text(e.toString()),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ))
                                .toList()),
                            Card(
                              // TODO: 배경 색 변경
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog();
                                      });
                                },
                              ),
                            ),
                          ]);
                    } else {
                      return const Text("Loading group data...");
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
