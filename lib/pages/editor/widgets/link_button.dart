import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../dialogs/link_dialog.dart';
import 'editor_button.dart';

/// Custom toolbar button to add a link.
class LinkButton extends StatefulWidget {
  /// Default constructor.
  const LinkButton({
    super.key,
    required this.controller,
  });

  /// Editor controller.
  final FleatherController controller;

  @override
  State<LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  /// Whether the button is enabled.
  var _enabled = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_selectionChanged);
  }

  @override
  void didUpdateWidget(covariant LinkButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_selectionChanged);
      widget.controller.addListener(_selectionChanged);
    }
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_selectionChanged);
  }

  /// Updates [_enabled] when the text selection changes.
  void _selectionChanged() {
    setState(() {
      _enabled = !widget.controller.selection.isCollapsed;
    });
  }

  /// Asks the user to enter the link to add.
  Future<void> _enterLink() async {
    final link = await showAdaptiveDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (context) => const LinkDialog(),
    );

    if (link == null || link.isEmpty) {
      return;
    }

    widget.controller.formatSelection(ParchmentAttribute.link.fromString(link));
  }

  @override
  Widget build(BuildContext context) {
    return EditorButton(
      icon: Icons.link,
      iconColor: _enabled ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor,
      onPressed: _enabled ? _enterLink : null,
    );
  }
}
