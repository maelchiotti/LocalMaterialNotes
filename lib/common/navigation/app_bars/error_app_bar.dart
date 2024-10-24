import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';

/// Error app bar.
class ErrorAppBar extends StatefulWidget {
  /// Default constructor.
  const ErrorAppBar({super.key});

  @override
  State<ErrorAppBar> createState() => _ErrorAppBarState();
}

class _ErrorAppBarState extends State<ErrorAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(l.error_widget_title),
    );
  }
}
