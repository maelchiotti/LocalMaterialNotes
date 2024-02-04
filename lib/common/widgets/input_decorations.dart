import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/radiuses.dart';

InputDecoration authenticationTextFormFieldDecoration(
  BuildContext context,
  IconData icon,
  String hint, [
  Widget? suffixIcon,
]) {
  return InputDecoration(
    prefixIcon: Icon(icon),
    suffixIcon: suffixIcon,
    hintText: hint,
    filled: true,
    fillColor: Theme.of(context).colorScheme.secondaryContainer,
    border: OutlineInputBorder(
      borderRadius: Radiuses.radius64.circular,
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: Radiuses.radius64.circular,
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: Radiuses.radius64.circular,
      borderSide: BorderSide.none,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: Radiuses.radius64.circular,
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
  );
}
