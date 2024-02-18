import "package:flutter/material.dart";

class LicensePageWidget extends StatefulWidget {
  const LicensePageWidget({super.key});

  @override
  State<LicensePageWidget> createState() => _LicensePageWidgetState();
}

class _LicensePageWidgetState extends State<LicensePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        title: const Text(
          '라이센스',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:30,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
        leadingWidth: 70,
      ),
    );
  }
  
}
