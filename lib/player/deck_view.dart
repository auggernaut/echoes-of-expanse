import 'package:echoes_of_expanse/player/character_data.dart';
import 'package:flutter/material.dart';
import 'lightbox.dart';
import 'package:echoes_of_expanse/player/section_card_selection_screen.dart';

class DeckView extends StatefulWidget {
  final Hand hand;

  DeckView({required this.hand});

  @override
  _DeckViewState createState() => _DeckViewState();
}

class _DeckViewState extends State<DeckView> {
  final double originalCardWidth = 748.0;
  final double originalCardHeight = 1044.0;
  late final double aspectRatio;

  @override
  void initState() {
    super.initState();
    aspectRatio = originalCardWidth / originalCardHeight;
  }

  void showLightbox(int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => Lightbox(
        cards: widget.hand.selectedCards,
        initialIndex: initialIndex,
      ),
    );
  }

  Widget _buildAddCardButton() {
    final classCard = widget.hand.selectedCards.firstWhere(
      (card) => card.type == 'class',
      orElse: () => throw Exception('No class card found in hand'),
    );

    final classDeck = decks.firstWhere(
      (deck) => deck.name == classCard.description,
      orElse: () => throw Exception('No deck found for class ${classCard.description}'),
    );

    return Card(
      elevation: 4,
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SectionCardSelectionScreen(
                  title: 'Add Card',
                  sections: [
                    CardSection(
                      title: 'Recommended',
                      cards: classDeck.cards.where((card) => card.type == 'recommended').toList(),
                      color: Colors.lightBlue.withOpacity(0.2),
                    ),
                    CardSection(
                      title: 'Equipment',
                      cards: classDeck.cards.where((card) => card.type == 'equipment').toList(),
                      color: Colors.lightGreen.withOpacity(0.2),
                    ),
                    CardSection(
                      title: 'Skills',
                      cards: classDeck.cards.where((card) => card.type == 'skill').toList(),
                      color: Colors.amber.withOpacity(0.2),
                    ),
                  ],
                  selectedCards: widget.hand.selectedCards,
                  maxCoins: (10 + widget.hand.coins).toInt(),
                  onSubmit: (selectedCards) {
                    final newCoins = selectedCards.fold<int>(
                      10,
                      (sum, card) => sum - (card.coin),
                    );

                    setState(() {
                      widget.hand.selectedCards
                        ..clear()
                        ..addAll(selectedCards);
                      widget.hand.updateStat('coin', newCoins);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  'Add Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      const cardWidth = 250.0;
      final crossAxisCount = (screenWidth / cardWidth).floor();

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: aspectRatio,
        ),
        itemCount: widget.hand.selectedCards.length + 1, // Add 1 for the button
        itemBuilder: (context, index) {
          if (index == widget.hand.selectedCards.length) {
            return _buildAddCardButton();
          }
          final card = widget.hand.selectedCards[index];
          return GestureDetector(
            onTap: () => showLightbox(index),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage(card.frontAsset),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => showLightbox(index),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
