import 'package:localmaterialnotes/utils/constants/constants.dart';

enum Confirmations {
  none('none'),
  irreversible('irreversible'),
  all('all'),
  ;

  final String name;

  const Confirmations(this.name);

  String get title {
    switch (this) {
      case Confirmations.none:
        return localizations.confirmations_title_none;
      case Confirmations.irreversible:
        return localizations.confirmations_title_irreversible;
      case Confirmations.all:
        return localizations.confirmations_title_all;
      default:
        throw Exception();
    }
  }
}
