import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import 'toolbar_button.dart';

/// Horizontal rule toolbar button.
class HorizontalRuleToolbarButton extends StatelessWidget {
  /// Rich text editor toolbar button to add an horizontal rule.
  const HorizontalRuleToolbarButton({super.key, required this.fleatherController});

  /// The fleather editor controller.
  final FleatherController fleatherController;

  /// Inserts a rule in the content.
  void insertHorizontalRule() {
    final index = fleatherController.selection.baseOffset;
    final length = fleatherController.selection.extentOffset - index;
    final newSelection = fleatherController.selection.copyWith(baseOffset: index + 2, extentOffset: index + 2);

    fleatherController.replaceText(index, length, BlockEmbed.horizontalRule, selection: newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return ToolbarButton(icon: Icon(Icons.horizontal_rule), onPressed: insertHorizontalRule);
  }
}
