import "package:flutter/material.dart";

class BugPageWidget extends StatefulWidget {
  const BugPageWidget({super.key});

  @override
  State<BugPageWidget> createState() => _BugPageWidgetState();
}

class _BugPageWidgetState extends State<BugPageWidget> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20), hintText: '건의사항'),
              controller: myController,
            )),
        FloatingActionButton(
            child: Text("제출"),
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: Text("의견 감사합니다!"));
                }))
      ],
    );
  }
}
