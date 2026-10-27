import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart' as mu show TextTheme;

/// Paleta de la app. Todos los colores salen de aquí.
class AppColors {
  AppColors._();

  static const primary = Colors.indigo;
  static final primaryDark = Colors.indigo.shade900;
  static final primaryText = Colors.indigo.shade900;
  static final primaryMuted = Colors.indigo.shade400;
  static final primarySoft = Colors.indigo.shade200;
  static final primaryLight = Colors.indigo.shade100;
  static final primaryFaint = Colors.indigo.shade50;

  static const background = Color(0xFFF3F4FC);
  static const surface = Colors.white;
  static const star = Colors.amber;

  /// Cabecera del formulario.
  static final headerGradient = [
    Colors.indigo.shade600,
    Colors.indigo.shade900,
  ];

  /// Tarjeta de nota importante.
  static final importantGradient = [
    Colors.indigo.shade500,
    Colors.indigo.shade800,
  ];

  /// Fondo de campos y del selector de "Importante".
  static Color get fieldFill => primaryFaint.withValues(alpha: 0.6);
}

/// Radios de borde.
class AppRadius {
  AppRadius._();

  static const double field = 20;
  static const double button = 20;
  static const double card = 24;
  static const double panel = 28;
}

/// Espaciados comunes.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
    );

    // Montserrat en todos los estilos de texto.
    final textTheme = _montserrat(base.textTheme);

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide(color: color, width: width),
        );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: _montserrat(base.primaryTextTheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.primaryText,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.primaryText,
          fontWeight: FontWeight.w700,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        extendedTextStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          textStyle: textTheme.titleSmall?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + 2,
          vertical: AppSpacing.lg + 2,
        ),
        labelStyle: TextStyle(color: AppColors.primaryMuted),
        floatingLabelStyle: TextStyle(
          color: Colors.indigo.shade700,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: AppColors.primary,
        counterStyle: TextStyle(color: Colors.indigo.shade300),
        border: border(AppColors.primaryLight),
        enabledBorder: border(AppColors.primaryLight),
        focusedBorder: border(AppColors.primary, 2),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? AppColors.primary : null,
        ),
        thumbIcon: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Icon(Icons.check_rounded, color: AppColors.primary)
              : null,
        ),
      ),
    );
  }

  /// google_fonts devuelve el TextTheme de material_ui; se copia al de
  /// Flutter conservando los tamaños y colores del tema base.
  static TextTheme _montserrat(TextTheme base) {
    final m = GoogleFonts.montserratTextTheme(_toMaterialUi(base));
    return base.copyWith(
      displayLarge: m.displayLarge,
      displayMedium: m.displayMedium,
      displaySmall: m.displaySmall,
      headlineLarge: m.headlineLarge,
      headlineMedium: m.headlineMedium,
      headlineSmall: m.headlineSmall,
      titleLarge: m.titleLarge,
      titleMedium: m.titleMedium,
      titleSmall: m.titleSmall,
      bodyLarge: m.bodyLarge,
      bodyMedium: m.bodyMedium,
      bodySmall: m.bodySmall,
      labelLarge: m.labelLarge,
      labelMedium: m.labelMedium,
      labelSmall: m.labelSmall,
    );
  }

  static mu.TextTheme _toMaterialUi(TextTheme t) => mu.TextTheme(
    displayLarge: t.displayLarge,
    displayMedium: t.displayMedium,
    displaySmall: t.displaySmall,
    headlineLarge: t.headlineLarge,
    headlineMedium: t.headlineMedium,
    headlineSmall: t.headlineSmall,
    titleLarge: t.titleLarge,
    titleMedium: t.titleMedium,
    titleSmall: t.titleSmall,
    bodyLarge: t.bodyLarge,
    bodyMedium: t.bodyMedium,
    bodySmall: t.bodySmall,
    labelLarge: t.labelLarge,
    labelMedium: t.labelMedium,
    labelSmall: t.labelSmall,
  );
}
