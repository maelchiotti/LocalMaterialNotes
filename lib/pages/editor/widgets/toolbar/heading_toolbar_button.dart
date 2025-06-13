import 'package:fleather/fleather.dart';
import 'package:fleather/l10n/fleather_localizations_en.g.dart';
import 'package:flutter/material.dart';

/// Heading toolbar button.
class HeadingToolbarButton extends StatefulWidget {
  /// Rich text editor toolbar button to pick the style of the text.
  const HeadingToolbarButton({super.key, required this.controller});

  /// The fleather editor controller.
  final FleatherController controller;

  @override
  State<HeadingToolbarButton> createState() => _HeadingToolbarButtonState();
}

class _HeadingToolbarButtonState extends State<HeadingToolbarButton> {
  /// The current heading attribute.
  late ParchmentAttribute<int> currentAttribute;

  /// The style of the current text selection.
  ParchmentStyle get selectionStyle => widget.controller.getSelectionStyle();

  List<ParchmentAttribute> attributes = [
    ParchmentAttribute.heading.unset,
    ParchmentAttribute.heading.level1,
    ParchmentAttribute.heading.level2,
    ParchmentAttribute.heading.level3,
    ParchmentAttribute.heading.level4,
    ParchmentAttribute.heading.level5,
    ParchmentAttribute.heading.level6,
  ];

  @override
  void initState() {
    super.initState();

    currentAttribute = selectionStyle.get(ParchmentAttribute.heading) ?? ParchmentAttribute.heading.unset;
    widget.controller.addListener(didChangeEditingValue);
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(didChangeEditingValue);
  }

  void didChangeEditingValue() {
    setState(() {
      currentAttribute = selectionStyle.get(ParchmentAttribute.heading) ?? ParchmentAttribute.heading.unset;
    });
  }

  /// Returns the title of the [attribute].
  String getAttributeTitle(ParchmentAttribute attribute) {
    final localizations = FleatherLocalizations.of(context) ?? FleatherLocalizationsEn();

    return switch (attribute.value) {
      null => localizations.headingNormal,
      1 => localizations.headingLevel1,
      2 => localizations.headingLevel2,
      3 => localizations.headingLevel3,
      4 => localizations.headingLevel4,
      5 => localizations.headingLevel5,
      6 => localizations.headingLevel6,
      _ => throw Exception('Unknown current heading value in the heading toolbar button: ${currentAttribute.value}'),
    };
  }

  /// Sets the text style to [attribute].
  void setHeading(ParchmentAttribute attribute) {
    widget.controller.formatSelection(attribute);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ParchmentAttribute>(
      icon: Text(getAttributeTitle(currentAttribute), style: Theme.of(context).textTheme.titleMedium),
      itemBuilder: (context) {
        return attributes.map((attribute) {
          return PopupMenuItem(
            value: attribute,
            child: ListTile(
              title: Text(getAttributeTitle(attribute)),
              selected: currentAttribute.value == attribute.value,
              dense: true,
            ),
          );
        }).toList();
      },
      onSelected: setHeading,
    );
  }
}
