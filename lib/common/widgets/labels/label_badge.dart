import 'package:flutter/material.dart';
import '../../../models/label/label.dart';

/// Badge of a label.
class LabelBadge extends StatelessWidget {
  /// A badge displaying the name of a [label] and its color.
  const LabelBadge({
    super.key,
    required this.label,
  });

  /// The label to display in the badge.
  final Label label;

  @override
  Widget build(BuildContext context) => Badge(
        label: Text(
          label.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: label.color,
        textColor: label.getTextColor(context),
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
      );
}
