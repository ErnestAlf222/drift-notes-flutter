import 'package:drift_app/database/database.dart';
import 'package:drift_app/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de listado.
/// Stateful solo para reflejar cambios visuales (dismiss, estrella)
/// Mientras no haya base de datos.
class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(allNotesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis notas')),

      body: notesAsync.when(
        data: (notes) => _ListItems(notes: notes),
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => Center(child: const CircularProgressIndicator()),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final notesDao = ref.read(appDatabaseProvider).notesDao;
          // notesDao.insertNote(
          //   NotesCompanion.insert(title: 'Hola mundo', body: 'Hola body'),
          // );
          context.push('/note/new');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ListItems extends StatelessWidget {
  const _ListItems({required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sticky_note_2_outlined,
              size: 64,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text('No hay notas', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '¡Crea la primera!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final important = note.isImportant;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Dismissible(
            key: ValueKey(note.id),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: scheme.error,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.delete_outline, color: scheme.onError),
            ),
            // TODO: borrar en la base de datos cuando exista.
            onDismissed: (_) => {
              // setState(() => notes.removeAt(index))
            },
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              color: important
                  ? scheme.tertiaryContainer.withValues(alpha: 0.45)
                  : scheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: important
                      ? scheme.tertiary.withValues(alpha: 0.35)
                      : scheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
                title: Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  note.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    important ? Icons.star_rounded : Icons.star_border_rounded,
                    color: important ? Colors.amber : scheme.outline,
                  ),
                  // TODO: actualizar en la base de datos cuando exista.
                  onPressed: () => {
                    // setState(() {
                    //   notes[index] = note.copyWith(
                    //     isImportant: !note.isImportant,
                    //   );

                    // }),
                  },
                ),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: scheme.outline,
                ),
                onTap: () => context.push('/note/${note.id}'),
              ),
            ),
          ),
        );
      },
    );
  }
}
