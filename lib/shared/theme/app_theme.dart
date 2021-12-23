import 'package:meuapp/shared/theme/app_colors.dart';
import 'package:meuapp/shared/theme/app_text_styles.dart';

export 'app_text.dart';

class AppTheme {
  static AppTheme instance = AppTheme();

  final _colors = AppColors();
  final _textStyles = AppStyles();

  static AppColors get colors => instance._colors;
  static AppStyles get textStyles => instance._textStyles;
}
