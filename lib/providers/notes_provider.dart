import 'package:drift_app/database/database.dart';
import 'package:drift_app/providers/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_provider.g.dart';



@riverpod
Stream<List<Note>> allNotes(Ref ref) {

  return ref.watch(appDatabaseProvider).notesDao.watchAllNotes();

}

@riverpod
Future<Note> noteById(Ref ref, {required int id}) {
  return ref.watch(appDatabaseProvider).notesDao.getNoteById(id);
}
