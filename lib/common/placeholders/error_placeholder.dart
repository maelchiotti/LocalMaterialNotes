import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';

/// Placeholder widget for an error.
class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Paddings.custom.page,
        child: SingleChildScrollView(
          child: Text(localizations.error_error),
        ),
      ),
    );
  }
}
