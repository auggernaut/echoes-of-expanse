import 'package:echoes_of_expanse/gamemaster/gamemaster_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'player/character_data.dart';
import 'player/game_screen.dart';
import 'intro_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setUrlStrategy(PathUrlStrategy());
  Hand userHand = Hand();
  bool hasSavedData = await checkForSavedData(userHand);
  String? storedRoomId = await _getStoredRoomId();

  runApp(MyApp(hasSavedData: hasSavedData, userHand: userHand, storedRoomId: storedRoomId));
}

Future<bool> checkForSavedData(Hand userHand) async {
  await userHand.loadCharacter();
  return userHand.selectedCards.isNotEmpty;
}

class MyApp extends StatelessWidget {
  final bool hasSavedData;
  final Hand userHand;
  final String? storedRoomId;

  MyApp({required this.hasSavedData, required this.userHand, required this.storedRoomId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) =>
          _onGenerateRoute(settings, hasSavedData, userHand, storedRoomId),
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(Size(300, 60)),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.only(right: 40.0, left: 40.0, bottom: 14.0)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.grey; // Hover color
                  }
                  return Colors.black; // Default color
                },
              ),
              textStyle: MaterialStateProperty.all<TextStyle>(
                GoogleFonts.texturina(
                  fontSize: 22.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              alignment: Alignment.center),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.cinzel(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            height: 1.5,
          ),
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
            fontSize: 28.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          bodyMedium: GoogleFonts.texturina(
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          bodySmall: GoogleFonts.texturina(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          labelMedium: GoogleFonts.texturina(
            fontSize: 12.0,
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
          titleTextStyle: GoogleFonts.cinzel(
            textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

Route<dynamic> _onGenerateRoute(
    RouteSettings settings, bool hasSavedData, Hand userHand, String? storedRoomId) {
  print(settings.name);

  if (settings.name!.startsWith('/gamemaster')) {
    return MaterialPageRoute(
      builder: (context) => GameMasterView(roomId: storedRoomId),
    );
  }

  return MaterialPageRoute(
    builder: (context) => hasSavedData ? GameScreen(hand: userHand) : const IntroPage(),
  );
}

Future<String?> _getStoredRoomId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('gamemasterRoomId');
}
