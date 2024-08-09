import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

/// Placeholder widget for an error.
class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Text(localizations.error_error),
      ),
    );
  }
}
