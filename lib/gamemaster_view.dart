import 'package:flutter/material.dart';
import 'adventure_data.dart';
import 'paginated_carousel.dart';
import 'scene_area.dart';

class GameMasterView extends StatefulWidget {
  const GameMasterView({Key? key}) : super(key: key);

  @override
  _GameMasterViewState createState() => _GameMasterViewState();
}

class _GameMasterViewState extends State<GameMasterView> {
  String selectedDeck = '';
  List<AdventureCard> currentDeck = [];
  List<AdventureCard> selectedCards = [];
  int currentCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Master'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: SceneArea(selectedCards: selectedCards),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: _buildCardBrowsingArea(),
                ),
                Expanded(
                  flex: 1,
                  child: _buildDeckSelectionArea(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrowsingArea() {
    return Container(
      color: Colors.black12,
      child: currentDeck.isEmpty
          ? Center(child: Text('Select a deck to browse cards'))
          : Column(
              children: [
                Expanded(
                  child: PaginatedCarousel(
                    cards: currentDeck,
                    onPageChanged: (index) {
                      setState(() {
                        currentCardIndex = index;
                      });
                    },
                    onCardTap: (card) {
                      setState(() {
                        card.flip();
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentDeck.isNotEmpty && currentCardIndex < currentDeck.length) {
                      setState(() {
                        selectedCards.add(currentDeck[currentCardIndex]);
                      });
                    }
                  },
                  child: Text('Add to Scene'),
                ),
              ],
            ),
    );
  }

  Widget _buildDeckSelectionArea() {
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDeckButton('Threats', threatCards),
          _buildDeckButton('Items', itemCards),
          _buildDeckButton('Characters', characterCards),
          _buildDeckButton('Locations', locationCards),
        ],
      ),
    );
  }

  Widget _buildDeckButton(String deckName, List<AdventureCard> deck) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              selectedDeck = deckName;
              currentDeck = List.from(deck); // Create a copy of the deck
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedDeck == deckName ? Colors.black12 : null,
          ),
          child: Text(deckName, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
