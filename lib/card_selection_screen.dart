import 'package:flutter/material.dart';
import 'data.dart'; // Assuming this file contains your Deck and PlayingCard models
import 'cards_carousel.dart'; // Your existing CardsCarousel widget

class CardSelectionScreen extends StatefulWidget {
  final List<PlayingCard> cards;
  final int maxCards;
  final Function(List<PlayingCard>) onSubmit;

  const CardSelectionScreen(
      {super.key, required this.cards, required this.maxCards, required this.onSubmit});

  @override
  _CardSelectionScreenState createState() => _CardSelectionScreenState();
}

class _CardSelectionScreenState extends State<CardSelectionScreen> {
  final List<PlayingCard> _selectedCards = [];

  void _toggleCardSelection(PlayingCard card) {
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
    return Column(
      children: [
        Expanded(
          child: CardsCarousel(
            onCarouselChange: (index) => {},
            cards: widget.cards,
            cardTapBehavior: 'dim',
            onCardTap: _toggleCardSelection,
          ),
        ),
      ],
    );
  }
}
