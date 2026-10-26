<div align="center">

# Drift App

**App de notas para aprender y practicar [Drift](https://drift.simonbinder.eu/), la base de datos local de Flutter.**

![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-3.x-00B0FF)
![Drift](https://img.shields.io/badge/Drift-SQLite-4CAF50)

</div>

---

## Qué hace

| Función | Descripción |
| --- | --- |
| **Listar** | Muestra todas las notas; las importantes se destacan con una estrella y un tinte. |
| **Crear** | Formulario con título, contenido y marca de *importante*. |
| **Editar** | Abre una nota existente para modificarla. |
| **Eliminar** | Desliza una nota hacia la izquierda para borrarla. |

Las notas se guardan en el dispositivo con Drift (SQLite) y la lista se actualiza
sola a partir de streams de la base de datos.

## Stack

| Pieza | Para qué se usa |
| --- | --- |
| **Flutter** | Interfaz multiplataforma (Material 3). |
| **Riverpod** + `riverpod_generator` | Estado e inyección de dependencias; expone la base de datos y el stream de notas. |
| **Drift** (`drift`, `drift_flutter`, `drift_dev`) | Base de datos local con consultas tipadas y DAOs. |
| **go_router** | Navegación entre el listado y la pantalla de crear/editar. |
| **path_provider** | Ubicación del archivo de la base de datos. |
| **build_runner** | Generación de código para Drift y Riverpod. |

## Estructura

```text
lib/
├── database/     # Tablas de Drift y DAOs (notes_dao)
├── providers/    # Providers de Riverpod (base de datos, notas)
├── router/       # Rutas con go_router
├── screens/
│   ├── notes_screen.dart   # Listado
│   └── note_screen.dart    # Crear / editar
├── data/         # Datos de ejemplo (mock)
├── models/       # Modelos
└── main.dart
```

## Puesta en marcha

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

> Si cambias tablas o providers anotados, vuelve a ejecutar `build_runner`.

## Estado del proyecto

- [x] Base de datos Drift y DAO de notas
- [x] Listado reactivo con Riverpod
- [x] Interfaz estilizada (listado y formulario)
- [ ] Guardar y editar notas desde el formulario
- [ ] Eliminar y marcar como importante desde el listado

---

<div align="center">

Hecho por **Ernesto Alfonso Sánchez Montiel**

</div>
