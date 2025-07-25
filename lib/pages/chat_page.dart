import 'package:afterglow/fields.dart';
import 'package:afterglow/widgets/chatbubble.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ListView(
          padding: EdgeInsets.only(bottom: 80),
          reverse: true,
          children: [
            Chatbubble(text: "你好", isRtl: true),
            Chatbubble(
              text:
                  "欢迎来到 sendream！\n你是否有思念至极却又难以再见的人？\n我是神奇小鸥，写下你想对TA说的话，漂流瓶会帮你送达思念！",
              attachWidget: [
                SizedBox(height: 8),
                Row(
                  children: [
                    FilledButton(onPressed: () {}, child: Text("新建联系人")),

                    if (agents.isNotEmpty)
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 8),
                        child: FilledButton(
                          onPressed: () {},
                          child: Text("选择联系人"),
                        ),
                      ),
                  ],
                ),
                if (agents.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "选择联系人",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          ...agents.map(
                            (e) => Padding(
                              padding: EdgeInsets.all(2),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () {},
                                child: Container(
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(24),
                                    ),
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        e["name"] ?? "未知",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              child: Row(
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
                        style: TextStyle(color: Colors.black, fontSize: 15),
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
                    onPressed: () {},
                    icon: Icon(Icons.arrow_upward_rounded),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
