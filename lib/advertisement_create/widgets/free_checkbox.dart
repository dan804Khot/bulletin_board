import 'package:flutter/material.dart';

class FreeCheckbox extends StatelessWidget {
  final bool isFree;
  final ValueChanged<bool?> onChanged;

  const FreeCheckbox({required this.isFree, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isFree,
          onChanged: onChanged,
        ),
        const Text("Бесплатно"),
      ],
    );
  }
}
