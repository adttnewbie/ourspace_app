/// Notes aggregate access (docs/state-management.md §12).
abstract class NotesRepository {
  /// Creates a sticky via `notes.create` (api-contract.md).
  ///
  /// Success invalidates home/notes at the caller (state-management.md §5).
  Future<void> create({required String body, required String color});
}
