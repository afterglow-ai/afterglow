import 'package:flutter/material.dart';

class BookContainer extends StatelessWidget {
  final Widget? child;
  const BookContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 16),
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/book.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: deviceSize.width * 0.2,
        ).copyWith(top: deviceSize.height * 0.05),
        child: child,
      ),
    );
  }
}
