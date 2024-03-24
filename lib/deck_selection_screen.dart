import 'package:flutter/material.dart';
import 'data.dart'; // Your data model and predefined decks
import 'cards_carousel.dart'; // Your CardsCarousel widget

class DeckSelectionScreen extends StatefulWidget {
  final Function onDeckSelected;

  const DeckSelectionScreen({
    super.key,
    required this.onDeckSelected,
  });

  @override
  _DeckSelectionScreenState createState() => _DeckSelectionScreenState();
}

class _DeckSelectionScreenState extends State<DeckSelectionScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CardsCarousel(
            onCarouselChange: _onCarouselChange,
            onCardTap: (card) {
              var selectedDeck = decks[currentIndex];
              widget.onDeckSelected(selectedDeck);
            },
            cardTapBehavior: 'dim',
            cards: decks
                .map((deck) => deck.cards.first)
                .toList(), // Assuming the first card represents the deck
          ),
        ),
      ],
    );
  }

  void _onCarouselChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
