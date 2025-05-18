import '../../common/preferences/preference_key.dart';
import '../notes/notes_service.dart';

/// Bin service.
class BinService {
  final _notesService = NotesService();

  /// Removes the notes from the bin if they have been deleted longer than the corresponding setting, it enabled.
  Future<void> removeNotesFromBinIfNeeded() async {
    final autoRemoveFromBinDelayPreference = PreferenceKey.autoRemoveFromBinDelay.preferenceOrDefault;
    if (autoRemoveFromBinDelayPreference == -1) {
      return;
    }

    final autoRemoveFromBinDelay = Duration(days: autoRemoveFromBinDelayPreference);
    await _notesService.removeFromBin(autoRemoveFromBinDelay);
  }
}
