import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'adventure_data.dart';

class AdventureCardLightbox extends StatefulWidget {
  final List<AdventureCard> cards;
  final int initialIndex;

  const AdventureCardLightbox({Key? key, required this.cards, this.initialIndex = 0})
      : super(key: key);

  @override
  _AdventureCardLightboxState createState() => _AdventureCardLightboxState();
}

class _AdventureCardLightboxState extends State<AdventureCardLightbox> {
  late int currentIndex;
  final FocusNode _focusNode = FocusNode();

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

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[currentIndex];
    final size = MediaQuery.of(context).size;
    final cardHeight = size.height * 0.8;
    final cardWidth = cardHeight / 1.4;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
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
              }
            }
          },
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  child: Image.asset(
                    card.isFlipped ? card.backAsset : card.frontAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: _previousCard,
                ),
              ),
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: _nextCard,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
