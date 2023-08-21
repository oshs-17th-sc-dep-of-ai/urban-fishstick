import "package:flutter/material.dart";

import "package:frontend/util/file.dart";

List<int> group = [];

class GroupActionDialogWidget extends StatefulWidget {
  const GroupActionDialogWidget({super.key});

  @override
  State<GroupActionDialogWidget> createState() =>
      _GroupActionDialogWidgetState();
}

class _GroupActionDialogWidgetState extends State<GroupActionDialogWidget> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    const fileUtil = FileUtil("group.json");

    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [], // group
              // children: (fileUtil.readFileJSON() as List).map((e) {
              //   return ListTile(
              //     title: Text(e),
              //   );
              // }).toList(),
            ),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: null, icon: Icon(Icons.file_open_outlined)),
              IconButton(onPressed: null, icon: Icon(Icons.save_as_outlined)),
              IconButton(onPressed: null, icon: Icon(Icons.delete_outline))
            ],
          )
        ],
      ),
    );
  }
}
