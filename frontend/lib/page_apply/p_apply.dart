import "package:flutter/material.dart";

List<int> _member = [];

class ApplyPageWidget extends StatefulWidget {
  const ApplyPageWidget({super.key});

  @override
  State<ApplyPageWidget> createState() => _ApplyPageWidgetState();
}

class _ApplyPageWidgetState extends State<ApplyPageWidget> {
  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelText: "학번 입력",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (textController.value.text != "") {
                          _member.add(textController.value.text as int);
                        }
                      });
                    },
                    icon: const Icon(Icons.add))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
