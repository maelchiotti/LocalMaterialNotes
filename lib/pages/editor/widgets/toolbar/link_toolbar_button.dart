import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../../dialogs/toolbar_link_dialog.dart';
import 'toolbar_button.dart';

/// Rich text editor link toolbar button.
class LinkToolbarButton extends StatefulWidget {
  /// Custom link button for the toolbar of the rich text editor.
  const LinkToolbarButton({super.key, required this.controller});

  /// The controller of the Fleather text field.
  final FleatherController controller;

  @override
  State<LinkToolbarButton> createState() => _LinkToolbarButtonState();
}

class _LinkToolbarButtonState extends State<LinkToolbarButton> {
  /// Whether the button is enabled.
  late bool enabled;

  @override
  void initState() {
    super.initState();

    enabled = false;

    widget.controller.addListener(didChangeEditingValue);
  }

  @override
  void didUpdateWidget(covariant LinkToolbarButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(didChangeEditingValue);
      widget.controller.addListener(didChangeEditingValue);
    }
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(didChangeEditingValue);
  }

  void didChangeEditingValue() {
    setState(() {
      enabled = !widget.controller.selection.isCollapsed;
    });
  }

  /// Asks the user to enter a link and sets it.
  Future<void> setLink() async {
    final link = await showAdaptiveDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (context) => const ToolbarLinkDialog(),
    );

    if (link == null || link.isEmpty) {
      return;
    }

    widget.controller.formatSelection(ParchmentAttribute.link.fromString(link));
  }

  @override
  Widget build(BuildContext context) {
    return ToolbarButton(
      icon: Icon(Icons.link, color: enabled ? Theme.of(context).iconTheme.color : Theme.of(context).disabledColor),
      onPressed: enabled ? setLink : null,
    );
  }
}
