import "package:flutter/material.dart";
import "package:frontend/page/allergy.dart";
import "package:frontend/page/license.dart";
import "package:frontend/page/bug.dart";

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
            crossAxisAlignment: CrossAxisAlignment.stretch, //우찬아 힘내
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(deviceSize.width, deviceSize.height * 0.09),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const AllergyPageWidget(),
                    ),
                  );
                },
                child: const Text("알레르기"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(deviceSize.width, deviceSize.height * 0.09),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const BugPageWidget(),
                    ),
                  );
                },
                child: const Text("건의/버그"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(deviceSize.width, deviceSize.height * 0.09),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const LicensePageWidget(),
                    ),
                  );
                },
                child: const Text("라이센스"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
