import 'package:echoes_of_expanse/data.dart';
import 'package:flutter/material.dart';
import 'lightbox.dart';

class DeckView extends StatefulWidget {
  final Hand hand;

  DeckView({required this.hand});

  @override
  _DeckViewState createState() => _DeckViewState();
}

class _DeckViewState extends State<DeckView> {
  void showLightbox(int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Lightbox(
        cards: widget.hand.selectedCards,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
      ),
      itemCount: widget.hand.selectedCards.length,
      itemBuilder: (context, index) {
        final card = widget.hand.selectedCards[index];
        return GestureDetector(
          onTap: () => showLightbox(index),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
                  child: Image.asset(card.frontAsset, fit: BoxFit.cover)),
              // Text(card.name),
            ],
          ),
        );
      },
    );
  }
}
