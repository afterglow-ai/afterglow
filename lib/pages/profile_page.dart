import 'package:flutter/cupertino.dart';
import 'package:sendream/widgets/book_container.dart';
import 'package:flutter/material.dart';
import 'package:sendream/widgets/letter_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BookContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "用户",
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            subtitle: Text(
              "ID: ${Supabase.instance.client.auth.currentUser?.id}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("会员"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("反馈"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("设置"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text("Debug"),
            onTap: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => LetterContainer(name: "朋友", agentId: 1),
              ),
            ),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
