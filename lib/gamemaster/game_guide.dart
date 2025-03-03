import 'package:flutter/material.dart';

class GameGuide extends StatefulWidget {
  @override
  _GameGuideState createState() => _GameGuideState();
}

class _GameGuideState extends State<GameGuide> with SingleTickerProviderStateMixin {
  final List<GuideElement> _elements = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // First tab content
    _elements.add(GuideTextElement(
        "Halls of the Blood King is a Fantasy Horror adventure—a manor from a dimension of horror and pain materializes and begins disrupting the world's balance. Inside, a powerful undead lord guards secrets, treasures and unspeakable monsters while his forces pillage the countryside's blood and souls."));

    _elements.add(HeaderTextElement("Starting the Game"));
    _elements.add(GuideTextElement(
        "Pick one Adventure Hook card. Read it aloud to the players. Designate an owner of the card and hand it to them. They are responsible for the actions on the back of the card.\n\nGo around the table and have each player introduce their character and establish bonds with other characters."));

    _elements.add(HeaderTextElement("Countdown"));
    _elements.add(GuideTextElement(
        "The Halls only remain for the Blood Moon's duration. You only have a few hours, be quick!\n\n"
        "Mark off the steps on the countdown if the corresponding event happens in play, or when you decide it has now happened off-screen. For about a 3 hour session, make a countdown event happen every 5 rounds."));
    _elements.add(ActionBlockElement("Vampire Guest arrives in the Great Hall."));
    _elements.add(ActionBlockElement("Vampire Guest arrives in the Great Hall."));
    _elements.add(ActionBlockElement("Vampire Guest arrives in the Great Hall."));
    _elements.add(ActionBlockElement("Vampire Guest arrives in the Great Hall."));
    _elements.add(ActionBlockElement("Blood King Court is convened."));
    _elements.add(ActionBlockElement("Blood King sends the vampires sent out to hunt."));
    _elements.add(ActionBlockElement("The manor leaves world for another dimension."));

    // Second tab content
    _runningGameElements.add(HeaderTextElement("Game Loop"));
    _runningGameElements.add(GuideTextElement("1. Draw a Location card.\n"
        "2. Read the intro paragraph on the front of the card.\n"
        "3. Ask \"What do you do?\"\n"
        "4. When the players ask questions and explore, reveal hidden details (denoted by ▶).\n"
        "5. When players take actions, determine what type of action (Initiating Player Actions) and help them resolve it (Resolving Player Actions).\n"
        "6. Raise the Stakes by spending the GM points (suggestions denoted by >> on the back of the card). If a [Character] or [Monster] card is indicated, draw that card too (play it similarly to Location cards).\n"
        "7. Reveal secrets in italics, when appropriate in the story.\n"
        "8. When players leave the location, select an adjacent Location from the Access To: list. Repeat these steps."));

    _runningGameElements.add(HeaderTextElement("Initiating Player Actions"));
    _runningGameElements.add(GuideTextElement(
        "When a player says that their character does some action. Decide what type of action it is:\n"
        "1. Is it dangerous or difficult? No → It just happens. Yes → go to step 2.\n"
        "2. Is there a character move for that action? Yes → Ask the player to follow the instructions on the move card. No → go to step 3.\n"
        "3. Ask the player to use the Basic Move, defined in their Player Instructions."));

    _runningGameElements.add(HeaderTextElement("Resolving Player Actions"));
    _runningGameElements.add(GuideTextElement(
        "If there is a corresponding action in bold on the back of the GM card, use the details on the card for how to resolve the action. Otherwise, come up with whatever makes sense in the story or ask the table for ideas about what would happen next. Sometimes the player must Pay the Price (see bleow)."));

    _runningGameElements.add(HeaderTextElement("Pay the Price"));
    _runningGameElements.add(GuideTextElement(
        "When a player rolls a 6-, you earn 2 GM points (and the player earns 1). You can either spend points immediately to Raise the Stakes, or choose to spend GM points later."));

    _runningGameElements.add(HeaderTextElement("Raise the Stakes"));
    _runningGameElements.add(GuideTextElement(
        "When the situation gets worse, spend GM points to introduce an obstacle, cause harm, or change the direction of the story. Suggested ways to do this are indicated on the back of cards with >>. If you want to do something that isn't indicated, just spend a reasonable amount for how dramatic the event is e.g. introducing an obstacle might be 1 GM point, while introducing the final boss early might be 3 GM points."));

    // Third tab content
    _endGameElements.add(HeaderTextElement("Player Character Death"));
    _endGameElements.add(GuideTextElement(
        "When a player character dies, have them build a new character that starts with only 2 Coin and 5 Health. They are a [Blood Prisoner] who was taken by the Blood King's servants, stripped of gear, and was being prepped for dinner before their escape."));

    _endGameElements.add(HeaderTextElement("End of Game"));
    _endGameElements.add(GuideTextElement(
        "Did everyone escape before the mansion disappeared? How did the mission go? What treasures has the party accumulated?\n\n"
        "If the players reach the end of the adventure and escape the mansion alive, they can choose to convert accumulated treasure and Items into Coin then add these points to their pool of available Coin. Players may then rebuild their character using their new Coin, while keeping their background and bonds intact, and restart the adventure. Non-player characters in the adventure may remember the player characters, and any converted items or treasure may reappear in the mansion.\n\n"
        "The mansion has returned the following Blood Moon. The adventurers have been patiently waiting for another go at the Blood King!"));
  }

  final List<GuideElement> _runningGameElements = [];
  final List<GuideElement> _endGameElements = [];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: TabBarView(
              controller: _tabController,
              children: [
                // Guide tab content
                ListView.builder(
                  itemCount: _elements.length,
                  itemBuilder: (context, index) {
                    return _elements[index].build(context, () {
                      setState(() {});
                    });
                  },
                ),
                // Notes tab content
                ListView.builder(
                  itemCount: _runningGameElements.length,
                  itemBuilder: (context, index) {
                    return _runningGameElements[index].build(context, () {
                      setState(() {});
                    });
                  },
                ),
                // Reference tab content
                ListView.builder(
                  itemCount: _endGameElements.length,
                  itemBuilder: (context, index) {
                    return _endGameElements[index].build(context, () {
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.black)),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black, // Make active tab text black
            unselectedLabelColor: Colors.black54, // Make inactive tabs grey
            indicatorColor: Colors.black, // Make the selected tab indicator black
            tabs: const [
              Tab(text: 'Start'),
              Tab(text: 'Gameplay'),
              Tab(text: 'Endgame'),
            ],
          ),
        ),
      ],
    );
  }
}

abstract class GuideElement {
  Widget build(BuildContext context, VoidCallback onStateChanged);
}

class GuideTextElement extends GuideElement {
  final String text;

  GuideTextElement(this.text);

  @override
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    // Split text into lines and process each line
    final lines = text.split('\n');
    List<Widget> textWidgets = [];

    for (String line in lines) {
      // Check if line starts with a number followed by a period
      final numberMatch = RegExp(r'^\d+\.\s*').firstMatch(line);
      bool isNumberedList = numberMatch != null;

      if (isNumberedList) {
        // Get the number part and the rest of the text
        String numberPart = line.substring(0, numberMatch.end);
        String textPart = line.substring(numberMatch.end);

        textWidgets.add(
          Padding(
            padding: EdgeInsets.only(left: 24.0, bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24.0, // Fixed width for the number
                  child: Text(numberPart, style: TextStyle(height: 1.5)),
                ),
                Expanded(
                  child: Text(textPart, style: TextStyle(height: 1.5)),
                ),
              ],
            ),
          ),
        );
      } else {
        textWidgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(line, style: TextStyle(height: 1.5)),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: textWidgets,
          ),
        ),
      ),
    );
  }
}

class HeaderTextElement extends GuideElement {
  final String text;

  HeaderTextElement(this.text);

  @override
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class UserTextElement extends GuideElement {
  final String text;

  UserTextElement(this.text);

  @override
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(12),
          child: Text(text),
        ),
      ),
    );
  }
}

class ActionBlockElement extends GuideElement {
  final String text;
  bool isComplete = false;

  ActionBlockElement(this.text);

  @override
  Widget build(BuildContext context, VoidCallback onStateChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          isComplete = !isComplete;
          onStateChanged();
        },
        child: Container(
          decoration: BoxDecoration(
            color: isComplete ? Colors.grey[300] : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(isComplete ? Icons.check_box : Icons.check_box_outline_blank),
              SizedBox(width: 8),
              Expanded(child: Text(text)),
            ],
          ),
        ),
      ),
    );
  }
}
