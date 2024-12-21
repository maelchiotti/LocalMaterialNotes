import 'package:flutter/material.dart';
import 'color_extension.dart';

/// Extensions on the [TextStyle] class.
extension TextStyleExtension on TextStyle {
  /// Returns this text style but with a subdued color by setting its alpha channel to 150.
  TextStyle get subdued {
    return copyWith(color: color?.subdued);
  }
}
