import '../../common/preferences/preference_key.dart';
import '../notes/notes_service.dart';

/// Bin service.
class BinService {
  final _notesService = NotesService();

  /// Removes the notes from the bin if they have been deleted longer than the corresponding setting, it enabled.
  Future<void> removeNotesFromBinIfNeeded() async {
    final autoRemoveFromBinPreference = PreferenceKey.autoRemoveFromBin.preferenceOrDefault;
    if (autoRemoveFromBinPreference == -1) {
      return;
    }

    final autoRemoveFromBinDuration = Duration(days: autoRemoveFromBinPreference);
    await _notesService.removeFromBin(autoRemoveFromBinDuration);
  }
}
