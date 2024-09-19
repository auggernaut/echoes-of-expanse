import 'dart:async';

import 'package:echoes_of_expanse/gamemaster/adventure_card_lightbox.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'adventure_data.dart';
import 'package:flutter/gestures.dart';

class SceneArea extends StatefulWidget {
  final String roomId;

  const SceneArea({Key? key, required this.roomId}) : super(key: key);

  @override
  _SceneAreaState createState() => _SceneAreaState();
}

class _SceneAreaState extends State<SceneArea> {
  List<AdventureCard> sceneCards = [];
  late Stream<QuerySnapshot> sceneStream;
  StreamSubscription<QuerySnapshot>? _streamSubscription;
  Offset _sceneOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _listenToSceneChanges();
  }

  void _listenToSceneChanges() {
    sceneStream = FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.roomId)
        .collection('scene')
        .snapshots();

    _streamSubscription = sceneStream.listen((snapshot) {
      if (mounted) {
        setState(() {
          sceneCards = snapshot.docs
              .map((doc) => AdventureCard.fromJson(doc.id, doc.data() as Map<String, dynamic>))
              .toList();
        });
      }
    }, onError: (error) {
      print('Error in sceneStream: $error');
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _updateCardPosition(AdventureCard card, Offset position) {
    if (card.id != null) {
      FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .collection('scene')
          .doc(card.id)
          .update({
        'position': {'x': position.dx, 'y': position.dy},
      }).catchError((error) {
        print('Error updating card position: $error');
      });
    } else {
      print('Error: Card ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      child: ClipRect(
        child: Container(
          color: Colors.grey[200],
          child: Transform.translate(
            offset: _sceneOffset,
            child: Stack(
              children: sceneCards.map((card) => _buildDraggableCard(card)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _sceneOffset += details.delta;
    });
  }

  Widget _buildDraggableCard(AdventureCard card) {
    return Positioned(
      left: card.position['x'] ?? 0,
      top: card.position['y'] ?? 0,
      child: Draggable<AdventureCard>(
        data: card,
        feedback: _buildCardWidget(card),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: _buildCardWidget(card),
        ),
        onDragEnd: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final localPosition = renderBox.globalToLocal(details.offset) - _sceneOffset;
          _updateCardPosition(card, localPosition);
        },
        child: _buildCardWidget(card),
      ),
    );
  }

  Widget _buildCardWidget(AdventureCard card) {
    double width = 100;
    double height = 70;
    BorderRadius borderRadius = BorderRadius.circular(10);

    if (card.type.toLowerCase() == 'location') {
      width = 150;
      height = 105;
    } else if (card.type.toLowerCase() == 'class') {
      width = height = 75; // Make it square for circular clipping
      borderRadius = BorderRadius.circular(50); // Full circle
    }

    return MouseRegion(
      child: GestureDetector(
        onTap: () => _showCardLightbox(card),
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Image.asset(
                  card.isFlipped ? card.backAsset : card.frontAsset,
                  fit: BoxFit.cover,
                  width: width,
                  height: card.type.toLowerCase() == 'class' ? height : height * 2,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              right: 5,
              top: 5,
              child: Visibility(
                visible: card.isHovered,
                child: GestureDetector(
                  onTap: () => _removeCard(card),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onEnter: (_) => setState(() => card.isHovered = true),
      onExit: (_) => setState(() => card.isHovered = false),
    );
  }

  void _showCardLightbox(AdventureCard card) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AdventureCardLightbox(
        cards: sceneCards,
        initialIndex: sceneCards.indexOf(card),
      ),
    );
  }

  void _removeCard(AdventureCard card) {
    if (card.id != null) {
      FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomId)
          .collection('scene')
          .doc(card.id)
          .delete();
    } else {
      print('Error: Card ID is null');
    }
  }
}
