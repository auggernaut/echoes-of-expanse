import 'package:echoes_of_expanse/character_creation_manager.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Echoes of Expanse"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome, adventurer, ready your weapons and prepare to embark on a fantastic journey!\n\n Everything you need to play is in this app with the exception of dice, a piece of blank paper, and a pen.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to CharacterCreationManager when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CharacterCreationManager()),
                );
              },
              child: const Text("Create Your Character"),
            ),
          ],
        ),
      ),
    );
  }
}
