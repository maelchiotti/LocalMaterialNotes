import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../../dialogs/rich_text_editor_link_dialog.dart';
import 'rich_text_editor_button.dart';

/// Rich text editor link toolbar button.
class RichTextEditorLinkButton extends StatefulWidget {
  /// Custom link button for the toolbar of the rich text editor.
  const RichTextEditorLinkButton({super.key, required this.controller});

  /// The controller of the Fleather text field.
  final FleatherController controller;

  @override
  State<RichTextEditorLinkButton> createState() => _RichTextEditorLinkButtonState();
}

class _RichTextEditorLinkButtonState extends State<RichTextEditorLinkButton> {
  late bool enabled;

  @override
  void initState() {
    super.initState();

    enabled = false;

    widget.controller.addListener(selectionChanged);
  }

  @override
  void didUpdateWidget(covariant RichTextEditorLinkButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(selectionChanged);
      widget.controller.addListener(selectionChanged);
    }
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(selectionChanged);
  }

  void selectionChanged() {
    setState(() {
      enabled = !widget.controller.selection.isCollapsed;
    });
  }

  Future<void> onPressed() async {
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
      iconColor: enabled ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor,
      onPressed: enabled ? onPressed : null,
    );
  }
}
