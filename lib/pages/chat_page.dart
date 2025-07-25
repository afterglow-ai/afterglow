import 'dart:ui';

import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        ListView(
          padding: EdgeInsets.only(bottom: 80),
          reverse: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 8, top: 16, right: 16),
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.7,
                    minWidth: size.width * 0.1,
                    minHeight: 50,
                  ),
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ).copyWith(bottomLeft: Radius.circular(0)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(16),
                    child: Text(
                      "欢迎来到 sendream！\n你是否有思念至极却又难以再见的人？\n我是神奇小鸥，写下你想对TA说的话，漂流瓶会帮你送达思念！",
                      style: TextStyle(color: Colors.black),
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
              // height: 46,
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
