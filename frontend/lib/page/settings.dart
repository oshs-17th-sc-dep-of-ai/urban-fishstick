import "package:flutter/material.dart";
import "package:frontend/page/allergy.dart";
import "package:frontend/page/license.dart";
import "package:frontend/page/bug.dart";
import "package:frontend/page/beacon_test.dart";

class SettingsPageWidget extends StatelessWidget {
  const SettingsPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
          title: const Text(
            '설정',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch, //우찬아 힘?내
            children: <Widget>[
              buildSettingMenuButton(
                  "알레르기", const AllergyPageWidget(), context),
              buildSettingMenuButton("건의/버그", const BugPageWidget(), context),
              buildSettingMenuButton(
                  "라이센스", const LicensePageWidget(), context),
              buildSettingMenuButton("비콘 테스트", const BeaconTestPageWidget(), context),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buildSettingMenuButton(
      String title, Widget destinationPage, BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: Size(deviceSize.width, deviceSize.height * 0.09),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => destinationPage,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}
