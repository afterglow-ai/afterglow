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
