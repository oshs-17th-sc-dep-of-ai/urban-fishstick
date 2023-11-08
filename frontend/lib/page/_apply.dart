import "package:flutter/material.dart";
import "package:frontend/util/file.dart";

List<int> applyMemberList = [];

class ApplyPageWidget extends StatefulWidget {
  const ApplyPageWidget({super.key});

  @override
  State<ApplyPageWidget> createState() => _ApplyPageWidgetState();
}

class _ApplyPageWidgetState extends State<ApplyPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ApplyPageWidgetBody(),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.format_list_bulleted),
        onPressed: () {},
      ),
    );
  }
}

class ApplyPageWidgetBody extends StatefulWidget {
  ApplyPageWidgetBody({super.key});

  @override
  State<ApplyPageWidgetBody> createState() => _ApplyPageWidgetBodyState();
}

class _ApplyPageWidgetBodyState extends State<ApplyPageWidgetBody> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    FileUtil fileUtil = const FileUtil("./group.json");

    return Center(
      child: SizedBox(
        child: FutureBuilder(
            future: fileUtil.readFileJSON(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              final groupList = snapshot.data;

              return Column(
                children: [
                  buildApplyMemberList(
                      snapshot.connectionState == ConnectionState.done
                          ? groupList
                          : []),
                  buildLoadGroupButton(deviceSize),
                  buildApplyButton(),
                ],
              );
            }),
      ),
    );
  }

  ListView buildApplyMemberList(List groupList) {
    return ListView(
      children: [
        ...applyMemberList
            .map((member) => ListTile(
                  title: Text(member.toString()),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close),
                  ),
                ))
            .toList(),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        )
      ],
    );
  }

  Widget buildLoadGroupButton(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      height: 50,
      child: Row(
        children: [],
      ),
    );
  }

  Padding buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        child: const Text("신청"),
        onPressed: () {},
      ),
    );
  }
}
