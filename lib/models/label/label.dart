import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../note/note.dart';

part 'label.g.dart';

// ignore_for_file: must_be_immutable

/// A label used to categorize a [Note].
///
/// A label is represented by a [name] and a [color].
///
/// It can be [pinned], in which case it is always shown first.
/// It can also be hidden, it which case it is not displayed outside the page to manage labels.
@JsonSerializable()
@Collection(inheritance: false)
class Label extends Equatable implements Comparable<Label> {
  /// The ID of the label.
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id id = Isar.autoIncrement;

  /// The name of the label.
  @Index(unique: true)
  String name;

  /// The hexadecimal value of the [color] of the label.
  ///
  /// The default value corresponds to the color `#2278e9`.
  @JsonKey(defaultValue: 4280449257)
  int colorHex;

  /// Whether the label is visible.
  @Index()
  @JsonKey(defaultValue: true)
  bool visible;

  /// Whether the label is pinned.
  @Index()
  @JsonKey(defaultValue: false)
  bool pinned;

  /// Whether the label is locked.
  @JsonKey(defaultValue: false)
  bool locked;

  /// Whether the note is selected.
  ///
  /// Excluded from JSON because it's only needed temporarily during multi-selection.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @ignore
  bool selected = false;

  /// The color of the label.
  @ignore
  Color get color => Color(colorHex);

  /// Whether the label is hidden.
  @ignore
  bool get hidden => !visible;

  /// Returns the color of the [name] text when displayed on the [color], depending on its luminance.
  Color getTextColor(BuildContext context) {
    return Color(colorHex).computeLuminance() > 0.5
        ? Theme.of(context).colorScheme.onInverseSurface
        : Theme.of(context).colorScheme.onSurface;
  }

  /// Default constructor of a label.
  Label({
    required this.name,
    required this.colorHex,
  })  : visible = true,
        pinned = false,
        locked = true;

  /// Label from [json] data.
  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  /// Label to JSON.
  Map<String, dynamic> toJson() => _$LabelToJson(this);

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
