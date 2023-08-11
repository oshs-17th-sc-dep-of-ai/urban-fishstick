import "package:flutter/material.dart";

int currentPageIndex = 0;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = PageController(initialPage: currentPageIndex);

    void update() {
      setState(() {});
    }

    // TODO: PageView & BottomNavigationBar 상태 동기화 함수 작성 필요
    return MaterialApp(
        title: "오성고 급식 앱",
        home: Scaffold(
          body: Column(
            children: [
              Expanded(
                  child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPageIndex = index;
                  });
                  update();
                },
                children: const [
                  Center(
                    child: Text("Home"),
                  ),
                  Center(
                    child: Text("Individual"),
                  ),
                  Center(
                    child: Text("Group"),
                  ),
                  Center(
                    child: Text("Settings"),
                  ),
                ],
              ))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.blue,
              currentIndex: currentPageIndex,
              selectedItemColor: Colors.amber,
              unselectedItemColor: Colors.white12,
              onTap: (index) {
                setState(() {
                  currentPageIndex = index;
                });
                controller.jumpToPage(index);
                update();
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "individual"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.group), label: "group"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "settings"),
              ]),
        ));
  }
}