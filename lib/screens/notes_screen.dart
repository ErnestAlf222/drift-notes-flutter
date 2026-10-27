import 'package:drift_app/database/database.dart';
import 'package:drift_app/providers/database_provider.dart';
import 'package:drift_app/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift_app/theme/app_theme.dart';
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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // final notesDao = ref.read(appDatabaseProvider).notesDao;
          // notesDao.insertNote(
          //   NotesCompanion.insert(title: 'Hola mundo', body: 'Hola body'),
          // );
          context.push('/note/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nueva nota'),
      ),
    );
  }
}

class _ListItems extends ConsumerWidget {
  const _ListItems({required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              color: AppColors.primarySoft,
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
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Dismissible(
            key: ValueKey(note.id),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: scheme.error,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: Icon(Icons.delete_outline, color: scheme.onError),
            ),
            onDismissed: (_) => {
            //borrar en la base de datos cuando exista.
              ref.read(appDatabaseProvider)
                .notesDao
                .deleteNote(note.id)
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: important
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: AppColors.importantGradient,
                      )
                    : null,
                color: important ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(
                  color: important
                      ? Colors.transparent
                      : AppColors.primaryLight,
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  onTap: () => context.push('/note/${note.id}'),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            important
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: important
                                ? AppColors.star
                                : AppColors.primarySoft,
                          ),

                          onPressed: () => {
                          // actualizar en la base de datos cuando exista.
                            ref.read(appDatabaseProvider)
                            .notesDao
                            .updateNote(note.copyWith(
                              isImportant: !note.isImportant
                            )),
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: important
                                      ? Colors.white
                                      : AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                note.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: important
                                      ? Colors.white70
                                      : AppColors.primaryMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: important
                                ? Colors.white.withValues(alpha: 0.18)
                                : AppColors.primaryFaint,
                          ),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: important ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
