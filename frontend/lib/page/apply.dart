import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:frontend/util/file.dart";

import 'package:frontend/dialog/group.dart';

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
            LimitedBox(
              maxHeight: 300,
              child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: _member
                      .map((member) => ListTile(
                            title: Text(member.toString()),
                          ))
                      .toList() // member 리스트 이용, 위젯 생성 필요
                  ),
            ),
            Column(
              children: [
                Row(
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty) return "학번을 입력해주세요.";
                          if ((value.length < 5) ||
                              (int.parse(value) < 10000) ||
                              (int.parse(value) > 39999)) {
                            // FIXME: 범위 검사 안됨?
                            return "올바른 학번을 입력해주세요.";
                          }
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
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: ((context) {
                                return const Dialog(
                                  child: GroupActionDialogWidget(),
                                );
                              }));
                          setState(() {});
                        },
                        child: const Text("그룹 메뉴"), // 다이얼로그로 넘어가서 그룹 불러오기/편집/삭제
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
