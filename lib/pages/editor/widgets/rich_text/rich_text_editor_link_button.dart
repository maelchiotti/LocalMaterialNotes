import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../../dialogs/rich_text_editor_link_dialog.dart';
import 'rich_text_editor_button.dart';

/// Custom toolbar button to add a link.
class RichTextEditorLinkButton extends StatefulWidget {
  /// Default constructor.
  const RichTextEditorLinkButton({
    super.key,
    required this.controller,
  });

  /// Editor controller.
  final FleatherController controller;

  @override
  State<RichTextEditorLinkButton> createState() => _RichTextEditorLinkButtonState();
}

class _RichTextEditorLinkButtonState extends State<RichTextEditorLinkButton> {
  /// Whether the button is enabled.
  var _enabled = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_selectionChanged);
  }

  @override
  void didUpdateWidget(covariant RichTextEditorLinkButton oldWidget) {
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
      builder: (context) => const RichTextEditorLinkDialog(),
    );

    if (link == null || link.isEmpty) {
      return;
    }

    widget.controller.formatSelection(ParchmentAttribute.link.fromString(link));
  }

  @override
  Widget build(BuildContext context) {
    return RichTextEditorButton(
      icon: Icons.link,
      iconColor: _enabled ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor,
      onPressed: _enabled ? _enterLink : null,
    );
  }
}
