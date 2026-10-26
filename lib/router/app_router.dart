import 'package:go_router/go_router.dart';

import '../screens/note_screen.dart';
import '../screens/notes_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const NotesScreen()),

    // Una sola ruta para crear y editar:
    // /note/new  -> noteId = null (crear)
    // /note/12   -> noteId = 12   (editar)
    GoRoute(
      path: '/note/:id',
      builder: (context, state) {
        final noteId = int.tryParse(state.pathParameters['id'] ?? '');
        return NoteScreen(noteId: noteId);
      },
    ),
  ],
);
