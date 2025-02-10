import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme
  static int primaryColor = 0xFF223B74;
  static int secondaryColor = 0xFF68B8D4;
  static int backgroundColor = 0xFFEEEEEE;
  static int textColor = 0xFF000000;
  static int textSecondaryColor = 0xFF213C74;
  static int defaultFontSize = 16;
  static Color secondaryBackgroundColor = Color(0xFF203B73);
  static Color appBarBackgroundColor = Color(0xFF203B73);
  static Color redCardColor = Color(0xFFE43740);
  static Color buttonRedColor = Color(0xFFE63A40);
  static Color homeBackgroundColor = Color(0xFFFFFFFF);
  static Color cardTextColor = Color(0xFFFFFFFF);

  static EdgeInsets screenPadding = const EdgeInsets.all(16.0);

  // label text style
  static TextStyle labelTextStyle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black.withValues(alpha: 0.5),
  );

  static TextStyle screenTitleTextStyle = GoogleFonts.inter(
    color: Color(textColor),
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle textButtonTextStyle = TextStyle(
    decoration: TextDecoration.underline,
    color: Color(textSecondaryColor),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  // card text style
  static TextStyle cardTextStyle = GoogleFonts.inter(
    color: cardTextColor,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle buttonTextStyle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Color(primaryColor),
    hoverColor: Color(primaryColor),
    scaffoldBackgroundColor: Color(backgroundColor),
    appBarTheme: AppBarTheme(
        backgroundColor: appBarBackgroundColor,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        )),
    dividerTheme: DividerThemeData(
      color: Color(textColor),
      thickness: 0.5,
    ), // Background color
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.only(left: 4)),
      ),
    ),
    textTheme: TextTheme(
      headlineMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(textColor),
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(textColor),
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(primaryColor),
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(textSecondaryColor),
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(textColor),
      ),
    ),
  );
}
