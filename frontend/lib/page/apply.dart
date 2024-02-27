import "package:flutter/material.dart";
import "package:flutter_client_sse/constants/sse_request_type_enum.dart";
import "package:frontend/util/file.dart";
import "package:frontend/util/network.dart";
import "package:frontend/util/notification.dart";
import "package:flutter_client_sse/flutter_client_sse.dart";

List currentMemberList = [];

class ApplyPageWidget extends StatefulWidget {
  const ApplyPageWidget({super.key});

  @override
  State<ApplyPageWidget> createState() => ApplyPageWidgetState();
}

class ApplyPageWidgetState extends State<ApplyPageWidget> {
  @override
  Widget build(BuildContext context) {
    const fileUtil = FileUtil("./group.json");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        title: const Text(
          '신청',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
          future: fileUtil.exists(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              bool exists = snapshot.data!;

              if (!exists) {
                fileUtil.createFile("{}").whenComplete(() {
                  exists = true;
                });
              }
              return const Padding(
                padding: EdgeInsets.all(12),
                child: ApplyPageWidgetBody(),
              );
            } else {
              return const Center(
                child: Text("그룹 데이터 확인중..."),
              );
            }
          }),
      floatingActionButton: buildApplyButton(),
    );
  }

  IconButton buildApplyButton() {
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String message = "";

            return AlertDialog(
              content: const SizedBox(
                width: 200,
                height: 100,
                child: Center(
                  child: Text("신청하시겠습니까?"),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      // await httpPost("", currentMemberList.toString());
                      // Connection Refused 발생 시 adb reverse tcp:8720 tcp:8720 실행

                      SSEClient.subscribeToSSE(
                        method: SSERequestType.GET,
                        url: "http://localhost:8720/group/index/sse",
                        header: {
                          "Accept": "text/event-stream",
                          "Cache-Control": "no-cache"
                        },
                      ).listen((event) {
                        debugPrint("id: ${event.id}");
                        debugPrint("event: ${event.event}");
                        debugPrint("data: ${event.data}");
                      });
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("예")),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("취소"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class ApplyPageWidgetBody extends StatefulWidget {
  const ApplyPageWidgetBody({super.key});

  @override
  State<ApplyPageWidgetBody> createState() => _ApplyPageWidgetBodyState();
}

class _ApplyPageWidgetBodyState extends State<ApplyPageWidgetBody> {
  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return SizedBox(
      width: deviceSize.width,
      height: deviceSize.height,
      child: currentMemberList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("목록이 비어있습니다."),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildLoadGroupButton(),
                      buildStudentIDInput(context),
                    ],
                  )
                ],
              ),
            )
          : ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              children: [
                ...buildMemberList(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  buildLoadGroupButton(),
                  buildStudentIDInput(context),
                ]),
              ],
            ),
    );
  }

  FutureBuilder buildLoadGroupButton() {
    const fileUtil = FileUtil("./group.json");
    return FutureBuilder(
        future: fileUtil.readFileJSON(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> groups = snapshot.data;

            return TextButton(
              child: const Text("그룹 불러오기"),
              onPressed: () {
                String selectedGroup = "";

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (groups.keys.isEmpty) {
                        return AlertDialog(
                          content: const SizedBox(
                            width: 300,
                            height: 75,
                            child: Center(
                              child: Text("생성된 그룹이 없습니다."),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("확인"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        );
                      } else {
                        return StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            title: Text(
                                "선택된 그룹: ${selectedGroup.isEmpty ? "없음" : selectedGroup}"),
                            titleTextStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                            ),
                            content: SizedBox(
                              width: 300,
                              height: 200,
                              child: ListView(
                                children: groups.keys
                                    .map((key) => ListTile(
                                          title: Text(key),
                                          onTap: () {
                                            setState(() {
                                              selectedGroup = key;
                                            });
                                          },
                                        ))
                                    .toList(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text("취소"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    currentMemberList = groups[selectedGroup];
                                  });
                                  Navigator.pop(context);
                                  update();
                                },
                                child: const Text("불러오기"),
                              )
                            ],
                          );
                        });
                      }
                    });
              },
            );
          } else {
            return const Text("그룹 정보를 불러오는 중입니다...");
          }
        });
  }

  TextButton buildStudentIDInput(BuildContext context) {
    return TextButton(
        child: const Text("학번 추가"),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController textController = TextEditingController();

                return AlertDialog(
                  content: SizedBox(
                    width: 300,
                    height: 75,
                    child: Center(
                        child: TextField(
                      controller: textController,
                    )),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("취소"),
                    ),
                    TextButton(
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          setState(() {
                            currentMemberList
                                .add(int.parse(textController.text));
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text("추가"),
                    ),
                  ],
                );
              });
        });
  }

  List<ListTile> buildMemberList() {
    return currentMemberList
        .map((e) => ListTile(
              title: Text(e.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    currentMemberList.remove(e);
                  });
                },
              ),
            ))
        .toList();
  }
}
