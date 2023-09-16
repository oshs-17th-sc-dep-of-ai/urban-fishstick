import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:frontend/util/file.dart";

final tempMemberList = <int>[];

class GroupCreatePageWidget extends StatefulWidget {
  const GroupCreatePageWidget({super.key});

  @override
  State<GroupCreatePageWidget> createState() => _GroupCreatePageWidgetState();
}

class _GroupCreatePageWidgetState extends State<GroupCreatePageWidget> {
  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final textController = TextEditingController();
    const textDecoration = InputDecoration(
      hintText: "추가할 학생 학번 입력",
    );

    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.5,
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: ListView.builder(
                    itemCount: tempMemberList.length,
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                          title: Text(tempMemberList[index].toString()),
                        )),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextField(
                      decoration: textDecoration,
                      controller: textController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: IconButton.outlined(
                        onPressed: () {
                          if (textController.value.text.length == 5) {
                            setState(() {
                              tempMemberList
                                  .add(int.parse(textController.value.text));
                              scrollController.animateTo(
                                  scrollController.position.extentTotal,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn);
                            });
                          }
                        },
                        icon: const Icon(Icons.add)),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      child: IconButton.outlined(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          tempMemberList.clear();
                          Navigator.pop(context);
                        },
                      )),
                  const SizedBox(width: 5),
                  Flexible(
                      fit: FlexFit.tight,
                      child: IconButton.outlined(
                        icon: const Icon(Icons.done),
                        onPressed: () async {
                          const fileUtil = FileUtil("./group.json");

                          final fileData = await fileUtil.readFileJSON();
                          fileData.update(
                            ifAbsent: () => tempMemberList,
                            "temporary_group",
                            (value) => tempMemberList,
                          );

                          await fileUtil.writeFileJSON(fileData);

                          tempMemberList.clear();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
