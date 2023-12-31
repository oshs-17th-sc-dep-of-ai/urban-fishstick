import "package:flutter/material.dart";

import "package:frontend/util/diet.dart";

List diet = [];
List alrg = [];

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({super.key});

  @override
  State<MainPageWidget> createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(padding: EdgeInsets.all(50)),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "남은 대기 인원: nn",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: Divider(
            height: 1,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.black38,
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<Map>(
            future: diet.isEmpty
                ? getDiet()
                : Future(() => {"diet": diet, "alergy": alrg}),
            builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: snapshot.data?["diet"].length,
                    itemBuilder: (context, index) {
                      diet = snapshot.data?["diet"].toList();
                      alrg = snapshot.data?["alergy"].toList();

                      return SizedBox(
                        width: deviceSize.width - 20,
                        height: 30,
                        child: Text(diet[index]),
                      );
                    });
              } else {
                return const Center(
                  child: Text("Fetching Data..."),
                );
              }
            },
          ),
        ))
      ],
    );
  }
}
