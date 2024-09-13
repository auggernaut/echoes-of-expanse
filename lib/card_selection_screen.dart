import 'package:flutter/material.dart';
import 'character_data.dart'; // Assuming this file contains your Deck and CharacterCard models
import 'cards_carousel.dart'; // Your existing CardsCarousel widget

class CardSelectionScreen extends StatefulWidget {
  final List<CharacterCard> cards;
  final int maxCards;
  final Function(List<CharacterCard>) onSubmit;
  final String title;

  const CardSelectionScreen(
      {super.key,
      required this.title,
      required this.cards,
      required this.maxCards,
      required this.onSubmit});

  @override
  _CardSelectionScreenState createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends State<CardSelectionScreen> {
  final List<CharacterCard> _selectedCards = [];

  void _toggleCardSelection(CharacterCard card) {
    setState(() {
      if (_selectedCards.contains(card)) {
        _selectedCards.remove(card);
      } else if (_selectedCards.length < widget.maxCards) {
        _selectedCards.add(card);
        if (_selectedCards.length == widget.maxCards) {
          widget.onSubmit(_selectedCards);
          print("Selected Cards: ${_selectedCards.map((c) => c.name).join(', ')}");
          return;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title), automaticallyImplyLeading: false),
        body: Column(
          children: [
            SizedBox(height: 20.0),
            Expanded(
              child: CardsCarousel(
                onCarouselChange: (index) => {},
                cards: widget.cards,
                cardTapBehavior: 'dim',
                onCardTap: _toggleCardSelection,
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ));
  }
}
