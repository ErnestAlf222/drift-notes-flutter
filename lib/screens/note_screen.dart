import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_notes.dart';
import '../models/note.dart';

/// Pantalla de crear / editar.
/// noteId == null -> crear nota nueva.
/// noteId != null -> editar la nota con ese id.
class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key, this.noteId});

  final int? noteId;

  @override
  Widget build(BuildContext context) {
    // Modo crear: formulario vacío.
    if (noteId == null) {
      return const _NoteForm(note: null);
    }

    final note = MockNotes.notes.where((n) => n.id == noteId).firstOrNull;

    if (note == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('No existe la nota con id $noteId')),
      );
    }

    return _NoteForm(note: note);
  }
}

/// Formulario. Stateful porque los TextEditingController son estado local
/// de la UI.
class _NoteForm extends StatefulWidget {
  const _NoteForm({required this.note});

  /// null = crear, con valor = editar.
  final Note? note;

  @override
  State<_NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<_NoteForm> {
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

  void _save() {
    final title = titleController.text.trim();
    if (title.isEmpty) return;

    // TODO: guardar en la base de datos cuando exista.
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: scheme.primary, width: 1.5),
    );

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar nota' : 'Nueva nota')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleController,
            maxLength: 50,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Título',
              prefixIcon: const Icon(Icons.title_rounded),
              filled: true,
              fillColor: scheme.surfaceContainerLow,
              border: fieldBorder,
              enabledBorder: fieldBorder,
              focusedBorder: focusedBorder,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: bodyController,
            minLines: 6,
            maxLines: 10,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Contenido',
              alignLabelWithHint: true,
              filled: true,
              fillColor: scheme.surfaceContainerLow,
              border: fieldBorder,
              enabledBorder: fieldBorder,
              focusedBorder: focusedBorder,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            color: isImportant
                ? scheme.tertiaryContainer.withValues(alpha: 0.45)
                : scheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isImportant
                    ? scheme.tertiary.withValues(alpha: 0.35)
                    : scheme.outlineVariant,
              ),
            ),
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              secondary: Icon(
                isImportant ? Icons.star_rounded : Icons.star_border_rounded,
                color: isImportant ? Colors.amber : scheme.outline,
              ),
              title: const Text('Importante'),
              value: isImportant,
              onChanged: (value) => setState(() => isImportant = value),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.save_outlined),
            label: Text(isEditing ? 'Guardar cambios' : 'Crear nota'),
          ),
        ],
      ),
    );
  }
}
