import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';

/// Placeholder widget for an error.
class ErrorPlaceholder extends StatelessWidget {
  /// Default constructor.
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
