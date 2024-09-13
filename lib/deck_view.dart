import 'package:echoes_of_expanse/character_data.dart';
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
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      const cardWidth = 300.0; // Adjust to fit 2 columns with padding
      final crossAxisCount = (screenWidth / cardWidth).floor();

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 748 / 1044, // Aspect ratio of the card images
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
    });
  }
}
