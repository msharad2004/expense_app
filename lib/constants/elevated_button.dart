import 'package:flutter/material.dart';

class CstmButton extends StatelessWidget {
  CstmButton({
    super.key,
    required this.name,
    required this.textColor,
    required this.btnColor,
    required this.onTap,
    this.mWidget,
  });

  final String name;
  final Color btnColor;
  final Color textColor;
  Widget? mWidget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
        ),
        child: mWidget ?? Text(
          name,
          style: TextStyle(fontSize: 18, color: textColor),
        ),
      ),
    );
  }
}