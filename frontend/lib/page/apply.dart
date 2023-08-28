import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:frontend/popup/group_select.dart';

import "package:frontend/util/file.dart";

import "package:frontend/page/group_manage.dart";

List<int> _member = [];

class ApplyPageWidget extends StatefulWidget {
  const ApplyPageWidget({super.key});

  @override
  State<ApplyPageWidget> createState() => _ApplyPageWidgetState();
}

class _ApplyPageWidgetState extends State<ApplyPageWidget> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    final textController = TextEditingController();
    final scrollController = ScrollController();
    var inputDecorator = const InputDecoration(
      hintText: "학번 입력",
      counterText: '',
    );

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.6,
        heightFactor: 0.8,
        child: Column(
          children: [
            buildMemberList(scrollController),
            Column(
              children: [
                buildForm(
                    formKey, textController, inputDecorator, scrollController),
                const SizedBox(height: 10),
                buildButtons(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row buildButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           const GroupSelectPageWidget()),
              // );
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    const fileUtil = FileUtil("./group.json");

                    return AlertDialog(
                      content: SizedBox(
                        // TODO: 위젯 추가로 크기 조절 필요?
                        width: 50,
                        height: 100,
                        child: FutureBuilder(
                          future: fileUtil.readFileJSON(),
                          builder: (BuildContext context,
                              AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const Center(
                                  child: Text("Loading group file..."));
                            }
                            final keys = snapshot.data?.keys.toList();

                            return ListView.builder(
                                itemCount: keys?.length,
                                itemBuilder: (context, index) {
                                  debugPrint("$keys, $index");
                                  return ListTile(
                                    subtitle: Text(keys?[index]),
                                  );
                                });
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("취소"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }); // 그룹 리스트에서 하나 클릭하면 파일에서 읽고 불러오기
            },
            child: const Text("불러오기"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text("신청")),
        ),
      ],
    );
  }

  Row buildForm(
      GlobalKey<FormState> formKey,
      TextEditingController textController,
      InputDecoration inputDecorator,
      ScrollController scrollController) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: Form(
          key: formKey,
          child: TextFormField(
            controller: textController,
            maxLength: 5,
            decoration: inputDecorator,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value!.isEmpty) return "학번을 입력해주세요.";
              if (value.length < 5) return "올바른 학번을 입력해주세요.";
              if (int.parse(value) < 10000) return "올바른 학번을 입력해주세요.";
              if (int.parse(value) > 39999) return "올바른 학번을 입력해주세요.";
            },
          ),
        )),
        IconButton(
            onPressed: () {
              setState(() {
                final formKeyState = formKey.currentState!;
                if (formKeyState.validate()) formKeyState.save();

                _member.add(int.parse(textController.value.text));
              });
              scrollController.animateTo(scrollController.position.extentTotal,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn);
            },
            icon: const Icon(Icons.add))
      ],
    );
  }

  SizedBox buildMemberList(ScrollController scrollController) {
    return SizedBox(
      height: 300,
      child: LimitedBox(
        maxHeight: 300,
        child: ListView(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: _member
                .map((member) => ListTile(
                      title: Text(member.toString()),
                    ))
                .toList() // member 리스트 이용, 위젯 생성 필요
            ),
      ),
    );
  }
}
