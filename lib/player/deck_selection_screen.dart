import 'package:flutter/material.dart';
import 'character_data.dart'; // Your data model and predefined decks
import 'cards_paginated_carousel.dart'; // Your CardsCarousel widget

class DeckSelectionScreen extends StatefulWidget {
  final Function onDeckSelected;
  final String title;

  const DeckSelectionScreen({super.key, required this.onDeckSelected, required this.title});

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
    return Scaffold(
        appBar: AppBar(title: Text(widget.title), automaticallyImplyLeading: false),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            Expanded(
              child: CardsPaginatedCarousel(
                onPageChanged: _onCarouselChange,
                onCardTap: (card) {
                  var selectedDeck = decks[currentIndex];
                  widget.onDeckSelected(selectedDeck);
                },
                cards: decks
                    .map((deck) => deck.cards.first)
                    .toList(), // Assuming the first card represents the deck
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ));
  }

  void _onCarouselChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
