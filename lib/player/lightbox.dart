import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:echoes_of_expanse/player/character_data.dart';

class Lightbox extends StatefulWidget {
  final List<CharacterCard> cards;
  final int initialIndex;

  Lightbox({required this.cards, required this.initialIndex});

  @override
  _LightboxState createState() => _LightboxState();
}

class _LightboxState extends State<Lightbox> {
  late int currentIndex;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.cards.length;
    });
  }

  void _previousCard() {
    setState(() {
      currentIndex = (currentIndex - 1 + widget.cards.length) % widget.cards.length;
    });
  }

  void _closeLightbox() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[currentIndex];
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.8;
    final cardWidth = cardHeight / 1.4;

    return GestureDetector(
      onTap: _closeLightbox,
      child: Material(
        color: Colors.black54,
        child: RawKeyboardListener(
          focusNode: _focusNode,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                _nextCard();
              } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                _previousCard();
              } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                _closeLightbox();
              }
            }
          },
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: cardWidth,
                      height: cardHeight,
                      child: Image.asset(card.frontAsset, fit: BoxFit.contain),
                    ),
                    SizedBox(height: 16),
                    Text(
                      card.description,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: size.height / 2 - 25,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    _previousCard();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.arrow_left, size: 50, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: size.height / 2 - 25,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    _nextCard();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(16),
                    child: Icon(Icons.arrow_right, size: 50, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
