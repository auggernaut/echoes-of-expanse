import 'package:echoes_of_expanse/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Lightbox extends StatefulWidget {
  final List<PlayingCard> cards;
  final int initialIndex;

  Lightbox({required this.cards, required this.initialIndex});

  @override
  _LightboxState createState() => _LightboxState();
}

class _LightboxState extends State<Lightbox> {
  int currentIndex = 0;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
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
    final cardWidth = 374.0;
    final cardHeight = 522.0;
    final lightboxWidth = cardWidth * 1.5;
    final lightboxHeight = cardHeight * 1.2;

    return Dialog(
      insetPadding: EdgeInsets.all(10),
      backgroundColor: Colors.transparent, // Ensure the Dialog itself is transparent
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _nextCard();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _previousCard();
            }
          }
        },
        child: Container(
          width: lightboxWidth,
          height: lightboxHeight + 100, // Adjust for text and buttons
          color: Colors.white, // Set the internal Container's background color to white
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: lightboxWidth,
                    height: lightboxHeight,
                    child: Image.asset(card.frontAsset, fit: BoxFit.contain),
                  ),
                  Text(
                    card.description,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.close, size: 30),
                  onPressed: _closeLightbox,
                ),
              ),
              Positioned(
                top: lightboxHeight / 2 - 25,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_left, size: 50),
                  onPressed: _previousCard,
                ),
              ),
              Positioned(
                top: lightboxHeight / 2 - 25,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_right, size: 50),
                  onPressed: _nextCard,
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
