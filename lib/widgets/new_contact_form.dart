import 'package:flutter/material.dart';
import 'package:sendream/widgets/chatbubble.dart';

class NewContactForm extends StatelessWidget {
  final String? contactName;
  final String? contactShort;
  final VoidCallback onBack;
  final VoidCallback onCreate;

  const NewContactForm({
    super.key,
    required this.contactName,
    required this.contactShort,
    required this.onBack,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // 询问联系人名称的部分
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width * 0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chatbubble(text: "好的，现在让小鸥先了解一下你想给谁送信！Ta是谁？"),
                SizedBox(height: 8),
                Visibility(
                  visible: contactName == null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: FilledButton(
                      onPressed: onBack,
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

        // 显示选择的联系人名称和询问描述
        Visibility(
          visible: contactName != null,
          child: Column(
            children: [
              Chatbubble(text: "Ta 是我的 $contactName", isRtl: true),
              Chatbubble(text: "用一段话描述一下Ta吧！"),
            ],
          ),
        ),

        // 显示描述和创建按钮
        Visibility(
          visible: contactShort != null && contactShort!.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chatbubble(text: "$contactShort", isRtl: true),
              Chatbubble(
                text:
                    "好的，已经收到你的描述，这里有一张神奇信纸，给ta写下你想对ta说的话吧！如果你上传音色音频，有可能获得语音回复哦！（语音回信为会员服务，暂未开放）！",
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24).copyWith(top: 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: size.width * 0.7),
                  child: FilledButton(
                    onPressed: onCreate,
                    child: SizedBox(
                      width: double.infinity,
                      child: Center(child: Text("写信")),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
