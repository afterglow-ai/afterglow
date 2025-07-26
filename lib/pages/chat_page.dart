import 'package:sendream/dify.dart';
import 'package:sendream/widgets/chatbubble.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool init = false;
  bool newContact = false;
  String? newContactName;
  bool lock = false;
  String? newContactShort;
  final textController = TextEditingController();

  bool selectContact = false;

  List<String> presets = ["奶奶", "爷爷", "朋友"];

  void createNewContact() async {
    if (lock) {
      return;
    }
    lock = true;
    await Supabase.instance.client
        .from("agents")
        .insert({
          "name": newContactName,
          "prompt": newContactShort,
          "user_id": Supabase.instance.client.auth.currentUser?.id,
        })
        .then((value) {
          setState(() {
            newContact = false;
            newContactName = null;
            newContactShort = null;
          });
        });
    lock = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedSwitcher(
      duration: Durations.short4,
      child: !init
          ? GestureDetector(
              child: Container(color: Colors.transparent),
              onTap: () {
                setState(() {
                  init = true;
                });
              },
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  padding: EdgeInsets.only(bottom: 80),
                  children: [
                    SizedBox(height: size.height * 0.15),
                    Chatbubble(
                      text:
                          "欢迎来到 sendream！\n你是否有思念至极却又难以再见的人？\n我是神奇小鸥，写下你想对TA说的话，漂流瓶会帮你送达思念！",
                      attachWidget: [
                        AnimatedSwitcher(
                          duration: !newContact && !selectContact
                              ? Duration()
                              : Durations.short4,
                          child: Visibility(
                            key: ValueKey(!newContact && !selectContact),
                            visible: !newContact && !selectContact,
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                FilledButton(
                                  onPressed: () {
                                    setState(() {
                                      newContact = true;
                                      selectContact = false;
                                    });
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Center(child: Text("新建联系人")),
                                  ),
                                ),
                                SizedBox(height: 4),
                                FilledButton(
                                  onPressed: () {
                                    setState(() {
                                      newContact = false;
                                      selectContact = true;
                                    });
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Center(child: Text("选择联系人")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: Durations.short4,
                          child: Visibility(
                            key: ValueKey(selectContact),
                            visible: selectContact,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: FutureBuilder(
                                      future: Supabase.instance.client
                                          .from("agents")
                                          .select(),
                                      builder: (context, snapshot) {
                                        final data = snapshot.data;

                                        if (data?.isEmpty ?? true) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "选择联系人",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            ...data!.map(
                                              (e) => Padding(
                                                padding: EdgeInsets.all(2),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                  onTap: () {},
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: ShapeDecoration(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadiusGeometry.circular(
                                                              24,
                                                            ),
                                                      ),
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              vertical: 4,
                                                            ),
                                                        child: Text(
                                                          e["name"] ?? "未知",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                FilledButton(
                                  onPressed: () {
                                    setState(() {
                                      selectContact = false;
                                      newContact = false;
                                    });
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Center(child: Text("返回上一步")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedSwitcher(
                        duration: Durations.short4,
                        child: Visibility(
                          key: ValueKey(newContact),
                          visible: newContact,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.7,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Chatbubble(text: "好的，现在让小鸥先了解一下你想给谁送信！Ta是谁？"),
                                SizedBox(height: 8),
                                Visibility(
                                  visible: newContactName == null,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: FilledButton(
                                      onPressed: () {
                                        setState(() {
                                          selectContact = false;
                                          newContact = false;
                                        });
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Center(child: Text("返回上一步")),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: newContactName != null,
                      child: Column(
                        children: [
                          Chatbubble(
                            text: "Ta 是我的 $newContactName",
                            isRtl: true,
                          ),
                          Chatbubble(text: "用一段话描述一下Ta吧！"),
                        ],
                      ),
                    ),

                    Visibility(
                      visible:
                          newContactShort != null &&
                          newContactShort!.isNotEmpty,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chatbubble(text: "$newContactShort", isRtl: true),
                          Chatbubble(
                            text:
                                "好的，已经收到你的描述，这里有一张神奇信纸，给ta写下你想对ta说的话吧！如果你上传音色音频，有可能获得语音回复哦！（语音回信为会员服务，暂未开放）！",
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ).copyWith(top: 8),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: size.width * 0.7,
                              ),
                              child: FilledButton(
                                onPressed: () {
                                  createNewContact();
                                  setState(() {});
                                },
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Center(child: Text("创建")),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: Durations.short4,
                  child: Visibility(
                    key: ValueKey(newContact && newContactName == null),
                    visible: newContact && newContactName == null,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 33,
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          children: presets
                              .map(
                                (e) => Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 4,
                                  ),
                                  child: FilledButton(
                                    onPressed: () {
                                      setState(() {
                                        newContactName = e;
                                      });
                                    },
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      (newContactName != null && newContactShort == null) &&
                      (newContactShort?.isEmpty ?? true),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              newContactShort = "";
                            });
                            getPersonShort(newContactName.toString()).then((
                              value,
                            ) {
                              setState(() {
                                newContactShort = value;
                              });
                            });
                          },
                          child: Text("预设内容"),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: TextField(
                                  controller: textController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  cursorColor: Colors.black38,
                                  decoration: InputDecoration(
                                    hintText: "输入内容",
                                    hintStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            IconButton.filled(
                              onPressed: () {
                                if (textController.text.isEmpty) {
                                  return;
                                }

                                setState(() {
                                  newContactShort = textController.text;
                                });

                                textController.clear();

                                createNewContact();
                              },
                              icon: Icon(Icons.arrow_upward_rounded),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
