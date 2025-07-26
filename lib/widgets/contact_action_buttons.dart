import 'package:flutter/material.dart';

class ContactActionButtons extends StatelessWidget {
  final VoidCallback onNewContact;
  final VoidCallback onSelectContact;

  const ContactActionButtons({
    super.key,
    required this.onNewContact,
    required this.onSelectContact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        FilledButton(
          onPressed: onNewContact,
          child: SizedBox(
            width: double.infinity,
            child: Center(child: Text("新建联系人")),
          ),
        ),
        SizedBox(height: 4),
        FilledButton(
          onPressed: onSelectContact,
          child: SizedBox(
            width: double.infinity,
            child: Center(child: Text("选择联系人")),
          ),
        ),
      ],
    );
  }
}
