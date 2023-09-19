import "package:flutter/material.dart";

class SettingsPageWidget extends StatelessWidget {
  const SettingsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: deviceSize.width,
                height: deviceSize.height * 0.09,
                color: Colors.red,
                child: const Center(
                  child: Text(
                    "알레르기",
                  ),
                ),
              ),
              Container(
                width: deviceSize.width,
                height: deviceSize.height * 0.09,
                color: Colors.blue,
                child: const Center(
                  child: Text(
                    "건의/버그",
                  ),
                ),
              ),
              Container(
                width: deviceSize.width,
                height: deviceSize.height * 0.09,
                color: Colors.pink,
                child: const Center(
                  child: Text(
                    "라이센스",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
