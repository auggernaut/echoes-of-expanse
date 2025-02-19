import 'package:flutter/material.dart';
import 'adventure_data.dart';
import 'paginated_carousel.dart';
import 'scene_area.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'game_guide.dart';

class GameMasterView extends StatefulWidget {
  final String? roomId;

  const GameMasterView({Key? key, this.roomId}) : super(key: key);

  @override
  _GameMasterViewState createState() => _GameMasterViewState();
}

class _GameMasterViewState extends State<GameMasterView> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _cardTypes = ['Threats', 'Items', 'Characters', 'Locations', 'Hooks'];
  String selectedDeck = 'Threats';
  List<AdventureCard> currentDeck = [];
  int currentCardIndex = 0;
  bool _showGuide = false;
  double _scenePaneWidth = 300.0; // Initial width of the Scene pane

  late TabController _bottomTabController;
  String? _roomId;
  bool _isSceneLoaded = false;
  bool _isCheckingScene = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _cardTypes.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _bottomTabController = TabController(length: 3, vsync: this);
    currentDeck = _getDeckForType(selectedDeck);
    _initializeRoom();
  }

  Future<void> _initializeRoom() async {
    setState(() {
      _isCheckingScene = true;
    });

    _roomId = widget.roomId;
    if (_roomId == null) {
      final prefs = await SharedPreferences.getInstance();
      _roomId = prefs.getString('gamemasterRoomId');
    }

    if (_roomId != null) {
      await _checkExistingScene();
    } else {
      setState(() {
        _isSceneLoaded = false;
        _isCheckingScene = false;
      });
    }
  }

  Future<void> _checkExistingScene() async {
    print('Checking existing scene for room: $_roomId');
    if (_roomId != null) {
      try {
        final roomDoc = await FirebaseFirestore.instance.collection('rooms').doc(_roomId).get();

        if (roomDoc.exists) {
          print('Room document exists');
          setState(() {
            _isSceneLoaded = true;
            _isCheckingScene = false;
          });
        } else {
          print('Room document does not exist');
          setState(() {
            _isSceneLoaded = false;
            _isCheckingScene = false;
          });
        }
      } catch (e) {
        print('Error checking scene: $e');
        setState(() {
          _isSceneLoaded = false;
          _isCheckingScene = false;
        });
      }
    } else {
      print('No room ID available');
      setState(() {
        _isSceneLoaded = false;
        _isCheckingScene = false;
      });
    }
    print('Is scene loaded: $_isSceneLoaded');
  }

  String _generateSimpleRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(4, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _createNewScene() async {
    String newRoomCode;
    bool isUnique;
    int attempts = 0;
    const maxAttempts = 5;

    do {
      newRoomCode = _generateSimpleRoomCode();
      // Check if the room code already exists
      final docSnapshot =
          await FirebaseFirestore.instance.collection('rooms').doc(newRoomCode).get();
      isUnique = !docSnapshot.exists;
      attempts++;
    } while (!isUnique && attempts < maxAttempts);

    if (!isUnique) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate a unique room code. Please try again.')),
      );
      return;
    }

    // Save the new room code to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gamemasterRoomId', newRoomCode);

    // Create the new room in Firestore
    await FirebaseFirestore.instance.collection('rooms').doc(newRoomCode).set({
      'createdAt': FieldValue.serverTimestamp(),
      // Add any other initial room data here
    });

    // Update the state
    setState(() {
      _roomId = newRoomCode;
      _isSceneLoaded = true;
    });

    // Show the room code to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New room created. Room code: $newRoomCode')),
    );
  }

  Future<void> _enterRoomCode(String code) async {
    // Verify if the room exists
    final roomDoc = await FirebaseFirestore.instance.collection('rooms').doc(code).get();

    if (roomDoc.exists) {
      // Save the room ID to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('gamemasterRoomId', code);

      // Update the state
      setState(() {
        _roomId = code;
        _isSceneLoaded = true;
      });
    } else {
      // Show an error message that the room doesn't exist
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room not found. Please check the code and try again.')));
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        selectedDeck = _cardTypes[_tabController.index];
        print('Selected deck: $selectedDeck');
        currentDeck = _getDeckForType(selectedDeck);
        print('Current deck: $currentDeck');
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
      case 'Hooks':
        return hookCards;
      default:
        return [];
    }
  }

  void _addCardToScene(AdventureCard card) {
    if (_roomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No active room. Please create or join a room first.')),
      );
      return;
    }

    FirebaseFirestore.instance.collection('rooms').doc(_roomId).collection('scene').add({
      'type': card.type,
      'name': card.name,
      'isFlipped': card.isFlipped,
      'frontAsset': card.frontAsset,
      'backAsset': card.backAsset,
      'position': {'x': 0, 'y': 0},
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Card added to scene')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add card: $error')),
      );
    });
  }

  Widget _buildSceneCreationOptions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _createNewScene,
            child: Text('Create New Room'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showEnterRoomCodeDialog(),
            child: Text('Enter Room Code'),
          ),
        ],
      ),
    );
  }

  void _showEnterRoomCodeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String code = '';
        return AlertDialog(
          title: Text('Enter Room Code'),
          content: TextField(
            onChanged: (value) => code = value,
            decoration: InputDecoration(hintText: "Room Code"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Enter'),
              onPressed: () {
                Navigator.pop(context);
                _enterRoomCode(code);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halls of the Blood King'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              setState(() {
                _showGuide = !_showGuide;
              });
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isCheckingScene) {
      return Center(child: CircularProgressIndicator());
    }

    if (_roomId != null && _isSceneLoaded) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout();
          } else {
            return _buildDesktopLayout();
          }
        },
      );
    } else {
      return _buildSceneCreationOptions();
    }
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildLeaveRoomButton(),
        Expanded(
          child: Stack(
            children: [
              TabBarView(
                controller: _bottomTabController,
                children: [
                  SceneArea(roomId: _roomId!),
                  _buildCardBrowsingArea(),
                ],
              ),
              if (_showGuide)
                Positioned.fill(
                  child: Material(
                    elevation: 8,
                    child: GameGuide(),
                  ),
                ),
            ],
          ),
        ),
        TabBar(
          controller: _bottomTabController,
          tabs: [
            Tab(text: 'Scene'),
            Tab(text: 'Cards'),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              // Scene pane
              SizedBox(
                width: _scenePaneWidth,
                child: Column(
                  children: [
                    _buildLeaveRoomButton(),
                    Expanded(child: SceneArea(roomId: _roomId!)),
                  ],
                ),
              ),
              // Draggable divider
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _scenePaneWidth += details.delta.dx;
                    // Ensure the Scene pane doesn't get too small or too large
                    _scenePaneWidth =
                        _scenePaneWidth.clamp(200.0, MediaQuery.of(context).size.width - 400.0);
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: Container(
                    width: 8,
                    color: Colors.grey.withOpacity(0.2),
                    child: Center(
                      child: Container(
                        width: 2,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
              // Deck pane
              Expanded(
                child: _buildCardBrowsingArea(),
              ),
              // Guide pane
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: _showGuide ? 400 : 0,
                child: OverflowBox(
                  minWidth: 0,
                  maxWidth: 400,
                  child: _showGuide
                      ? Container(
                          width: 400,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: GameGuide(),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
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
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            unselectedLabelStyle:
                Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
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
    _bottomTabController.dispose();
    super.dispose();
  }

  Widget _buildLeaveRoomButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Room: $_roomId', style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: _leaveRoom,
            child: Text('Leave Room'),
          ),
        ],
      ),
    );
  }

  Future<void> _leaveRoom() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('gamemasterRoomId');
    setState(() {
      _roomId = null;
      _isSceneLoaded = false;
    });
  }
}
