import "package:flutter/material.dart";

List<String> _member = [];

class ApplyPageWidget extends StatelessWidget {
  const ApplyPageWidget({super.key});

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
                  .map((m) => ListTile(
                        title: Text(m),
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
                      if (textController.value.text != "") {
                        _member.add(textController.value.toString());
                      }
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
