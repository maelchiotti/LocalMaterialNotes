/// The status of a note.
enum NoteStatus {
  /// The note is available.
  available,

  /// The note is deleted.
  deleted,
  ;

  /// Returns the list of status where the note can be edited.
  static List<NoteStatus> get editable => [available];
}
