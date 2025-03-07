import 'package:echoes_of_expanse/player/character_sheet.dart';
import 'package:echoes_of_expanse/player/deck_view.dart';
import 'package:echoes_of_expanse/intro_page.dart';
import 'package:echoes_of_expanse/gamemaster/scene_area.dart';
import 'package:flutter/material.dart';
import 'package:echoes_of_expanse/player/character_data.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class GameScreen extends StatefulWidget {
  final Hand hand;

  GameScreen({super.key, required this.hand});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _selectedIndex = 0;
  String? _roomId; // Move this declaration here
  final TextEditingController _roomCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRoomCode();
  }

  Future<void> _loadRoomCode() async {
    final characterData = await widget.hand.loadCharacter();
    setState(() {
      _roomId = characterData['roomCode'] as String? ?? '';
    });
  }

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  Future<void> _enterRoom() async {
    final roomCode = _roomCodeController.text.trim();
    if (await _validateRoomCode(roomCode)) {
      await _createCharacterInRoom(roomCode);
      widget.hand.updateStat('roomCode', roomCode);
      setState(() {
        _roomId = roomCode;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid room code. Please try again.')),
      );
    }
  }

  Future<void> _createCharacterInRoom(String roomCode) async {
    final characterData = await widget.hand.loadCharacter();

    if (widget.hand.id == null) {
      // Generate a new id if one doesn't exist
      String newId = Uuid().v4();
      widget.hand.setId(newId);
      characterData['id'] = newId;
    }

    // Find the class card
    CharacterCard? classCard = widget.hand.selectedCards.firstWhere(
      (card) => card.type == 'class',
    );

    // Add scene-specific data
    characterData['backAsset'] = classCard.backAsset;
    characterData['frontAsset'] = classCard.frontAsset;
    characterData['position'] = {'x': 0, 'y': 0};
    characterData['name'] = characterData['characterName'] ?? '';
    characterData['isFlipped'] = false;
    characterData['type'] = 'class';

    final existingCharacterQuery = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomCode)
        .collection('players')
        .where('id', isEqualTo: widget.hand.id)
        .get();

    if (existingCharacterQuery.docs.isEmpty) {
      // Add the character to the room
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomCode)
          .collection('scene')
          .add(characterData);
    } else {
      // Character already exists, update their data
      final existingCharacterId = existingCharacterQuery.docs.first.id;
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomCode)
          .collection('scene')
          .doc(existingCharacterId)
          .update(characterData);
    }
  }

  Future<bool> _validateRoomCode(String roomCode) async {
    final roomDoc = await FirebaseFirestore.instance.collection('rooms').doc(roomCode).get();
    return roomDoc.exists;
  }

  Widget _buildSceneArea() {
    if (_roomId == null || _roomId!.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _roomCodeController,
                decoration: InputDecoration(
                  labelText: 'Enter Room Code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enterRoom,
                child: Text('Join a Game'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Stack(
      children: [
        SceneArea(roomId: _roomId!),
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _leaveRoom,
              child: Text(
                'Leave Room',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
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
            // Mobile layout
            return IndexedStack(
              index: _selectedIndex,
              children: [
                _buildSceneArea(),
                DeckView(hand: widget.hand),
                CharacterSheet(hand: widget.hand),
              ],
            );
          } else {
            // Desktop layout
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildSceneArea(),
                ),
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
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: 'Scene',
                ),
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
          'assets/images/d6.png',
          height: 40,
          width: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  void _onCardTap(CharacterCard card) {
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
                        SizedBox(height: 15.0),
                        Text("Basic Move", style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When you try something that is dangerous or difficult, check to see if another moves applies, if not determine what stat (Power, Smarts, Charm, or Grit) the move requires and roll 2d6 then add that stat's modifier to the roll. On a 10+, you pull it off as well as one could hope; on a 7-9, you can do it, but at a lesser success, a cost, or a consequence; on a 6-, it goes terribly wrong, collect 1 Coin.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 15.0),
                        Text("Taking Damage", style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When a foe or a bad roll causes you to take damage, reduce your HP by that amount (less armor, if appropriate) and describe the result.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 15.0),
                        Text("Aid an Ally", style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When you help another character who's about to roll, they gain advantage but you are exposed to any risks, costs, or consequences.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 15.0),
                        Text("Advantage/Disadvatage",
                            style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When a move says to roll \"with advantage\" roll an extra die and discard the lowest result. For disadvantage, roll an extra die and discard the highest.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 15.0),
                        Text("Last Breath", style: Theme.of(context).textTheme.headlineMedium),
                        Text(
                            "When you are dying, you catch a glimpse of what lies beyond the Black Gates of Death (describe it). Then roll +nothing, on a 10+, you've cheated death—you're no longer dying but you're still in a bad place; on a 7-9, Death will offer you a bargain—take it and stabilize or refuse and pass beyond the Black Gates into whatever fate awaits you; on a 6-, your fate is sealed. You're marked as Death's own and you'll cross the threshold soon. The GM will tell you when.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: 15.0),
                        Text("Leveling Up", style: Theme.of(context).textTheme.headlineMedium),
                        Text("Using Coin", style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                            "Spend 1 Coin to add +1 to a roll, after rolling.\nSpend 5 Coin to draw another Character Card.\nSpend 5 Coin to increase one stat by +1, to max of +3.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text("Earning Coin", style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                            "Collect Coin when you roll a 6-.\nCollect Coin when a Move says to.\nCollect coin when you sell a treasure.",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ]));
            });
      },
    );
  }

  Future<void> _leaveRoom() async {
    // Remove the player from the room in Firestore
    if (_roomId != null && widget.hand.id != null) {
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(_roomId)
          .collection('players')
          .where('id', isEqualTo: widget.hand.id)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    }

    // Clear the room code from the character data
    widget.hand.updateStat('roomCode', '');

    // Update the state
    setState(() {
      _roomId = null;
    });
  }
}
