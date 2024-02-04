import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/back.dart';

class BackAppBar extends ConsumerWidget {
  const BackAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: BackButton(
        onPressed: () => back(context),
      ),
    );
  }
}
