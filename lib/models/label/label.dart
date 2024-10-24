import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label.g.dart';

// ignore_for_file: must_be_immutable

@Collection(inheritance: false)
class Label extends Equatable implements Comparable<Label> {
  Id id = Isar.autoIncrement;

  /// Whether the note is selected.
  ///
  /// It's excluded from the JSON because it's only needed temporarily during multi-selection.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @ignore
  bool selected = false;

  @Index(unique: true)
  String name;
  int colorHex;

  @Index()
  bool visible;
  @Index()
  bool pinned;

  @ignore
  bool get hidden => !visible;

  @ignore
  Color get color => Color(colorHex);

  Color getTextColor(BuildContext context) {
    return Color(colorHex).computeLuminance() > 0.5
        ? Theme.of(context).colorScheme.onInverseSurface
        : Theme.of(context).colorScheme.onSurface;
  }

  Label({
    required this.name,
    required this.colorHex,
  })  : visible = true,
        pinned = false;

  /// Labels are sorted according to:
  ///   1. Their pin state.
  ///   2. Their visible state.
  ///   3. Their name.
  @override
  int compareTo(other) {
    if (pinned && !other.pinned) {
      return -1;
    } else if (!pinned && other.pinned) {
      return 1;
    } else if (visible && !other.visible) {
      return -1;
    } else if (!visible && other.visible) {
      return 1;
    } else {
      return name.toLowerCase().compareTo(other.name.toLowerCase());
    }
  }

  @override
  @ignore
  List<Object?> get props => [name];
}
