import 'package:drift/drift.dart' show Value;
import 'package:drift_app/database/database.dart';
import 'package:drift_app/providers/database_provider.dart';
import 'package:drift_app/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift_app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

/// Pantalla de crear / editar.
class NoteScreen extends ConsumerWidget {
  const NoteScreen({super.key, this.noteId});

  final int? noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Modo crear: formulario vacío.
    if (noteId == null) {
      return const _NoteForm(note: null);
    }

    final noteAsync = ref.watch(noteByIdProvider(id: noteId!));
    return noteAsync.when(
      data: (note) => _NoteForm(note: note),
      error: (error, _) => Center(child: Text('El error es $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Formulario. Stateful porque los TextEditingController son estado local
class _NoteForm extends ConsumerStatefulWidget {
  const _NoteForm({required this.note});

  /// null = crear, con valor = editar.
  final Note? note;

  @override
  ConsumerState<_NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends ConsumerState<_NoteForm> {
  late final titleController = TextEditingController(text: widget.note?.title);
  late final bodyController = TextEditingController(text: widget.note?.body);
  late bool isImportant = widget.note?.isImportant ?? false;

  bool get isEditing => widget.note != null;

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void _save() async {
    final dao = ref.read(appDatabaseProvider).notesDao;
    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    if (title.isEmpty) return;
    if (body.isEmpty) return;

    if (isEditing) {
      await dao.updateNote(
        widget.note!.copyWith(
          title: title,
          body: body,
          isImportant: isImportant,
        ),
      );
    } else {
      await dao.insertNote(
        NotesCompanion.insert(
          title: title,
          body: body,
          isImportant: Value(isImportant),
        ),
      );
    }
    if (mounted) context.pop();
  }

  InputDecoration _decoration(
    String label, {
    IconData? icon,
    bool hint = false,
  }) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: hint,
      prefixIcon: icon == null ? null : Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar nota' : 'Nueva nota')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // Cabecera con degradado índigo.
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.headerGradient,
              ),
              borderRadius: BorderRadius.circular(AppRadius.panel),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isEditing
                        ? Icons.edit_note_rounded
                        : Icons.note_add_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing ? 'Edita tu nota' : 'Crea una nota',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Escribe tus ideas con claridad',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tarjeta del formulario.
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.panel),
              border: Border.all(color: AppColors.primaryLight),
            ),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  maxLength: 50,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _decoration('Título', icon: Icons.title_rounded),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bodyController,
                  minLines: 6,
                  maxLines: 10,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: _decoration('Contenido', hint: true),
                ),
                const SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: isImportant
                        ? AppColors.primaryLight
                        : AppColors.fieldFill,
                    borderRadius: BorderRadius.circular(AppRadius.field),
                    border: Border.all(
                      color: isImportant
                          ? AppColors.primary
                          : AppColors.primaryLight,
                    ),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.field),
                      onTap: () => setState(() => isImportant = !isImportant),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isImportant
                                    ? AppColors.primary
                                    : AppColors.primaryLight,
                              ),
                              child: Icon(
                                isImportant
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: isImportant
                                    ? AppColors.star
                                    : AppColors.primaryMuted,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Importante',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: AppColors.primaryText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    isImportant
                                        ? 'Nota destacada'
                                        : 'Marcar como destacada',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.primaryMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: isImportant,
                              onChanged: (value) =>
                                  setState(() => isImportant = value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(isEditing ? 'Guardar cambios' : 'Crear nota'),
          ),
        ],
      ),
    );
  }
}
