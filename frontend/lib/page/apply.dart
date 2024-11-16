import "dart:convert";
import "dart:isolate";
import "dart:developer" as developer;

import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:frontend/main.dart";
import "package:frontend/util/file.dart";
import "package:frontend/util/network.dart";
import "package:frontend/util/queue_updater.dart";
import "package:frontend/util/beacon.dart";
import "package:frontend/util/notification.dart";

List currentMemberList = [];
Isolate? queueUpdater;

class ApplyPageWidget extends StatefulWidget {
  const ApplyPageWidget({super.key});

  @override
  State<ApplyPageWidget> createState() => ApplyPageWidgetState();
}

class ApplyPageWidgetState extends State<ApplyPageWidget> {
  final receivePort = ReceivePort();

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

  FloatingActionButton buildApplyButton() {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.black,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                width: 200,
                height: 100,
                child: Center(
                  child: Text("신청하시겠습니까?"),
                ),
              ),
              actions: [
                applyButtonFunction(context),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("취소"),
                ),
              ],
            );
          },
        );
      },
      child: const Icon(
        Icons.check,
        color: Colors.white,
      ),
    );
  }

  TextButton applyButtonFunction(BuildContext context) {
    return TextButton(
        onPressed: () async {
          // Connection Refused 발생 시 서버 실행 확인 후 adb reverse tcp:8720 tcp:8720 실행
          try {
            if (currentMemberList.isEmpty) {
              FNotification.showNotification("신청결과", "학번이 없습니다.");
              return;
            }

            final registerResponse = await httpPost(
                "http://223.130.151.247:8720/group/register", // TODO: 서버 주소 변경
                jsonEncode(currentMemberList));

            if (registerResponse == 200) {
              queueUpdater =
                  await Isolate.spawn(checkQueuePositionWithPolling, {
                "token": rootIsolateToken,
                "student_id": 10009 // FIXME: 하드코딩된 값(10009) 변경
              });

              BeaconUtil().startScan();
              FNotification.showNotification("신청 결과", "신청이 완료되었습니다.");
            } else {
              FNotification.showNotification("신청 결과", '신청에 실패했습니다.');
            }
          } catch (e) {
            FNotification.showNotification("신청결과", "오류발생: $e");
            developer.log("error: $e");
          }

          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: const Text("예"));
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
              // 멤버 리스트가 비어있을 경우
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
              // 멤버 리스트가 비어있지 않을 경우
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
                        autofocus: true,
                        controller: textController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
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
