import 'package:echoes_of_expanse/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.black, // Used for the app's primary interactive elements
            scaffoldBackgroundColor: Colors.white, // Default color of Scaffold widgets
            // Define the default TextTheme. Use this to specify custom text styling.
            textTheme: TextTheme(
                headlineLarge: GoogleFonts.pirataOne(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.5,
                ),
                headlineMedium: GoogleFonts.pirataOne(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.5,
                ),
                headlineSmall: GoogleFonts.pirataOne(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                bodyLarge: GoogleFonts.texturina(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                bodyMedium: GoogleFonts.texturina(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                )),
            colorScheme: const ColorScheme.light(
              primary: Colors.black, // Primary color for the light theme
              onPrimary: Colors.white, // Color for text/icons on top of primary color
              secondary: Colors.black, // Secondary color for the light theme
              onSecondary: Colors.white, // Color for text/icons on top of secondary color
              surface: Colors.white, // The background color for widgets like Card
              onSurface: Colors.black, // Color for text/icons on top of surface colors
              background: Colors.white, // The default color of the Material widget
              onBackground: Colors.black, // Color for text/icons on top of background color
              error: Colors.red, // The color to use for input validation errors
              onError: Colors.white, // Color for text/icons on top of error colors
            ),
            appBarTheme: AppBarTheme(
              color: Colors.black, // Color of the AppBar
              iconTheme: const IconThemeData(color: Colors.white), // Color of icons in AppBar
              titleTextStyle: GoogleFonts.pirataOne(
                  textStyle: const TextStyle(
                      color: Colors.white, fontSize: 20)), // Text style for the AppBar title
            )),
        home: const IntroPage());
  }
}
