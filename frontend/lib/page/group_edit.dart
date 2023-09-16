import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:frontend/util/file.dart";

List tempMember = [];

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

                      tempMember = data;

                      return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            ...data
                                .map((e) => Card(
                                      child: ListTile(
                                        title: Text(e.toString()),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            setState(() {
                                              data.remove(e);
                                            });
                                          },
                                        ),
                                      ),
                                    ))
                                .toList(),
                            Card(
                              // TODO: 배경 색 변경
                              child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  final formKey = GlobalKey<FormState>();
                                  final textController =
                                      TextEditingController();
                                  var inputDecorator = const InputDecoration(
                                    hintText: "학번 입력",
                                    counterText: '',
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddMemberDialogWidget(
                                          formKey: formKey,
                                          textController: textController,
                                          inputDecorator: inputDecorator,
                                          fileUtil: fileUtil);
                                    },
                                  ).whenComplete(() => setState(() {}));
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

class AddMemberDialogWidget extends StatelessWidget {
  const AddMemberDialogWidget({
    super.key,
    required this.formKey,
    required this.textController,
    required this.inputDecorator,
    required this.fileUtil,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final InputDecoration inputDecorator;
  final FileUtil fileUtil;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: 50,
        child: Center(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: TextFormField(
                  controller: textController,
                  maxLength: 5,
                  decoration: inputDecorator,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "학번을 입력해주세요.";
                    }
                    if (value.length < 5) {
                      return "올바른 학번을 입력해주세요.";
                    }
                    if (int.parse(value) < 10000) {
                      return "올바른 학번을 입력해주세요.";
                    }
                    if (int.parse(value) > 39999) {
                      return "올바른 학번을 입력해주세요.";
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("취소"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("추가"),
          onPressed: () {
            tempMember.add(int.parse(textController.text));
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
