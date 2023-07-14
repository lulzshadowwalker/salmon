import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:salmon/theme/salmon_theme.dart';

final salmonThemeProvider = Provider<SalmonTheme>(
  (ref) => SalmonTheme(ref),
);
