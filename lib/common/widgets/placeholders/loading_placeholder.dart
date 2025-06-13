import 'package:flutter/material.dart';

import '../../constants/paddings.dart';

/// Placeholder widget for loading content.
class LoadingPlaceholder extends StatelessWidget {
  /// Default constructor.
  const LoadingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Paddings.page,
        child: const SingleChildScrollView(child: CircularProgressIndicator()),
      ),
    );
  }
}
