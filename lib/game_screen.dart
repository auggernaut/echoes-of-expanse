import 'package:echoes_of_expanse/character_sheet.dart';
import 'package:echoes_of_expanse/deck_view.dart';
import 'package:echoes_of_expanse/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:echoes_of_expanse/data.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GameScreen extends StatefulWidget {
  final Hand hand;

  GameScreen({super.key, required this.hand});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      DeckView(hand: widget.hand),
      CharacterSheet(hand: widget.hand),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Echoes of Expanse"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _clearCharacterData(context, widget.hand),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showInstructions(context),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile layout with bottom navigation bar
            return Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            );
          } else {
            // Tablet/Desktop layout with side-by-side view
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DeckView(hand: widget.hand),
                ),
                Expanded(
                  flex: 1,
                  child: CharacterSheet(hand: widget.hand),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_list),
                  label: 'Deck',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Character',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              onTap: _onItemTapped,
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDiceRoller(context),
        child: Image.asset(
          'assets/images/d6.png', // Ensure you have a dice image asset
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}

void _clearCharacterData(BuildContext context, Hand hand) async {
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
