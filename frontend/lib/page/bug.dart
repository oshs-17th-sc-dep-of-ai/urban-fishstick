import 'package:flutter/material.dart';

class BugPageWidget extends StatefulWidget {
  const BugPageWidget({super.key});

  @override
  State<BugPageWidget> createState() => _BugPageWidgetState();
}

class _BugPageWidgetState extends State<BugPageWidget> {
  final myController = TextEditingController();
  bool isSubmitButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        title: const Text(
          '건의/버그 제보',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        leadingWidth: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 80,
              child: ElevatedButton(
                onPressed: isSubmitButtonEnabled
                    ? () => _showSubmitDialog(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSubmitButtonEnabled ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '등록',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: 440,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '문의하기',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  hintText: '건의사항',
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 11,
                controller: myController,
                onChanged: (text) {
                  setState(() {
                    isSubmitButtonEnabled = text.isNotEmpty;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text("\n  의견 감사합니다!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void sendbug() {}
}
