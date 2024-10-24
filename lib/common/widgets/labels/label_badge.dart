import 'package:flutter/material.dart';
import 'package:localmaterialnotes/models/label/label.dart';

class LabelBadge extends StatelessWidget {
  const LabelBadge({
    super.key,
    required this.label,
  });

  final Label label;

  @override
  Widget build(BuildContext context) {
    return Badge(
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
}
