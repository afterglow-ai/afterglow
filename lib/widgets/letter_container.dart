import 'package:flutter/material.dart';

class LetterContainer extends StatelessWidget {
  final String? title;
  final String? body;
  const LetterContainer({super.key, this.title, this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/bg0.png"),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          elevation: 0,
          shape: CircleBorder(),
          backgroundColor: Color(0xFFFF8B8B),
          child: Icon(Icons.photo_rounded, color: Colors.white),
        ),
        body: Container(
          margin: const EdgeInsets.all(24),
          constraints: BoxConstraints.expand(),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.primary, width: 8),
            ),
            color: Color(0xFFFFF0F0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close, color: Color(0xFFFF8B8B)),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.backspace, color: Color(0xFFFF8B8B)),
                  ),
                  SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {},
                    child: Center(child: Text("发送")),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 16),
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 15.0,
                        vertical: 4,
                      ),
                      child: Text(
                        title ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 15.0,
                        vertical: 4,
                      ),
                      child: Text("132313321313" * 1000),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
