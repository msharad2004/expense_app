import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenseTextField extends StatelessWidget {
  const ExpenseTextField({
    super.key,
    required this.label,
    required this.iconData,
    this.keyboardType = TextInputType.text,
    this.controller,
  });

  final String label;
  final IconData iconData;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.white),
          ),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
          suffixIcon: Icon(
            iconData,
            size: 30,
          ),
        ),
      ),
    );
  }
}