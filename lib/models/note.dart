/// Modelo plano de nota.
/// Reemplaza temporalmente a la data class que generaba Drift;
/// cuando volvamos a integrar la BD, esta clase desaparece.
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    this.isImportant = false,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String body;
  final bool isImportant;
  final DateTime createdAt;

  Note copyWith({
    int? id,
    String? title,
    String? body,
    bool? isImportant,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isImportant: isImportant ?? this.isImportant,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
