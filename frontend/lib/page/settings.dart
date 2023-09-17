import "package:flutter/material.dart";

class SettingsPageWidget extends StatelessWidget {
  const SettingsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: 700,
                height: 100,
                color: Colors.red,
                child: const Text(
                  "알레르기",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 700,
                height: 100,
                color: Colors.blue,
                child: const Text(
                  "건의/버그",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: 700,
                height: 100,
                color: Colors.pink,
                child: const Text(
                  "라이센스",
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
