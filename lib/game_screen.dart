import 'package:echoes_of_expanse/character_sheet.dart';
import 'package:echoes_of_expanse/deck_view.dart';
import 'package:echoes_of_expanse/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:echoes_of_expanse/data.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GameScreen extends StatelessWidget {
  final _key = GlobalKey<ExpandableFabState>();
  final Hand hand;

  GameScreen({super.key, required this.hand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Echoes of Expanse"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _clearCharacterData(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showInstructions(context),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: DeckView(hand: hand),
          ),
          Expanded(
            flex: 1,
            child: CharacterSheet(hand: hand),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () => _showDiceRoller(context),
      //     child: Image.asset(
      //       'assets/images/d6.png', // Ensure you have a dice image asset
      //       height: 40,
      //       width: 40,
      //     )),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.none,
        distance: 70,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.white.withOpacity(0.9),
        ),
        children: [
          Row(
            children: [
              Text('Roll'),
              SizedBox(width: 20),
              FloatingActionButton.small(
                  heroTag: null,
                  onPressed: () => _showDiceRoller(context),
                  child: Icon(Icons.casino)),
            ],
          ),
          const Row(
            children: [
              Text('Add/Spend Coin'),
              SizedBox(width: 20),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: null,
                child: Icon(Icons.circle),
              ),
            ],
          ),
          const Row(
            children: [
              Text('Take Damage/Heal'),
              SizedBox(width: 20),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: null,
                child: Icon(Icons.favorite),
              ),
            ],
          ),
          const Row(
            children: [
              Text('Find/Sell Treasure'),
              SizedBox(width: 20),
              FloatingActionButton.small(
                heroTag: null,
                onPressed: null,
                child: Icon(Icons.diamond),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _clearCharacterData(BuildContext context) async {
    await hand.clearHand();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Character data cleared')),
    );
    // Optionally, you can navigate back to the IntroPage or refresh the current page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => IntroPage()),
    );
  }

  void _onCardTap(PlayingCard card) {
    // Handle card tap if needed
  }

  void _showDiceRoller(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 350,
            height: 190,
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri('https://alarm-clock.info/widgets/dices/diceroll.html'),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take full height of the screen
      builder: (BuildContext context) {
        // Using MediaQuery to calculate height dynamically
        final double maxHeight = MediaQuery.of(context).size.height * 0.9;
        return DraggableScrollableSheet(
            initialChildSize: 0.9, // This is half screen height from initial
            maxChildSize: 0.9, // 90% of screen height
            minChildSize: 0.5, // 50% of screen height
            expand: false,
            builder: (_, controller) {
              return Container(
                  height: maxHeight,
                  padding: const EdgeInsets.all(20),
                  child: ListView(
                      controller: controller, // Important for controlling scroll
                      children: <Widget>[
                        Text(
                          "How to Play",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                            "Echoes of Expanse is story-first roleplay game. This means that first you act and/or speak as your character would in the story, then you see if any moves apply. If no moves apply, then whatever you did or said just happens… no dice rolls needed!",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text("Basic Move", style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When you try something that is dangerous or difficult, check to see if another moves applies, if not determine what stat (Power, Smarts, etc.) the move requires and roll 2d6 then add that stat’s modifier to the roll. On a 10+, you pull it off as well as one could hope; on a 7-9, you can do it, but at a lesser success, a cost, or a consequence; on a 6- it goes terribly wrong, collect 1 XP and Pay the Price.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text("Taking Damage", style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When a foe or a bad roll causes you to take damage, reduce your HP by that amount (less armor, if appropriate) and describe the result.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text("Aid an Ally", style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When you help another character who’s about to roll, they gain advantage but you are exposed to any risks, costs, or consequences.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text("Advantage/Disadvatage",
                            style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When a move says to roll “with advantage” roll an extra die and discard the lowest result. For disadvantage, roll an extra die and discard the highest.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text("Last Breath", style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When you are dying, you catch a glimpse of what lies beyond the Black Gates of Death (describe it). Then roll +nothing, on a 10+, you’ve cheated death—you’re no longer dying but you’re still in a bad place; on a 7-9, Death will offer you a bargain—take it and stabilize or refuse and pass beyond the Black Gates into whatever fate awaits you; on a 6-, your fate is sealed. You’re marked as Death’s own and you’ll cross the threshold soon. The GM will tell you when.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text("Leveling Up", style: Theme.of(context).textTheme.headlineMedium),
                        Text("Using XP", style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                            "Spend 1 XP to add +1 to a roll, after rolling.\nSpend 5 XP to draw another Character Card.\nSpend 5 XP to increase one stat by +1, to max of +3.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text("Earning XP", style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                            "Collect XP when you roll a 6-.\nCollect XP when a Bond is establised or evolves.\nCollect XP when a Move says to.",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ]));
            });
      },
    );
  }
}
