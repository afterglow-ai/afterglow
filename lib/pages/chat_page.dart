import 'package:audioplayers/audioplayers.dart';
import 'package:sendream/consts.dart';
import 'package:sendream/dify.dart';
import 'package:sendream/widgets/chatbubble.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sendream/widgets/contact_action_buttons.dart';
import 'package:sendream/widgets/contact_selector.dart';
import 'package:sendream/widgets/new_contact_form.dart';
import 'package:sendream/widgets/contact_preset_buttons.dart';
import 'package:sendream/widgets/contact_description_input.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
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
    final theme = Theme.of(context);
    return AnimatedSwitcher(
      duration: Durations.short4,
      child: navPageKey.currentState?.bg == 1 && globalDifyResponse != null
          ? Container(
              key: ValueKey(globalDifyResponse),
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ).copyWith(top: 24),
              constraints: BoxConstraints.expand(),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.colorScheme.primary, width: 8),
                ),
                color: Color(0xFFFFF0F0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  globalDifyResponse = null;
                                });
                              },
                              icon: Icon(Icons.close, color: Color(0xFFFF8B8B)),
                            ),
                            Spacer(),
                            SizedBox(width: 8),
                            FilledButton(
                              onPressed: () {},
                              child: Center(child: Text("放入回忆")),
                            ),
                          ],
                        ),
                        FutureBuilder(
                          future: globalDifyResponse,
                          builder: (context, snapshot) {
                            final data = snapshot.data;
                            if (data == null) {
                              return CircularProgressIndicator();
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (data.audioUrl != null)
                                    IconButton(
                                      onPressed: () {
                                        player.play(
                                          UrlSource(
                                            data.audioUrl!,
                                            mimeType: "audio/x-wav",
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.voice_chat),
                                    ),
                                  Text(data.message.toString()),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : navPageKey.currentState?.bg == 0
          ? Container(
              key: ValueKey(1),
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chatbubble(text: "信件正在派送！投喂薯条加速获取信件哦！"),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: SizedBox(
                      width: 302,
                      child: FilledButton(
                        onPressed: () {
                          navPageKey.currentState?.changeBg(1);
                        },
                        child: Center(child: Text("投喂薯条")),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : navPageKey.currentState?.bg == 2
          ? GestureDetector(
              key: ValueKey(2),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Chatbubble(
                      text: "我去放漂流瓶啦！漂流瓶送出后预计会在一到两天内收到回信！投喂薯条可以加速获取信件哦！",
                    ),
                  ],
                ),
              ),
              onTap: () {
                navPageKey.currentState?.changeBg(0);
              },
            )
          : !init
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
                            child: ContactActionButtons(
                              onNewContact: () {
                                setState(() {
                                  newContact = true;
                                  selectContact = false;
                                });
                              },
                              onSelectContact: () {
                                setState(() {
                                  newContact = false;
                                  selectContact = true;
                                });
                              },
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: Durations.short4,
                          child: Visibility(
                            key: ValueKey(selectContact),
                            visible: selectContact,
                            child: ContactSelector(
                              onNavBack: (_) =>
                                  navPageKey.currentState?.changeBg(2),
                              onBack: () {
                                setState(() {
                                  selectContact = false;
                                  newContact = false;
                                });
                              },
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
                          child: NewContactForm(
                            contactName: newContactName,
                            contactShort: newContactShort,
                            onBack: () {
                              setState(() {
                                selectContact = false;
                                newContact = false;
                              });
                            },
                            onCreate: () {
                              createNewContact();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedSwitcher(
                  duration: Durations.short4,
                  child: Visibility(
                    key: ValueKey(newContact && newContactName == null),
                    visible: newContact && newContactName == null,
                    child: ContactPresetButtons(
                      presets: presets,
                      onPresetSelected: (preset) {
                        setState(() {
                          newContactName = preset;
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      (newContactName != null && newContactShort == null) &&
                      (newContactShort?.isEmpty ?? true),
                  child: ContactDescriptionInput(
                    textController: textController,
                    contactName: newContactName,
                    onPresetContent: () {
                      setState(() {
                        newContactShort = "";
                      });
                      getPersonShort(newContactName.toString()).then((value) {
                        setState(() {
                          newContactShort = value;
                        });
                      });
                    },
                    onSubmit: (text) {
                      setState(() {
                        newContactShort = text;
                      });
                      textController.clear();
                      createNewContact();
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
