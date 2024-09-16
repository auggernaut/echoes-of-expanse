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
      const cardWidth = 250.0; // Reduced from 300.0
      final crossAxisCount = (screenWidth / cardWidth).floor();

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 748 / 1044, // Keep the aspect ratio of the card images
        ),
        itemCount: widget.hand.selectedCards.length,
        itemBuilder: (context, index) {
          final card = widget.hand.selectedCards[index];
          return GestureDetector(
            onTap: () => showLightbox(index),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(4.0), // Reduced padding
                    child: Image.asset(card.frontAsset, fit: BoxFit.contain),
                  ),
                ),
                // Uncomment the following line if you want to show card names
                // Text(card.name, style: TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      );
    });
  }
}
