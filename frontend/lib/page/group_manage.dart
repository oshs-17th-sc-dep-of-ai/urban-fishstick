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

          fileUtil.writeFileJSON({
            "TestGroup1": [
              10001,
              10002,
              10003
            ],
            "TestGroup2": [
              20001,
              20002,
              20003
            ]
          }); // for test

          return Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
                future: fileUtil.readFileJSON(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data = snapshot.data;

                    debugPrint("$data");

                    return Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        heightFactor: 0.9,
                        child: Column(
                          children: [
                            GroupWidget(data: data,),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                          ],
                        ),
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
}

class GroupWidget extends StatelessWidget {
  const GroupWidget({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    List<Widget> groupList = [];

    data.forEach((key, value) {
      groupList.add(buildGroup(key, value));
    });

    return Column(children: groupList);
  }

  Widget buildGroup(String groupName, List<dynamic> memberList) {
    return ExpansionTile(
      title: Text(groupName),
      children: [
        Column(children: [
          ...memberList.map((member) =>
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(title: Text(member.toString())),
              )).toList(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.add))
        ],)
      ],);
  }
}
