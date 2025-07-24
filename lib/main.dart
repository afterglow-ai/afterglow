import 'dart:io';

import 'package:afterglow/pages/profile_page.dart';
import 'package:afterglow/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const NavPage());
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
    if (Platform.isAndroid) {
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("1")],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("2")],
            ),
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
