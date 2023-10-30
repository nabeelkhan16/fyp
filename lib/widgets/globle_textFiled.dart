import 'package:flutter/material.dart';

class GlobalTextField extends StatefulWidget {
  final hintText;
  final controller;
  final prefixText;
  final suffixIcon;
  final Function(String?)? validator;
  final Function(String?)? onChanged;
  final String? suffixText;
  final bool centerText;
  final bool IsNumaricKeyboard;
  const GlobalTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.prefixText,
      this.validator,
      this.onChanged,
      this.suffixIcon,
      this.suffixText,
      this.IsNumaricKeyboard = false,
      this.centerText = false})
      : super(key: key);

  @override
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: TextFormField(
        controller: widget.controller,
        cursorWidth: 2,
        keyboardType: widget.IsNumaricKeyboard ? TextInputType.phone : TextInputType.text,
        onChanged: widget.onChanged,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator as String? Function(String?)?,
        cursorColor: Colors.black,
        cursorRadius: const Radius.circular(2),
        style: const TextStyle(color: Colors.black, fontSize: 18),
        textAlign: widget.centerText ? TextAlign.center : TextAlign.start,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            fillColor: Colors.white,
            suffixIcon: widget.suffixIcon,
            suffixIconColor: Colors.green,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            prefixText: widget.prefixText,
            labelText: widget.hintText,
            suffixText: widget.suffixText,
            suffixStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            prefixStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
            hintStyle: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
            filled: true,
            hintText: widget.hintText),
      ),
    );
  }
}
