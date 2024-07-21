import 'package:echoes_of_expanse/data.dart';
import 'package:flutter/material.dart';

class Lightbox extends StatefulWidget {
  final List<PlayingCard> cards;
  final int initialIndex;

  Lightbox({required this.cards, required this.initialIndex});

  @override
  _LightboxState createState() => _LightboxState();
}

class _LightboxState extends State<Lightbox> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
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
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Image.asset(card.frontAsset, fit: BoxFit.contain),
          ),
          Text(card.name),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(icon: Icon(Icons.arrow_left), onPressed: _previousCard),
              IconButton(icon: Icon(Icons.close), onPressed: _closeLightbox),
              IconButton(icon: Icon(Icons.arrow_right), onPressed: _nextCard),
            ],
          ),
        ],
      ),
    );
  }
}
