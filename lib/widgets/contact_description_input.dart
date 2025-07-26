import 'package:flutter/material.dart';

class ContactDescriptionInput extends StatelessWidget {
  final TextEditingController textController;
  final String? contactName;
  final VoidCallback onPresetContent;
  final Function(String) onSubmit;

  const ContactDescriptionInput({
    super.key,
    required this.textController,
    required this.contactName,
    required this.onPresetContent,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton(
            onPressed: () {
              onPresetContent();
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
                onPressed: () {
                  if (textController.text.isEmpty) {
                    return;
                  }
                  onSubmit(textController.text);
                },
                icon: Icon(Icons.arrow_upward_rounded),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
