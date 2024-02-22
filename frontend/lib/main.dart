import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:frontend/page/apply.dart';
import 'package:frontend/page/group_manage.dart';
import 'package:frontend/page/main.dart';
import 'package:frontend/page/settings.dart';

int currentPageIndex = 0;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((v) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom;
    final controller = PageController(initialPage: currentPageIndex);

    void update() {
      setState(() {});
    }

    return MaterialApp(
        title: "오성고 급식 앱",
        home: Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Column(
            children: [buildPageView(controller, update)],
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                height: 0.1,
                color: Colors.grey,
              ),
              buildBottomNavigationBar(controller, update),
            ],
          ),
        ));
  }

  BottomNavigationBar buildBottomNavigationBar(
      PageController controller, void Function() update) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: currentPageIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        elevation: 0,
        selectedIconTheme: const IconThemeData(size: 30),
        unselectedIconTheme: const IconThemeData(size: 24),
        selectedFontSize: 13,
        unselectedFontSize: 12,
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
          controller.jumpToPage(index);
          update();
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "신청"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "그룹 관리"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
        ]);
  }

  Expanded buildPageView(PageController controller, void Function() update) {
    return Expanded(
        child: PageView(
      controller: controller,
      onPageChanged: (index) {
        setState(() {
          currentPageIndex = index;
        });
        update();
      },
      children: const [
        MainPageWidget(),
        ApplyPageWidget(),
        GroupManagePageWidget(),
        SettingsPageWidget(),
      ],
    ));
  }
}
