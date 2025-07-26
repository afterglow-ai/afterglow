import 'package:flutter/material.dart';

class ContactPresetButtons extends StatelessWidget {
  final List<String> presets;
  final Function(String) onPresetSelected;

  const ContactPresetButtons({
    super.key,
    required this.presets,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 33,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          children: presets
              .map(
                (e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: FilledButton(
                    onPressed: () => onPresetSelected(e),
                    child: Text(e),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
