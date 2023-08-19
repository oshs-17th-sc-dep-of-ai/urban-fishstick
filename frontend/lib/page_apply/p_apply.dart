import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:frontend/util/file.dart";

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
    final _formKey = GlobalKey<FormState>();
    final textController = TextEditingController();
    var inputDecorator = const InputDecoration(
      hintText: "학번 입력",
      counterText: '',
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: _member
                  .map((member) => ListTile(
                        title: Text(member.toString()),
                      ))
                  .toList(), // member 리스트 이용, 위젯 생성 필요
            ),
          ),
          Center(
            child: Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Form(
                        key: _formKey,
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
                              final formKeyState = _formKey.currentState!;
                              if (formKeyState.validate()) formKeyState.save();

                              _member.add(int.parse(textController.value.text));
                            });
                          },
                          icon: const Icon(Icons.add))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text("그룹 메뉴"),
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
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
