import 'package:flutter/material.dart';

class Chatbubble extends StatelessWidget {
  final String text;
  final bool isRtl;
  final List<Widget> attachWidget;
  const Chatbubble({
    super.key,
    required this.text,
    this.isRtl = false,
    this.attachWidget = const [],
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 24, top: 16, right: 24),
        child: Column(
          crossAxisAlignment: isRtl
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.7,
                minHeight: 50,
              ),
              decoration: ShapeDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16).copyWith(
                    bottomLeft: isRtl
                        ? Radius.circular(16)
                        : Radius.circular(0),
                    bottomRight: isRtl
                        ? Radius.circular(0)
                        : Radius.circular(16),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Text(text, style: TextStyle(color: Colors.black)),
              ),
            ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: size.width * 0.7),
              child: Column(children: attachWidget),
            ),
          ],
        ),
      ),
    );
  }
}
