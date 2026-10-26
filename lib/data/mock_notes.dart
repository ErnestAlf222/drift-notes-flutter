import '../models/note.dart';

/// Data ficticia para la UI. Sin lógica: solo una lista en memoria.
/// Todo esto se reemplaza cuando se integre la base de datos real.
abstract class MockNotes {
  static final List<Note> notes = [
    Note(
      id: 1,
      title: 'Lista de compras',
      body: 'Leche, huevos, pan y café.',
      isImportant: true,
      createdAt: DateTime(2026, 6, 1, 10, 30),
    ),
    Note(
      id: 2,
      title: 'Ideas para el proyecto',
      body: 'Agregar buscador de notas y soporte para etiquetas.',
      createdAt: DateTime(2026, 6, 3, 18, 45),
    ),
    Note(
      id: 3,
      title: 'Recordatorio',
      body: 'Llamar al dentista para agendar cita.',
      createdAt: DateTime(2026, 6, 8, 9, 15),
    ),
  ];
}
