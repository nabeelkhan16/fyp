import 'package:flutter/material.dart';

final kMessageTextField = InputDecoration(
  hintText: 'Type a message...',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.white,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.white,
    ),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.white,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      color: Colors.white,
    ),
  ),
  focusedErrorBorder: InputBorder.none,
  errorStyle: const TextStyle(color: Colors.red),
  fillColor: Colors.white,
  filled: true,
);

final kSearchTextField = InputDecoration(
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(
      color: Color(0XFFDFE1E6),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(
      color: Color(0XFFDFE1E6),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(
      color: Color(0XFFDFE1E6),
    ),
  ),
  fillColor: Colors.transparent,
  filled: true,
);
