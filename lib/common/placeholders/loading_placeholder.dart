import 'package:flutter/material.dart';

/// Placeholder widget for loading content.
class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
