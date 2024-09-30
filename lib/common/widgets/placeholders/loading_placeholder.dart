import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';

/// Placeholder widget for loading content.
class LoadingPlaceholder extends StatelessWidget {
  /// Default constructor.
  const LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Paddings.page,
        child: const SingleChildScrollView(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
