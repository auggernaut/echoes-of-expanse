import 'package:flutter/material.dart';
import 'adventure_data.dart';
import 'paginated_carousel.dart';
import 'scene_area.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameMasterView extends StatefulWidget {
  final String roomId;

  const GameMasterView({Key? key, required this.roomId}) : super(key: key);

  @override
  _GameMasterViewState createState() => _GameMasterViewState();
}

class _GameMasterViewState extends State<GameMasterView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _cardTypes = ['Threats', 'Items', 'Characters', 'Locations'];
  String selectedDeck = 'Threats';
  List<AdventureCard> currentDeck = [];
  int currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _cardTypes.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    currentDeck = _getDeckForType(selectedDeck);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        selectedDeck = _cardTypes[_tabController.index];
        currentDeck = _getDeckForType(selectedDeck);
        currentCardIndex = 0;
      });
    }
  }

  List<AdventureCard> _getDeckForType(String type) {
    switch (type) {
      case 'Threats':
        return threatCards;
      case 'Items':
        return itemCards;
      case 'Characters':
        return characterCards;
      case 'Locations':
        return locationCards;
      default:
        return [];
    }
  }

  void _addCardToScene(AdventureCard card) {
    FirebaseFirestore.instance.collection('rooms').doc(widget.roomId).collection('scene').add({
      'type': card.type,
      'name': card.name,
      'isFlipped': card.isFlipped,
      'frontAsset': card.frontAsset,
      'backAsset': card.backAsset,
      'position': {'x': 0, 'y': 0},
    });
  }

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
            child: SceneArea(roomId: widget.roomId),
          ),
          Expanded(
            flex: 3,
            child: _buildCardBrowsingArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBrowsingArea() {
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: _cardTypes.map((type) => Tab(text: type)).toList(),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: currentDeck.isEmpty
                ? Center(child: Text('No cards in this deck'))
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
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (currentDeck.isNotEmpty && currentCardIndex < currentDeck.length) {
                              _addCardToScene(currentDeck[currentCardIndex]);
                            }
                          },
                          child: Text('Add to Scene'),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
