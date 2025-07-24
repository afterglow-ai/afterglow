import 'dart:ui';

import 'package:flutter/material.dart';

class AfterGlowNavigationBar extends StatefulWidget {
  final Function(int index)? onChangedIndex;
  const AfterGlowNavigationBar({super.key, required this.onChangedIndex});

  @override
  State<StatefulWidget> createState() => _AfterGlowNavigationBarState();
}

class _AfterGlowNavigationBarState extends State<AfterGlowNavigationBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 91,
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(24),
              ),
            ),
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 12, left: 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  [
                    (Icons.dangerous, "123"),
                    (Icons.dangerous, "123"),
                    (Icons.dangerous, "123"),
                    (Icons.person_2, "Profile"),
                  ].indexed.map<Widget>((data) {
                    return AfterGlowNavigationIconButton(
                      showText: currentIndex == data.$1,
                      text: data.$2.$2,
                      icon: data.$2.$1,
                      onTap: () {
                        setState(() {
                          currentIndex = data.$1;
                          widget.onChangedIndex?.call(data.$1);
                        });
                      },
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class AfterGlowNavigationIconButton extends StatefulWidget {
  final bool showText;
  final String text;
  final IconData icon;
  final Function() onTap;
  const AfterGlowNavigationIconButton({
    super.key,
    required this.showText,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _AfterGlowNavigationIconButtonState();
}

class _AfterGlowNavigationIconButtonState
    extends State<AfterGlowNavigationIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.only(top: 12, right: 16, bottom: 12, left: 16),
        margin: EdgeInsets.only(right: 8, left: 8),
        decoration: ShapeDecoration(
          color: Colors.pink.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: Colors.white.withValues(alpha: 0.78)),
            AnimatedSize(
              duration: Durations.short4,
              curve: Curves.ease,
              child: Visibility(
                visible: widget.showText,
                child: Row(
                  children: [
                    SizedBox(width: 4),
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
