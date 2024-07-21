import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data.dart'; // Ensure you have the correct import for your data classes
import 'game_screen.dart'; // Ensure you have the correct import for your game screen
import 'intro_page.dart'; // Ensure you have the correct import for your intro page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hand userHand = Hand();
  bool hasSavedData = await checkForSavedData(userHand);

  runApp(MyApp(hasSavedData: hasSavedData, userHand: userHand));
}

Future<bool> checkForSavedData(Hand userHand) async {
  await userHand.loadCards();
  return userHand.selectedCards.isNotEmpty;
}

class MyApp extends StatelessWidget {
  final bool hasSavedData;
  final Hand userHand;

  MyApp({required this.hasSavedData, required this.userHand});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
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
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.black,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: GoogleFonts.pirataOne(
            textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      home: hasSavedData ? GameScreen(hand: userHand) : const IntroPage(),
    );
  }
}
