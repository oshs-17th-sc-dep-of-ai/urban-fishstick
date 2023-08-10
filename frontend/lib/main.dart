import "package:flutter/material.dart";

int currentPageIndex = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = PageController(initialPage: currentPageIndex);

    // TODO: PageView & BottomNavigationBar 상태 동기화 함수 작성 필요
    return MaterialApp(
      title: "오성고 급식 앱",
      home: Scaffold(
        body: Column(
          children: [
            PageViewWidget(controller: controller, )
          ],
        ),
        bottomNavigationBar: const NavigationBarWidget(),
      )
    );
  }
}

class PageViewWidget extends StatelessWidget {
  const PageViewWidget({
    super.key,
    required this.controller,
    // required this.synchronizer
  });

  final PageController controller;
  // final void Function(int)? synchronizer;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: controller,
        // onPageChanged: synchronizer,
        children: [
          Center(child: Text("Home"),),
          Center(child: Text("Individual"),),
          Center(child: Text("Group"),),
          Center(child: Text("Settings"),),
        ],
      ),
    );
  }
}

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidget();
}

class _NavigationBarWidget extends State<NavigationBarWidget> {
  void _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blue,
      currentIndex: currentPageIndex,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.white12,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "home"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "individual"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: "group"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "settings"
        )
      ]
    );
  }
}