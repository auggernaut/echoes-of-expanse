import 'package:echoes_of_expanse/player/card_selection_screen.dart';
import 'package:echoes_of_expanse/player/cards_masonry.dart';
import 'package:echoes_of_expanse/player/character_data.dart'; // Ensure this contains your Deck, CharacterCard models
import 'package:echoes_of_expanse/player/deck_selection_screen.dart';
import 'package:echoes_of_expanse/player/game_screen.dart';
import 'package:flutter/material.dart';

class CharacterCreationManager extends StatefulWidget {
  @override
  _CharacterCreationManagerState createState() => _CharacterCreationManagerState();
}

class _CharacterCreationManagerState extends State<CharacterCreationManager> {
  late Deck selectedDeck = decks.first;
  late CharacterCard selectedBackground = decks.first.cards.first;
  late CharacterCard selectedAncestry = decks.first.cards.first;
  late CharacterCard selectedBond = decks.first.cards.first;
  late CharacterCard selectedDrive = decks.first.cards.first;
  late List<CharacterCard> selectedSkills = decks.first.cards;

  String instructions = "Pick a character class";

  int _currentStep = 0;
  Hand userHand = Hand();

  @override
  Widget build(BuildContext context) {
    List<Widget> steps = [
      DeckSelectionScreen(onDeckSelected: _selectDeck, title: instructions),
      CardSelectionScreen(
        key: UniqueKey(),
        title: instructions,
        cards: selectedDeck.cards.where((card) => card.type == 'background').toList(),
        maxCards: 1,
        onSubmit: _selectBackground,
      ),
      CardSelectionScreen(
        key: UniqueKey(),
        title: instructions,
        cards: selectedDeck.cards.where((card) => card.type == 'ancestry').toList(),
        maxCards: 1,
        onSubmit: _selectAncestry,
      ),
      CardSelectionScreen(
        key: UniqueKey(),
        title: instructions,
        cards: selectedDeck.cards.where((card) => card.type == 'bond').toList(),
        maxCards: 1,
        onSubmit: _selectBond,
      ),
      CardSelectionScreen(
        key: UniqueKey(),
        title: instructions,
        cards: selectedDeck.cards.where((card) => card.type == 'drive').toList(),
        maxCards: 1,
        onSubmit: _selectDrive,
      ),
      MasonryGridScreen(cards: selectedDeck.cards, onSubmit: _selectSkills),
      // CardSelectionScreen(
      //   key: UniqueKey(),
      //   cards: selectedDeck.cards.where((card) => card.type == 'skill').toList(),
      //   maxCards: 4,
      //   onSubmit: _selectSkills,
      // ),
      // You'll create similar selection screens for background, ancestry, and bond
    ];

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 0.0), child: steps[_currentStep]);
  }

  void _selectDeck(Deck deck) {
    setState(() {
      selectedDeck = deck;
      instructions = "Pick an Background";
      userHand.addCard(deck.cards[0]);
    });
    _goNext();
  }

  void _selectBackground(List<CharacterCard> cards) {
    setState(() {
      selectedBackground = cards[0];
      instructions = "Pick an Ancestry";
      userHand.addCard(selectedBackground);
    });
    _goNext();
  }

  void _selectAncestry(List<CharacterCard> cards) {
    setState(() {
      selectedAncestry = cards[0];
      instructions = "Pick a Bond";
      userHand.addCard(selectedAncestry);
    });
    _goNext();
  }

  void _selectBond(List<CharacterCard> cards) {
    setState(() {
      selectedBond = cards[0];
      instructions = "Pick a Drive";
      userHand.addCard(selectedBond);
    });
    _goNext();
  }

  void _selectDrive(List<CharacterCard> cards) {
    setState(() {
      selectedDrive = cards[0];
      instructions = "Pick 4 more cards...";
      userHand.addCard(selectedDrive);
    });
    _goNext();
  }

  void _selectSkills(List<CharacterCard> cards) {
    for (int i = 0; i < cards.length; i++) {
      userHand.addCard(cards[i]);
    }
    _goNext();
  }

  void _goNext() {
    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GameScreen(hand: userHand)),
      );
    }
  }

  void _goBack() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }
}
