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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        title: const Text(
          '건의/버그 제보',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        leadingWidth: 70,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20), hintText: '건의사항'),
                controller: myController,
                maxLines: null,
              )),
          FloatingActionButton(
              child: const Text("제출"),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text("의견 감사합니다!"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("확인"),
                        )
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}
