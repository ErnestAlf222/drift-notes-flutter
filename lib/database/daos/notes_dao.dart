import 'package:drift/drift.dart';
import 'package:drift_app/database/database.dart';

part 'notes_dao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [Notes])
class NotesDao extends DatabaseAccessor<AppDatabase> with _$NotesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  NotesDao(super.attachedDatabase);

  Stream<List<Note>> watchAllNotes(){
    final query = select(notes);
    // Todo: Ordenar por prioridad
     return query.watch();
  }

  Future<Note> getNoteById(int id) {
    final query = select(notes)
      ..where((n) => n.id.equals(id));
    
    return query.getSingle();
  }

  Future<int> insertNote(NotesCompanion note){
    return into(notes).insert(note);

  }

  Future<bool> updateNote(Note note) {
    return update(notes).replace(note);
  }

  Future<int> deleteNote(int id) {
    final query = delete(notes)
      ..where((n) => n.id.equals(id));
    return query.go();
  }
}

