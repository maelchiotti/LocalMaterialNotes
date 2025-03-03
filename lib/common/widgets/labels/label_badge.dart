import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../models/label/label.dart';
import '../../constants/sizes.dart';

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
  Widget build(BuildContext context) {
    return Badge(
      label: Row(
        children: [
          if (label.locked)
            Icon(
              Icons.lock_outline,
              size: Sizes.iconExtraSmall.size,
              color: label.getTextColor(context),
            ),
          Gap(4),
          Expanded(
            child: Text(
              label.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: label.color,
      textColor: label.getTextColor(context),
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
    );
  }
}
