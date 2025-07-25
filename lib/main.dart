import 'dart:io';

import 'package:afterglow/fields.dart';
import 'package:afterglow/pages/chat_page.dart';
import 'package:afterglow/pages/memory_page.dart';
import 'package:afterglow/pages/profile_page.dart';
import 'package:afterglow/widgets/navbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rnawadrbuzmcdwacourg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJuYXdhZHJidXptY2R3YWNvdXJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzMzg4NjYsImV4cCI6MjA2ODkxNDg2Nn0.BlbtSbYmfVw0yjC7bsBb6sar-0twO8y34lsY1xkzGmc',
  );
  final auth = Supabase.instance.client.auth;
  auth.headers["X-Supabase-Client-Platform-Version"] = "client";

  if (auth.currentUser == null) {
    await auth.signInAnonymously();
  }
  agents.addAll(await Supabase.instance.client.from("agents").select());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Xiaolai",
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Color.fromRGBO(255, 165, 165, 1),
        ).copyWith(primary: Color.fromRGBO(255, 165, 165, 1)),
      ),
      home: const NavPage(),
    );
  }
}

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NavPageState();
  }
}

class _NavPageState extends State<NavPage> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
          systemNavigationBarContrastEnforced: false,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/bg1.jpg"),
        ),
      ),
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: [
            MemoryPage(),
            ChatPage(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("3")],
            ),
            ProfilePage(),
          ],
        ),
        backgroundColor: Colors.transparent,
        bottomNavigationBar: AfterGlowNavigationBar(
          onChangedIndex: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
