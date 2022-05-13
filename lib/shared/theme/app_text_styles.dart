import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme.dart';

abstract class IAppStyles {
  TextStyle get title;
  TextStyle get titleHome;
  TextStyle get titleDetails;
  TextStyle get titleDetailsPrice;
  TextStyle get cardTitleValueChart;
  TextStyle get cardSubTitleValueChart;
  TextStyle get cardHintChart;
  TextStyle get cardInputChart;
  TextStyle get cardTitleProduct;
  TextStyle get cardSubTitleProduct;
  TextStyle get cardTitleValueProduct;
  TextStyle get subTitle;
  TextStyle get label;
  TextStyle get input;
  TextStyle get content;
  TextStyle get hint;
  TextStyle get hintBold;
  TextStyle get buttonBackgroundColor;
  TextStyle get buttonBoldTextColor;
  TextStyle get buttonTextColor;
  TextStyle get msgError;
}

class AppStyles implements IAppStyles {
  @override
  TextStyle get buttonBackgroundColor => GoogleFonts.inter(
        fontSize: 14,
        color: AppTheme.colors.background,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get buttonBoldTextColor => GoogleFonts.inter(
        fontSize: 14,
        color: AppTheme.colors.textColor,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get buttonTextColor => GoogleFonts.inter(
        fontSize: 14,
        color: AppTheme.colors.textColor,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get msgError => GoogleFonts.inter(
        fontSize: 14,
        color: AppTheme.colors.badColor,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get hint => GoogleFonts.inter(
        fontSize: 14,
        color: AppTheme.colors.inputNormal,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get content => GoogleFonts.inter(
        fontSize: 16,
        color: AppTheme.colors.inputNormal,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get hintBold => GoogleFonts.inter(
        fontSize: 14,
        color: AppTheme.colors.inputNormal,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get input => GoogleFonts.inter(
        fontSize: 16,
        color: AppTheme.colors.inputNormal,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get label => GoogleFonts.inter(
        fontSize: 16,
        color: AppTheme.colors.textColor,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get title => GoogleFonts.inter(
        fontSize: 22,
        color: AppTheme.colors.title,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get titleDetails => GoogleFonts.inter(
        fontSize: 22,
        color: AppTheme.colors.title,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get titleDetailsPrice => GoogleFonts.inter(
        fontSize: 22,
        color: AppTheme.colors.primary,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get titleHome => GoogleFonts.inter(
        fontSize: 16,
        color: AppTheme.colors.title,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get cardTitleValueChart => GoogleFonts.inter(
        fontSize: 30,
        color: AppTheme.colors.title,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get cardSubTitleValueChart => GoogleFonts.inter(
        fontSize: 16,
        color: AppTheme.colors.title,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get cardHintChart => GoogleFonts.inter(
        fontSize: 10,
        color: AppTheme.colors.subTitle,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get cardInputChart => GoogleFonts.inter(
        fontSize: 12,
        color: AppTheme.colors.subTitle,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get cardTitleProduct => GoogleFonts.inter(
        fontSize: 16,
        color: AppTheme.colors.title,
        fontWeight: FontWeight.normal,
      );

  @override
  TextStyle get cardSubTitleProduct => GoogleFonts.inter(
      fontSize: 12,
      color: AppTheme.colors.title,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.lineThrough);

  @override
  TextStyle get cardTitleValueProduct => GoogleFonts.inter(
        fontSize: 26,
        color: AppTheme.colors.title,
        fontWeight: FontWeight.bold,
      );

  @override
  TextStyle get subTitle => GoogleFonts.inter(
        fontSize: 16,
        color: AppTheme.colors.subTitle,
        fontWeight: FontWeight.normal,
      );
}
